//
//  QJLanguageManage.h
//  AR-JNT
//
//  Created by willwei on 2017/6/12.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QJLanguageManagerShare                      [QJLanguageManage sharedManager]
#define QJLocalizedStringFromTable(key, tbl)        [QJLanguageManagerShare getStringForKey:key withTable:tbl]

@interface QJLanguageManage : NSObject

+ (instancetype)sharedManager;

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

- (void)changeNowLanguage;

- (void)setNewLanguage:(NSString*)language;

@end
