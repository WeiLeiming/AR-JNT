//
//  QJDateHelper.h
//  AR-JNT
//
//  Created by willwei on 2017/6/20.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJDateHelper : NSObject

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign, readonly, getter=isOverdue) BOOL overdue;

/**
 存储当前时间
 */
- (void)qj_saveCurrentDate;

@end
