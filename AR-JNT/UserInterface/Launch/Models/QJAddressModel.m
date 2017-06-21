//
//  QJAddressModel.m
//  AR-JNT
//
//  Created by willwei on 2017/6/21.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJAddressModel.h"

@implementation QJAddressModel

//如果需要指定“唯一约束”字段,就实现该函数.
+(NSString *)bg_uniqueKey{
    return @"address";
}

@end
