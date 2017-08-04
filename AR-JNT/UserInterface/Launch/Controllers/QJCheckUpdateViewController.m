//
//  QJCheckUpdateViewController.m
//  AR-JNT
//
//  Created by willwei on 17/5/24.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJCheckUpdateViewController.h"
#import "QJCheckUpdateView.h"
#import "QJNetworkingRequest.h"
#import "QJConnectBluetoothViewController.h"
#import "QJNoNetworkView.h"
#import "QJDateHelper.h"

@interface QJCheckUpdateViewController () <QJNoNetworkViewDelegate>

@property (nonatomic, strong) QJCheckUpdateView *checkUpdateView;
@property (nonatomic, strong) QJNoNetworkView *noNetworkView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSNumber *serviceState;

@property (nonatomic, strong) QJDateHelper *dateHelper;

@property (nonatomic, assign, getter=isAnimationOver) BOOL animationOver;
@property (nonatomic, assign, getter=isFetchOver) BOOL fetchOver;
@property (nonatomic, assign, getter=isOverdue) BOOL overdue;

@end

@implementation QJCheckUpdateViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc: %@", self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBackgroundUI];
    self.overdue = self.dateHelper.isOverdue;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusNotifation:) name:@"NetworkStatus" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter

- (QJDateHelper *)dateHelper {
    if (!_dateHelper) {
        _dateHelper = [[QJDateHelper alloc] init];
    }
    return _dateHelper;
}

- (QJCheckUpdateView *)checkUpdateView {
    if (!_checkUpdateView) {
        _checkUpdateView = [[QJCheckUpdateView alloc] init];
        [self.view addSubview:_checkUpdateView];
        [_checkUpdateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _checkUpdateView;
}

- (QJNoNetworkView *)noNetworkView {
    if (!_noNetworkView) {
        _noNetworkView = [[QJNoNetworkView alloc] init];
        [self.view addSubview:_noNetworkView];
        [_noNetworkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _noNetworkView;
}

#pragma mark - UI
- (void)initBackgroundUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"NoNetworkBackground"];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Notification
- (void)networkStatusNotifation:(NSNotification *)sender {
    [self checkNetwork];
}

#pragma mark - Progress Animation
- (void)startProgressSequenceAnimation {
    [self.checkUpdateView qj_startProgressSequenceAnimation];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kProgressAnimationDuration + 0.2f target:self selector:@selector(timerCallBack) userInfo:nil repeats:NO];
}

- (void)timerCallBack {
    [self.timer invalidate];
    self.timer = nil;
    self.animationOver = YES;
    [self.checkUpdateView qj_removeProgressSequenceAnimation];
    [self jumpToNextInterface];
}

#pragma mark - Network
- (void)fetchSyetemStatus {
    // http://ip:port/macup/state/
    NSString *urlStr = [kMainServerUrl stringByAppendingString:@"/macup/state/"];
    [QJNetworkingRequest GET:urlStr parameters:nil needCache:NO success:^(id operation, id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        self.fetchOver = YES;
        self.serviceState = (NSNumber *)responseObject[@"state"];
        [self jumpToNextInterface];
    } failure:^(id operation, NSError *error) {
        NSLog(@"error: %@", error);
        [self showInfoWithStatus:QJLocalizedStringFromTable(@"发生错误，请重试", @"Localizable")];
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
            [self.checkUpdateView qj_removeProgressSequenceAnimation];
        }
        self.fetchOver = NO;
        self.animationOver = NO;
        self.noNetworkView.delegate = self;
    }];
}

#pragma mark - Check network
- (void)checkNetwork {
    if (kAppDelegate.networkStatus == AFNetworkReachabilityStatusNotReachable || kAppDelegate.networkStatus == AFNetworkReachabilityStatusUnknown) {
        self.noNetworkView.delegate = self;
    } else {
        if (self.noNetworkView) {
            [self.noNetworkView removeFromSuperview];
            self.noNetworkView = nil;
        }
        if (self.isOverdue) {
            [self fetchSyetemStatus];
        }
        [self startProgressSequenceAnimation];
    }
}

#pragma mark - HUD
- (void)showInfoWithStatus:(NSString *)status {
    [SVProgressHUD showImage:nil status:status];
    [SVProgressHUD dismissWithDelay:kProgressHUDShowDuration];
}

#pragma mark - QJNoNetworkViewDelegate
- (void)noNetworkView:(QJNoNetworkView *)view retryButtonClicked:(UIButton *)sender {
    if (kAppDelegate.networkStatus == AFNetworkReachabilityStatusNotReachable) {
        [self showInfoWithStatus:QJLocalizedStringFromTable(@"网络不可用", @"Localizable")];
        return;
    }
    if (self.noNetworkView) {
        [self.noNetworkView removeFromSuperview];
        self.noNetworkView = nil;
    }
    if (self.isOverdue) {
        [self fetchSyetemStatus];
    }
    [self startProgressSequenceAnimation];
}

#pragma mark - Jump
- (void)jumpToNextInterface {
    NSLog(@"serviceState:%@, isOverdue:%d, isAnimationOver:%d, isFetchOver:%d", self.serviceState, self.isOverdue, self.isAnimationOver, self.isFetchOver);
    if (self.serviceState && [self.serviceState isEqual:@(0)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkStatus" object:nil];
        [self showInfoWithStatus:QJLocalizedStringFromTable(@"服务器已关闭", @"Localizable")];
        return;
    }
    
    if (self.isOverdue) {
        if (self.isAnimationOver && self.isFetchOver) {
            [self.dateHelper qj_saveCurrentDate];
        } else {
            return;
        }
    } else {
        if (!self.isAnimationOver) {
            return;
        }
    }
    
    QJConnectBluetoothViewController *bluetoothVC = [[QJConnectBluetoothViewController alloc] init];
    kAppDelegate.window.rootViewController = bluetoothVC;
}

@end
