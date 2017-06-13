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
@property (nonatomic, strong) UIImageView *flashViewImage;
@property (nonatomic, strong) UIButton *languageBtn;

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
- (void)initCustomUI {
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *localizedString = QJLocalizedStringFromTable(@"Bluetooth", @"Localizable");
        imageView.image = [UIImage imageNamed:localizedString];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        imageView;
    });
    self.flashViewImage = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-260.f / 2 * SCREEN_SCALE_LANDSCAPE);
            make.right.equalTo(self.mas_right).offset(-342.f / 2 * SCREEN_SCALE_LANDSCAPE);
            make.width.mas_equalTo(40.f / 2 * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(40.f / 2 * SCREEN_SCALE_LANDSCAPE);
        }];
        imageView;
    });
    self.languageBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *localizedString = QJLocalizedStringFromTable(@"LanguageBtn", @"Localizable");
        [button setImage:[UIImage imageNamed:localizedString] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(languageBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5.f * SCREEN_SCALE_LANDSCAPE);
            make.right.equalTo(self.mas_right).offset(-22.f * SCREEN_SCALE_LANDSCAPE);
            make.width.mas_equalTo(67.f * SCREEN_SCALE_LANDSCAPE);
            make.height.mas_equalTo(34.f * SCREEN_SCALE_LANDSCAPE);
        }];
        button;
    });
}

#pragma mark - Action
- (void)languageBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(connectBluetoothView:languageBtnClicked:)]) {
        [self.delegate connectBluetoothView:self languageBtnClicked:sender];
    }
}

#pragma mark - Public Method
- (void)qj_startFlashSequenceAnimation {
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i <= 18; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"lamp_000%02d", i] ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [images addObject:image];
    }
    self.flashViewImage.animationDuration = kFlashAnimationDuration;
    self.flashViewImage.animationRepeatCount = 0;
    self.flashViewImage.animationImages = images;
    [self.flashViewImage startAnimating];
}

@end
