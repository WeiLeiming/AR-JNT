//
//  QJLanguageManage.m
//  AR-JNT
//
//  Created by willwei on 2017/6/12.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJLanguageManage.h"
#import "QJConnectBluetoothViewController.h"

#define CNS @"zh-Hans"
#define EN @"en"
#define LANGUAGE_SET @"langeuageset"

@interface QJLanguageManage ()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, copy) NSString *language;

@end

@implementation QJLanguageManage

+ (instancetype)sharedManager {
    static QJLanguageManage *_manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manage = [[super allocWithZone:NULL] init];
    });
    return _manage;
}

+ (void)initialize {
    if (self == [QJLanguageManage class]) {
        [self initLanguageFromSystem];
    }
}

+ (void)initLanguageFromApplication {
    NSString *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_SET];
    
    // 默认是中文
    if (!tmp) {
        NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
        NSString *currentLanguage = languages.firstObject;
        if ([currentLanguage hasPrefix:@"zh-Hans"]) {
            tmp = CNS;
        } else {
            tmp = EN;
        }
        [[NSUserDefaults standardUserDefaults] setObject:tmp forKey:LANGUAGE_SET];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:tmp ofType:@"lproj"];
    QJLanguageManagerShare.language = tmp;
    QJLanguageManagerShare.bundle = [NSBundle bundleWithPath:path];
}

+ (void)initLanguageFromSystem {
    NSString *tmp;
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *currentLanguage = languages.firstObject;
    if ([currentLanguage hasPrefix:@"zh-Hans"]) {
        tmp = CNS;
    } else {
        tmp = EN;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:tmp ofType:@"lproj"];
    QJLanguageManagerShare.language = tmp;
    QJLanguageManagerShare.bundle = [NSBundle bundleWithPath:path];
}

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table {
    if (self.bundle) {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }
    return NSLocalizedStringFromTable(key, table, @"");
}

- (void)changeNowLanguage {
    if ([self.language isEqualToString:EN]) {
        [self setNewLanguage:CNS];
    } else {
        [self setNewLanguage:EN];
    }
}

- (void)setNewLanguage:(NSString *)language {
    if ([language isEqualToString:self.language]) {
        return;
    }
    
    if ([language isEqualToString:EN] || [language isEqualToString:CNS]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
    }
    
    self.language = language;
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"language = %@, bundle = %@", language, self.bundle);
//    [self resetRootViewController];
}

- (void)resetRootViewController {
    NSLog(@"resetRootViewController");
    QJConnectBluetoothViewController *bluetoothVC = [[QJConnectBluetoothViewController alloc] init];
    kAppDelegate.window.rootViewController = bluetoothVC;
}

@end
