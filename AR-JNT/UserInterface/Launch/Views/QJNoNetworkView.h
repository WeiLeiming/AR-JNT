//
//  QJNoNetworkView.h
//  AR-JNT
//
//  Created by willwei on 2017/5/26.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJBaseView.h"

@class QJNoNetworkView;

@protocol QJNoNetworkViewDelegate <NSObject>

- (void)noNetworkView:(QJNoNetworkView *)view retryButtonClicked:(UIButton *)sender;

@end

@interface QJNoNetworkView : QJBaseView

@property(nonatomic, weak) id<QJNoNetworkViewDelegate> delegate;

@end
