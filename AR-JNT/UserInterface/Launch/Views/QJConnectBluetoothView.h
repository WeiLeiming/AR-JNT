//
//  QJConnectBluetoothView.h
//  AR-JNT
//
//  Created by willwei on 2017/5/26.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJBaseView.h"

@class QJConnectBluetoothView;

@protocol QJConnectBluetoothViewDelegate <NSObject>

- (void)connectBluetoothView:(QJConnectBluetoothView *)view languageBtnClicked:(UIButton *)sender;

@end

@interface QJConnectBluetoothView : QJBaseView

@property(nonatomic, weak) id<QJConnectBluetoothViewDelegate> delegate;

- (void)qj_startFlashSequenceAnimation;

- (void)qj_stopFlashSequenceAnimation;

@end
