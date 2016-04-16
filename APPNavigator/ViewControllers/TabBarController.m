//
//  TabBarController.m
//  APPNavigator
//
//  Created by wangJiaJia on 16/4/8.
//  Copyright © 2016年 王佳佳. All rights reserved.
//

#import "TabBarController.h"
#import "APPNavigator.h"
@interface TabBarController ()

@end

@implementation TabBarController


+(nullable id)viewControllerWithParams:(nullable NSDictionary *)params
{
    TabBarController *tabBarCtr=[[self alloc] init];
    tabBarCtr.viewControllers=[params objectForKey:@"viewControllers"];
    return tabBarCtr;
}


+(NSString *)registerComponentName
{
    return @"tabBarVC";
}

@end
