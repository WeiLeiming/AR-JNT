//
//  QJConnectBluetoothViewController.m
//  AR-JNT
//
//  Created by willwei on 2017/5/26.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJConnectBluetoothViewController.h"
#import "QJConnectBluetoothView.h"

static const CGFloat kAnimationDuration = 0.4f;

@interface QJConnectBluetoothViewController ()

@property (nonatomic, strong) QJConnectBluetoothView *bluetoothView;
@property (nonatomic, strong) UIImageView *flashViewImage;

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
    [self startFlashAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Animation
/**
 *  枪柄闪烁动画
 */
- (void)startFlashAnimation {
    self.flashViewImage = ({
        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.image = [UIImage imageNamed:@"Flash_00000"];
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-260.f / 2 * SCREEN_SCALE_LANDSCAPE);
            make.right.equalTo(self.view.mas_right).offset(-342.f / 2 * SCREEN_SCALE_LANDSCAPE);
            make.width.mas_equalTo(40.f / 2 * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(40.f / 2 * SCREEN_SCALE_LANDSCAPE);
        }];
        imageView;
    });
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i <= 20; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Flash_000%02d", i] ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [images addObject:image];
    }
    self.flashViewImage.animationDuration = kAnimationDuration;
    self.flashViewImage.animationRepeatCount = 0;
    self.flashViewImage.animationImages = images;
    [self.flashViewImage startAnimating];
}

@end
