//
//  QJMacro.h
//  QJBaseProject
//
//  Created by willwei on 17/3/24.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#ifndef QJMacro_h
#define QJMacro_h

//#define AppDebugMode

#ifdef AppDebugMode
    #define kTestServerOpen      //负责调整Debug模式下的服务器地址
#endif

#import "QJCommonMacro.h"
#import "QJAppInfoMacro.h"
#import "QJNetWorkingMacro.h"
#import "QJAppCustomMacro.h"

// 开发的时候打印，但是发布的时候不打印的NSLog
#ifdef DEBUG
    #define NSLog(...)          NSLog(@"%s [Line %d]\n%@", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
//    #define DLog(fmt, ...)      NSLog((@"%s [Line %d]\n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
    #define NSLog(...)
//    #define DLog(...)
#endif

// 判断是真机还是模拟器
#if TARGET_OS_IPHONE
// 真机
#endif
#if TARGET_IPHONE_SIMULATOR
// 模拟器
#endif

#endif /* QJMacro_h */
