//
//  QJAppInfoMacro.h
//  QJBaseProject
//
//  Created by willwei on 17/3/27.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#ifndef QJAppInfoMacro_h
#define QJAppInfoMacro_h

// 字体
//#define kNotoSansHansLightFont(fontSize)            [UIFont fontWithName:@"NotoSansHans-Light" size:fontSize]
//#define kNotoSansHansRegularFont(fontSize)          [UIFont fontWithName:@"NotoSansHans-Regular" size:fontSize]
//#define kNotoSansHansBoldFont(fontSize)             [UIFont fontWithName:@"NotoSansHans-Bold" size:fontSize]
#define kNotoSansHansLightFont(fontSize)            [UIFont systemFontOfSize:fontSize]
#define kNotoSansHansRegularFont(fontSize)          [UIFont systemFontOfSize:fontSize]
#define kNotoSansHansBoldFont(fontSize)             [UIFont boldSystemFontOfSize:fontSize]

// app主色调
#define kAppMainBackgroundColor                     [UIColor jk_colorWithHexString:@"#ffffff"]
// app字体主色调
#define kAppMainTextColor                           [UIColor jk_colorWithHexString:@"#ffffff"]

// 导航栏字体颜色
#define kAppNavigationTextColor                     [UIColor jk_colorWithHexString:@"#ffffff"]
// 导航栏颜色
#define kAppNavigationBarColor                      [UIColor jk_colorWithHexString:@"#de2052"]
// 电池栏颜色
#define kAppStatusBarColor                          [UIColor jk_colorWithHexString:@"#8b314a"]

// 标签栏字体颜色
#define kAppTabBarSelectedTextColor                 [UIColor jk_colorWithHexString:@"#de2052"]
#define kAppTabBarNormalTextColor                   [UIColor jk_colorWithHexString:@"#d3bebe"]
// 标签栏颜色
#define kAppTabBarColor                             [UIColor jk_colorWithHexString:@"#ffffff"]

// 视频页字体颜色
#define kVideoTextColor                             [UIColor jk_colorWithHexString:@"#fefefe"]
// 播放器字体主色调
#define kPlayerMainTextColor                        [UIColor jk_colorWithHexString:@"#ffffff"]

// 分享字体颜色
#define  ShareMainTextColor                        [UIColor jk_colorWithHexString:@"#2c2c2c"]


#endif /* QJAppInfoMacro_h */
