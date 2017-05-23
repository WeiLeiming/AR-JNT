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
    #define kMainServerUrl                   @"http://120.24.69.30:8080"
#else
    #define kMainServerUrl                   @"http://"
#endif

//网络请求超时时间
#define kNetworkTimeoutInterval              10

#endif /* QJNetWorkingMacro_h */
