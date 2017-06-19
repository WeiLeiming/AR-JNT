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

@interface QJCheckUpdateViewController () <QJNoNetworkViewDelegate>

@property (nonatomic, strong) QJCheckUpdateView *checkUpdateView;
@property (nonatomic, strong) QJNoNetworkView *noNetworkView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation QJCheckUpdateViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NetworkStatus" object:nil];
    NSLog(@"dealloc: %@", self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBackgroundUI];
    NSNumber *systemState = [[NSUserDefaults standardUserDefaults] objectForKey:@"systemState"];
    if ([systemState isEqual:@(1)] || systemState == nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusNotifation:) name:@"NetworkStatus" object:nil];
    } else if ([systemState isEqual:@(0)]) {
        self.noNetworkView.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter
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
    [self.checkUpdateView qj_removeProgressSequenceAnimation];
    QJConnectBluetoothViewController *bluetoothVC = [[QJConnectBluetoothViewController alloc] init];
    kAppDelegate.window.rootViewController = bluetoothVC;
}

#pragma mark - Network
- (void)fetchSyetemStatus {
    // http://ip:port/macup/state/
    NSString *urlStr = [kMainServerUrl stringByAppendingString:@"/macup/state/"];
    [QJNetworkingRequest GET:urlStr parameters:nil needCache:NO success:^(id operation, id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        NSNumber *state = (NSNumber *)responseObject[@"state"];
        [[NSUserDefaults standardUserDefaults] setObject:state forKey:@"systemState"];
    } failure:^(id operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark - Check network
- (void)checkNetwork {
    if (kAppDelegate.networkStatus == AFNetworkReachabilityStatusUnknown) {
        
    } else if (kAppDelegate.networkStatus == AFNetworkReachabilityStatusNotReachable) {
        self.noNetworkView.delegate = self;
    } else {
        [self startProgressSequenceAnimation];
        [self fetchSyetemStatus];
    }
}

#pragma mark - HUD
- (void)showInfoWithStatus:(NSString *)status {
    [SVProgressHUD showImage:nil status:status];
    [SVProgressHUD dismissWithDelay:kProgressHUDShowDuration];
}

#pragma mark - QJNoNetworkViewDelegate
- (void)noNetworkView:(QJNoNetworkView *)view retryButtonClicked:(UIButton *)sender {
    [self showInfoWithStatus:QJLocalizedStringFromTable(@"网络不可用", @"Localizable")];
}

@end
