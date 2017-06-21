//
//  QJDateHelper.m
//  AR-JNT
//
//  Created by willwei on 2017/6/20.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJDateHelper.h"

#define DATE_SET @"date_set"

@interface QJDateHelper ()

@end

@implementation QJDateHelper

#pragma mark - Getter

/**
 获取当前时间
 */
- (NSDate *)currentDate {
    if (!_currentDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        _currentDate = [NSDate date];
        NSLog(@"currentDate = %@", _currentDate);
    }
    return _currentDate;
}

/**
 时间期限是否到期
 */
- (BOOL)isOverdue {
    NSTimeInterval overdueInterval = kExpirationTime * 24 * 60 * 60;
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_SET];
    NSLog(@"saveDate = %@", date);
    if (!date) {
        return YES;
    }
    
    NSTimeInterval interval = [self calculateTimeIntervalSinceDate:date];
    
    return interval > overdueInterval ? YES : NO;
}

#pragma mark - Public Method

/**
 存储当前时间
 */
- (void)qj_saveCurrentDate {
    [[NSUserDefaults standardUserDefaults] setObject:self.currentDate forKey:DATE_SET];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Private Method

/**
 计算当前时间与给定时间的时间间隔

 @param date 给定时间
 @return 时间间隔
 */
- (NSTimeInterval)calculateTimeIntervalSinceDate:(NSDate *)date {
    NSTimeInterval interval = [self.currentDate timeIntervalSinceDate:date];
    
    return interval;
}

@end
