//
//  QJConnectBluetoothViewController.m
//  AR-JNT
//
//  Created by willwei on 2017/5/26.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJConnectBluetoothViewController.h"
#import "QJConnectBluetoothView.h"

@interface QJConnectBluetoothViewController ()

@property (nonatomic, strong) QJConnectBluetoothView *bluetoothView;

@end

@implementation QJConnectBluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bluetoothView = [[QJConnectBluetoothView alloc] init];
    [self.view addSubview:self.bluetoothView];
    [self.bluetoothView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self startFlashSequenceAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flash Animation
- (void)startFlashSequenceAnimation {
    [self.bluetoothView qj_startFlashSequenceAnimation];
}

@end
