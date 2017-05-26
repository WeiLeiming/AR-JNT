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

static const CGFloat kAnimationDuration = 1.f;

@interface QJCheckUpdateViewController ()

@property (nonatomic, strong) QJCheckUpdateView *checkUpdateView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *progressImageView;

@end

@implementation QJCheckUpdateViewController

- (void)dealloc {
    NSLog(@"dealloc: %@", self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.checkUpdateView = [[QJCheckUpdateView alloc] init];
    [self.view addSubview:self.checkUpdateView];
    [self.checkUpdateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self startProgressAnimation];
    [self fetchSyetemStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Animation
/**
 *  进度条动画
 */
- (void)startProgressAnimation {
    self.bgImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"Progress_00030@2x"];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.mas_equalTo(460.f * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(57.f * SCREEN_SCALE_LANDSCAPE);
        }];
        imageView;
    });
    self.progressImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"Progress_00000@2x"];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view);
            make.width.mas_equalTo(460.f * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(57.f * SCREEN_SCALE_LANDSCAPE);
        }];
        imageView;
    });
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i <= 30; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Progress_000%02d@2x", i] ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [images addObject:image];
    }
    self.progressImageView.animationDuration = kAnimationDuration;
    self.progressImageView.animationRepeatCount = 1;
    self.progressImageView.animationImages = images;
    [self.progressImageView startAnimating];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationDuration target:self selector:@selector(timerCallBack) userInfo:nil repeats:NO];
}

/**
 *  进度条动画结束
 */
- (void)timerCallBack {
    [self.progressImageView removeFromSuperview];
    self.progressImageView = nil;
    QJConnectBluetoothViewController *bluetoothVC = [[QJConnectBluetoothViewController alloc] init];
    kAppDelegate.window.rootViewController = bluetoothVC;
}

#pragma mark - Network
- (void)fetchSyetemStatus {
    NSString *path = [kMainServerUrl stringByAppendingString:@"/macup/state/"];
    [QJNetworkingRequest GET:path parameters:nil needCache:NO success:^(id operation, id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
    } failure:^(id operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
