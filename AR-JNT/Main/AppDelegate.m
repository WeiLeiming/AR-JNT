//
//  AppDelegate.m
//  AR-JNT
//
//  Created by willwei on 17/5/23.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "AppDelegate.h"
#import "QJCheckUpdateViewController.h"
#import "QJUUIDUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (UIWindow *)unityWindow {
    return UnityGetMainWindow();
}

- (void)showUnityWindow {
    [self.unityWindow makeKeyAndVisible];
    UnityPause(false);
}

- (void)hideUnityWindow {
    UnityPause(true);
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 保存UUID到钥匙串
    [QJUUIDUtil saveUUIDToKeyChain];
    
    _unityController = [[UnityAppController alloc] init];
    [_unityController application:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    QJCheckUpdateViewController *vc = [[QJCheckUpdateViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    [self checkNetworkStatus];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [_unityController applicationWillResignActive:application];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [_unityController applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [_unityController applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [_unityController applicationDidBecomeActive:application];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [_unityController applicationWillTerminate:application];
}

#pragma mark - Custom Function
// 检测网络状态
- (void)checkNetworkStatus {
    self.networkStatus = AFNetworkReachabilityStatusUnknown;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.networkStatus = status;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkStatus" object:nil];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"网络不可用");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"移动网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
