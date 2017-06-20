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

@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation QJDateHelper

+ (QJDateHelper *)helper {
    return [[QJDateHelper alloc] init];
}

- (NSDate *)currentDate {
    if (!_currentDate) {
        _currentDate = [self getCurrentDate];
    }
    return _currentDate;
}

/**
 获取当前时间

 @return 当前时间
 */
- (NSDate *)getCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    return [NSDate date];
}

/**
 存储当前时间
 */
- (void)saveCurrentDate {
    [[NSUserDefaults standardUserDefaults] setObject:self.currentDate forKey:DATE_SET];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 计算当前时间与给定时间的时间间隔

 @param date 给定时间
 @return 时间间隔
 */
- (NSTimeInterval)calculateTimeIntervalSinceDate:(NSDate *)date {
    NSTimeInterval interval = [self.currentDate timeIntervalSinceDate:date];
    
    return interval;
}

/**
 时间期限是否到期

 @return 到期or没到期
 */
- (BOOL)isOverdue {
    NSTimeInterval expirationTime = kExpirationTime * 24 * 60 * 60;
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:DATE_SET];
    if (!date) {
        [self saveCurrentDate];
        return YES;
    }
    
    NSTimeInterval interval = [self calculateTimeIntervalSinceDate:date];
    
    if (interval > expirationTime) {
        [self saveCurrentDate];
        return YES;
    } else {
        return NO;
    }
}

@end
