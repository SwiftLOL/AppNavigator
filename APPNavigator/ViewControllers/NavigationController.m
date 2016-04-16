//
//  NavigationController.m
//  APPNavigator
//
//  Created by wangJiaJia on 16/4/8.
//  Copyright © 2016年 王佳佳. All rights reserved.
//

#import "NavigationController.h"
#import "APPNavigator.h"
@interface NavigationController ()

@end

@implementation NavigationController


+(nullable id)viewControllerWithParams:(nullable NSDictionary *)params
{
    UIViewController *vCtr=[[self alloc] initWithRootViewController:[params objectForKey:@"root"]];
    return vCtr;
}


+(NSString *)registerComponentName
{
    return @"navi";
}

@end
