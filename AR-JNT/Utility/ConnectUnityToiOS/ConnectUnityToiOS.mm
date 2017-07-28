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

- (void)checkCameraAuthorizationStatus {
    // 读取设备授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [self openApplicationSettings];
    }
}

- (void)openApplicationSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end

#ifdef __cplusplus
extern "C" {
#endif
    
    void checkCameraAuthorizationStatus() {
        [[ConnectUnityToiOS sharedInstance] checkCameraAuthorizationStatus];
    }
    
#ifdef __cplusplus
}  // extern "C"
#endif
