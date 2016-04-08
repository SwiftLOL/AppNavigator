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


-(instancetype)initWithParams:(NSDictionary *)params
{
    self=[self initWithRootViewController:[params objectForKey:@"root"]];
    return self;
}


+(NSString *)registerComponentName
{
    return @"navi";
}

@end
