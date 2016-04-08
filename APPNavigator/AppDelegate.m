//
//  AppDelegate.m
//  APPNavigator
//
//  Created by SwiftLOLon 16/3/21.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import "AppDelegate.h"
#import "APPNavigator.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor blackColor];
    
    //注册app内跳转scheme及主window
    [[APPNavigator shareAPPNavigator] registerAPPScheme:@"SwiftLOL" window:self.window];
    //通过类名注册所有类
    [[APPNavigator shareAPPNavigator] loadViewControllerByClassNames:@[@"TabBarController",@"NavigationController",@"AViewController",@"BViewController",@"CViewController"]];
    //注册容器控制器 获取当前显示的子控制器的方法
    [[APPNavigator shareAPPNavigator] registerMethodForGetWhichChildInWindow:@selector(topViewController) ComponentOfClassName:NSStringFromClass([UINavigationController class])];
    [[APPNavigator shareAPPNavigator] registerMethodForGetWhichChildInWindow:@selector(selectedViewController) ComponentOfClassName:NSStringFromClass([UITabBarController class])];
    
    //通过url生成相应组件
    UIViewController *aCtr=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/a" otherParams:nil];
    UIViewController *aContainer=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/navi" otherParams:@{@"root":aCtr}];
    
    UIViewController *bCtr=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/b" otherParams:nil];
    UIViewController *bContainer=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/navi" otherParams:@{@"root":bCtr}];
    
    UIViewController *rootCtr=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/tabBar"  otherParams:@{@"viewControllers":@[aContainer,bContainer]}];
    
    self.window.rootViewController=rootCtr;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
