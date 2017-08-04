//
//  QJUUIDUtil.m
//  AR-JNT
//
//  Created by willwei on 2017/8/2.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJUUIDUtil.h"
#import <UICKeyChainStore.h>

@implementation QJUUIDUtil

+ (NSString *)getDeviceUUIDString {
    // 实际为IDFV
    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return deviceUUID;
}

+ (NSString *)readUUIDFromKeyChain {
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.qj-vr.AR-JNT"];
    
    NSError *error;
    NSString *uuidString = [keychain stringForKey:@"deviceUUID" error:&error];
    if (error) {
        NSLog(@"KeyChainError: %@", error.localizedDescription);
    }
    
    return uuidString;
}

+ (void)saveUUIDToKeyChain {
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.qj-vr.AR-JNT"];
    
    NSError *error;
    NSString *uuidString = [keychain stringForKey:@"deviceUUID" error:&error];
    if (error) {
        NSLog(@"KeyChainError: %@", error.localizedDescription);
    }
    
    NSLog(@"saveUUIDToKeyChain, UUID = %@", uuidString);  // AC05B25F-E570-4249-86F4-6E261864AD87
    
    if (!uuidString || [uuidString isEqualToString:@""]) {
        [keychain setString:[self getDeviceUUIDString] forKey:@"deviceUUID"];
    }
}


@end
