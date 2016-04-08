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


-(id)initWithParams:(NSDictionary *)params
{
    self=[self init];
    if(self)
    {
        self.viewControllers=[params objectForKey:@"viewControllers"];
    }
    return self;
}


+(NSString *)registerComponentName
{
    return @"tabBar";
}

@end
