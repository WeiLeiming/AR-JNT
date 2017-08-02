//
//  QJUUIDUtil.h
//  AR-JNT
//
//  Created by willwei on 2017/8/2.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QJUUIDUtil : NSObject

+ (NSString *)readUUIDFromKeyChain;
+ (void)saveUUIDToKeyChain;

@end
