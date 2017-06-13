//
//  QJNoNetworkView.m
//  AR-JNT
//
//  Created by willwei on 2017/5/26.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJNoNetworkView.h"

@interface QJNoNetworkView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *promptImageView;
@property (nonatomic, strong) UIButton *retryButton;

@end

@implementation QJNoNetworkView

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
        imageView.image = [UIImage imageNamed:@"NoNetworkBackground"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        imageView;
    });
    self.logoImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"NoNetworkLogo"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(15.f * SCREEN_SCALE_LANDSCAPE);
            make.left.equalTo(self.mas_left).offset(20.f * SCREEN_SCALE_LANDSCAPE);
            make.width.mas_equalTo(87.f * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(34.f * SCREEN_SCALE_LANDSCAPE);
        }];
        imageView;
    });
    self.promptImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *localizedString = QJLocalizedStringFromTable(@"NoNetworkPrompt", @"Localizable");
        imageView.image = [UIImage imageNamed:localizedString];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.equalTo(self.mas_top).offset(110.f * SCREEN_SCALE_LANDSCAPE);
            make.width.mas_equalTo(314.f * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(134.f * SCREEN_SCALE_LANDSCAPE);
        }];
        imageView;
    });
    self.retryButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *localizedString = QJLocalizedStringFromTable(@"NoNetworkBtn_Retry", @"Localizable");
        NSString *localizedString_Click = QJLocalizedStringFromTable(@"NoNetworkBtn_Retry_Click", @"Localizable");
        [button setImage:[UIImage imageNamed:localizedString] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:localizedString_Click] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(retryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-89.f * SCREEN_SCALE_LANDSCAPE);
            make.width.mas_equalTo(89.f * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(29.f * SCREEN_SCALE_LANDSCAPE);
        }];
        button;
    });
}

#pragma mark - Action
- (void)retryButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(noNetworkView:retryButtonClicked:)]) {
        [self.delegate noNetworkView:self retryButtonClicked:sender];
    }
}

@end
