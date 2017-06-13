//
//  AppDelegate.h
//  AR-JNT
//
//  Created by willwei on 17/5/23.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnityAppController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) AFNetworkReachabilityStatus   networkStatus;

@property (strong, nonatomic) UIWindow *unityWindow;
@property (strong, nonatomic) UnityAppController *unityController;
- (void)showUnityWindow;
- (void)hideUnityWindow;

@end

