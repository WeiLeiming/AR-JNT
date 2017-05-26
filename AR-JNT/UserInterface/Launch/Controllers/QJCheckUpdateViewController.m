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

@interface QJCheckUpdateViewController ()

@property (nonatomic, strong) QJCheckUpdateView *checkUpdateView;

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
    [self startProgressSequenceAnimation];
    [self fetchSyetemStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Progress Animation
- (void)startProgressSequenceAnimation {
    [self.checkUpdateView qj_startProgressSequenceAnimation];
    [NSTimer scheduledTimerWithTimeInterval:kProgressAnimationDuration + 0.2f target:self selector:@selector(timerCallBack) userInfo:nil repeats:NO];
}

- (void)timerCallBack {
    [self.checkUpdateView qj_removeProgressSequenceAnimation];
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
