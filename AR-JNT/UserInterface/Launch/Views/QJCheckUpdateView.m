//
//  QJCheckUpdateView.m
//  AR-JNT
//
//  Created by willwei on 17/5/24.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJCheckUpdateView.h"

@interface QJCheckUpdateView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation QJCheckUpdateView

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
        imageView.image = [UIImage imageNamed:@"CheckUpdateBackground"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        imageView;
    });
    self.logoImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"CheckUpdateLogo"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.mas_top).offset(290.f / 2 * SCREEN_SCALE_HEIGHT);
            make.width.mas_equalTo(112.f * SCREEN_SCALE_HEIGHT);
            make.height.mas_equalTo(70.f * SCREEN_SCALE_HEIGHT);
        }];
        imageView;
    });
}

@end
