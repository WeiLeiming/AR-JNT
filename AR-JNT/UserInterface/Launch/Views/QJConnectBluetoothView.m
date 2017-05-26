//
//  QJConnectBluetoothView.m
//  AR-JNT
//
//  Created by willwei on 2017/5/26.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJConnectBluetoothView.h"

@interface QJConnectBluetoothView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation QJConnectBluetoothView

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initCustomUI];
    }
    return self;
}

#pragma mark - UI
- (void)initCustomUI{
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"Bluetooth"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        imageView;
    });
}

@end
