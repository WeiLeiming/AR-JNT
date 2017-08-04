//
//  QJNetWorkingMacro.h
//  QJBaseProject
//
//  Created by willwei on 17/3/24.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#ifndef QJNetWorkingMacro_h
#define QJNetWorkingMacro_h

#ifdef kTestServerOpen
    #define kMainServerUrl                   @"http://192.168.1.99:80"
#else
    #define kMainServerUrl                   @"http://macup.591vr.com"     // http://120.24.69.30:7000
#endif

//网络请求超时时间
#define kNetworkTimeoutInterval              5

#endif /* QJNetWorkingMacro_h */
