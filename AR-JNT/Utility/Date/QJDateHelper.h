//
//  QJDateHelper.h
//  AR-JNT
//
//  Created by willwei on 2017/6/20.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJDateHelper : NSObject

+ (QJDateHelper *)helper;

/**
 时间期限是否到期
 
 @return 到期or没到期
 */
- (BOOL)isOverdue;

@end
