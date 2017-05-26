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
@property (nonatomic, strong) UIImageView *progressBackgroundImageView;
@property (nonatomic, strong) UIImageView *progressImageView;

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
- (void)initCustomUI {
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
            make.top.mas_equalTo(self.mas_top).offset(290.f / 2 * SCREEN_SCALE_LANDSCAPE);
            make.width.mas_equalTo(112.f * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(70.f * SCREEN_SCALE_LANDSCAPE);
        }];
        imageView;
    });
    self.progressBackgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"Progress_00030@2x"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(460.f * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(57.f * SCREEN_SCALE_LANDSCAPE);
        }];
        imageView;
    });
    self.progressImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(460.f * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(57.f * SCREEN_SCALE_LANDSCAPE);
        }];
        imageView;
    });
}

#pragma mark - Public Method
- (void)qj_startProgressSequenceAnimation {
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i <= 30; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Progress_000%02d@2x", i] ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [images addObject:image];
    }
    self.progressImageView.animationDuration = kProgressAnimationDuration;
    self.progressImageView.animationRepeatCount = 1;
    self.progressImageView.animationImages = images;
    [self.progressImageView startAnimating];
}

- (void)qj_removeProgressSequenceAnimation {
    [self.progressImageView removeFromSuperview];
    self.progressImageView = nil;
}

@end
