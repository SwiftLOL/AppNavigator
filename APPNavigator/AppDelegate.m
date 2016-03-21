//
//  AppDelegate.m
//  APPNavigator
//
//  Created by 王佳佳 on 16/3/21.
//  Copyright © 2016年 王佳佳. All rights reserved.
//

#import "AppDelegate.h"
#import "APPNavigator.h"
#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"
#import "DViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor blackColor];
    
    
    
    [[APPNavigator shareAPPNavigator] registerAPPScheme:@"edaixi" window:self.window];
    [[APPNavigator shareAPPNavigator] registerComponentWithComponentFormat:@"/tabBarComponent/" withComponentName:NSStringFromClass([UITabBarController class])];
    [[APPNavigator shareAPPNavigator] registerComponentWithComponentFormat:@"/navigtionComponment/" withComponentName:NSStringFromClass([UINavigationController class])];
    [[APPNavigator shareAPPNavigator] registerComponentWithComponentFormat:@"/AComponent/" withComponentName:NSStringFromClass([AViewController class])];
    [[APPNavigator shareAPPNavigator] registerComponentWithComponentFormat:@"/BComponent/" withComponentName:NSStringFromClass([BViewController class])];
    [[APPNavigator shareAPPNavigator] registerComponentWithComponentFormat:@"/CComponent/" withComponentName:NSStringFromClass([CViewController class])];
    [[APPNavigator shareAPPNavigator] registerComponentWithComponentFormat:@"/DComponent/" withComponentName:NSStringFromClass([DViewController class])];
    
    [[APPNavigator shareAPPNavigator] registerMethodForGetWhichChildInWindow:@selector(topViewController) ComponentOfClassName:NSStringFromClass([UINavigationController class])];
    
    [[APPNavigator shareAPPNavigator] registerMethodForGetWhichChildInWindow:@selector(selectedViewController) ComponentOfClassName:NSStringFromClass([UITabBarController class])];
    
    UITabBarController  *tabBarCtr=(UITabBarController *)[[APPNavigator shareAPPNavigator] componentOfUrl:@"/tabBarComponent/" otherParams:nil];
    UINavigationController  *aNavCtr=(UINavigationController *)[[APPNavigator shareAPPNavigator] componentOfUrl:@"/navigtionComponment/" otherParams:nil];
    UIViewController *aCtr=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/AComponent/" otherParams:nil];
    [aNavCtr setViewControllers:@[aCtr]];
    
    UINavigationController  *bNavCtr=(UINavigationController *)[[APPNavigator shareAPPNavigator] componentOfUrl:@"/navigtionComponment/" otherParams:nil];
    UIViewController *bCtr=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/BComponent/" otherParams:nil];
    [bNavCtr setViewControllers:@[bCtr]];
    
    
    UINavigationController  *cNavCtr=(UINavigationController *)[[APPNavigator shareAPPNavigator] componentOfUrl:@"/navigtionComponment/" otherParams:nil];
    UIViewController *cCtr=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/CComponent/" otherParams:nil];
    [cNavCtr setViewControllers:@[cCtr]];
    
    
    [tabBarCtr setViewControllers:@[aNavCtr,bNavCtr,cNavCtr]];
    
    
    self.window.rootViewController=tabBarCtr;
    
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
