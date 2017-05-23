//
//  QJBaseViewController.m
//  QJBaseProject
//
//  Created by willwei on 17/3/24.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJBaseViewController.h"

@interface QJBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation QJBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self baseConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - base config
- (void)baseConfig {
    [self setBaseCommonNavigation];
    if ([self.navigationController.jk_rootViewController isKindOfClass:[self class]]) {
        [self addBaseGestureRecognizer];
    } else {
        [self setBaseLeftNavigation];
    }
}

#pragma mark - navigation
- (void)setBaseCommonNavigation {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kAppNavigationBarColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: kAppNavigationTextColor, NSFontAttributeName: kNotoSansHansBoldFont(16.f)};
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    // 创建一个假status bar
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    statusBarView.backgroundColor = kAppStatusBarColor;
    [self.navigationController.navigationBar addSubview:statusBarView];
}

- (void)setBaseLeftNavigation {
    // 间隔
    UIBarButtonItem *seperator01 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:@selector(backBarButtonItemClicked:)];
    seperator01.width = -5.f;
    // 返回
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemClicked:)];
    self.navigationItem.leftBarButtonItems = @[seperator01, backButton];
}

#pragma mark - click back button
- (void)backBarButtonItemClicked:(UIBarButtonItem *)barButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - GestureRecognizer
/**
 用于支持viewController左右滑动切换tabBarController
 */
- (void)addBaseGestureRecognizer {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(baseGestureRightButton:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(baseGestureLeftButton:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}

- (void)baseGestureRightButton:(id)sender {
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    NSArray *viewControllerArray = self.tabBarController.viewControllers;
    /*
    if (selectedIndex < viewControllerArray.count - 1) {
        [self.tabBarController setSelectedIndex:selectedIndex + 1];
        //To animate use this code
        CATransition *anim= [CATransition animation];
        [anim setType:kCATransitionPush];
        [anim setSubtype:kCATransitionFromRight];
        [anim setDuration:0.4f];
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:
                                 kCAMediaTimingFunctionEaseIn]];
        [self.tabBarController.view.layer addAnimation:anim forKey:@"fadeTransition"];
    }
    */
    /*
    if (selectedIndex < viewControllerArray.count - 1) {
        UIView *fromView = [self.tabBarController.selectedViewController view];
        UIView *toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex + 1] view];
        [UIView transitionFromView:fromView toView:toView duration:0.5f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            if (finished) {
                [self.tabBarController setSelectedIndex:selectedIndex + 1];
            }
        }];
    }
    */
    if (selectedIndex < viewControllerArray.count - 1) {
        NSUInteger controllerIndex = selectedIndex + 1;
        // Get the views.
        UIView *fromView = self.tabBarController.selectedViewController.view;
        UIView *toView = [[viewControllerArray objectAtIndex:controllerIndex] view];
        
        // Get the size of the view area.
        CGRect viewSize = fromView.frame;
        BOOL scrollRight = controllerIndex > self.tabBarController.selectedIndex;
        
        // Add the to view to the tab bar view.
        [fromView.superview addSubview:toView];
        
        // Position it off screen.
        toView.frame = CGRectMake((scrollRight ? viewSize.size.width : -viewSize.size.width), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
        
        [UIView animateWithDuration:0.3f
                         animations: ^{
                             // Animate the views on and off the screen. This will appear to slide.
                             fromView.frame = CGRectMake((scrollRight ? -viewSize.size.width : viewSize.size.width), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                             toView.frame = CGRectMake(0, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 // Remove the old view from the tabbar view.
                                 [fromView removeFromSuperview];
                                 self.tabBarController.selectedIndex = controllerIndex;
                             }
                         }];
    }
}

- (void)baseGestureLeftButton:(id)sender {
    NSUInteger selectedIndex = [self.tabBarController selectedIndex];
    NSArray *viewControllerArray = self.tabBarController.viewControllers;
    /*
    if (selectedIndex > 0) {
        [self.tabBarController setSelectedIndex:selectedIndex - 1];
        CATransition *anim= [CATransition animation];
        [anim setType:kCATransitionPush];
        [anim setSubtype:kCATransitionFromLeft];
        [anim setDuration:0.4f];
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:
                                 kCAMediaTimingFunctionEaseIn]];
        [self.tabBarController.view.layer addAnimation:anim forKey:@"fadeTransition"];
    }
    */
    /*
    if (selectedIndex > 0) {
        UIView *fromView = [self.tabBarController.selectedViewController view];
        UIView *toView = [[self.tabBarController.viewControllers objectAtIndex:selectedIndex - 1] view];
        [UIView transitionFromView:fromView toView:toView duration:0.5f options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
            if (finished) {
                [self.tabBarController setSelectedIndex:selectedIndex - 1];
            }
        }];
    }
    */
    if (selectedIndex > 0) {
        NSUInteger controllerIndex = selectedIndex - 1;
        // Get the views.
        UIView *fromView = self.tabBarController.selectedViewController.view;
        UIView *toView = [[viewControllerArray objectAtIndex:controllerIndex] view];
        
        // Get the size of the view area.
        CGRect viewSize = fromView.frame;
        BOOL scrollRight = controllerIndex > self.tabBarController.selectedIndex;
        
        // Add the to view to the tab bar view.
        [fromView.superview addSubview:toView];
        
        // Position it off screen.
        toView.frame = CGRectMake((scrollRight ? viewSize.size.width : -viewSize.size.width), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
        
        [UIView animateWithDuration:0.3f
                         animations: ^{
                             // Animate the views on and off the screen. This will appear to slide.
                             fromView.frame = CGRectMake((scrollRight ? -viewSize.size.width : viewSize.size.width), viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                             toView.frame = CGRectMake(0, viewSize.origin.y, viewSize.size.width, viewSize.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 // Remove the old view from the tabbar view.
                                 [fromView removeFromSuperview];
                                 self.tabBarController.selectedIndex = controllerIndex;
                             }
                         }];
    }
}

#pragma mark - status bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - interface orientation
// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return NO;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
