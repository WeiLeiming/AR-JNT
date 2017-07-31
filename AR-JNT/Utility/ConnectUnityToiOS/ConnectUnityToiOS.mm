//
//  ConnectUnityToiOS.m
//  AR-JNT
//
//  Created by willwei on 2017/7/28.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "ConnectUnityToiOS.h"

@implementation ConnectUnityToiOS

+ (ConnectUnityToiOS *)sharedInstance {
    static ConnectUnityToiOS *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

- (NSInteger)checkCameraAuthorizationStatus {
    // 读取设备授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            return 0;   // 未授权
        case AVAuthorizationStatusRestricted:
            return 1;
        case AVAuthorizationStatusDenied:
            return 1;   // 拒绝授权
        case AVAuthorizationStatusAuthorized:
            return 2;   // 已授权
        default:
            break;
    }
}

- (void)requestCameraAccessPermissionHandler:(void (^)(BOOL granted))handler {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        handler(granted);
    }];
}

- (void)openApplicationSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (NSInteger)getSystemCurrentLanguage {
    NSString *tmp = [QJLanguageManage getSystemCurrentLanguage];
    if ([tmp isEqualToString:@"zh-Hans"]) {
        return 0;   // 中文
    } else {
        return 1;   // 英文
    }
}

@end

#ifdef __cplusplus
extern "C" {
#endif
    
    int checkCameraAuthorizationStatus() {
        NSInteger status = [[ConnectUnityToiOS sharedInstance] checkCameraAuthorizationStatus];
        return int(status);
    }
    
    void requestCameraAccessPermission() {
        [[ConnectUnityToiOS sharedInstance] requestCameraAccessPermissionHandler:nil];
    }
    
    int getSystemCurrentLanguage() {
        NSInteger language = [[ConnectUnityToiOS sharedInstance] getSystemCurrentLanguage];
        return int(language);
    }
    
#ifdef __cplusplus
}  // extern "C"
#endif
