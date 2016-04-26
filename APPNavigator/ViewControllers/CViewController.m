//
//  CViewController.m
//  APPNavigator
//
//  Created by SwiftLOLon 16/4/4.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import "CViewController.h"
#import "APPNavigator.h"


@implementation CViewController


+(id)viewControllerWithParams:(NSDictionary *)params
{
    CViewController *cCtr=[super viewControllerWithParams:params];
    
    return cCtr;
}



+(NSDictionary *)componentParams
{
    return @{@"title":APPNavigatorParamTypeString,
             @"id":APPNavigatorParamTypeInteger
             };
}



+(NSString *)registerComponentName
{
    return @"c";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"c";
    
    self.view.backgroundColor=[UIColor blueColor];
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tapGesture];
}


-(void)tapMethod
{
    [[APPNavigator  shareInstance] popComponentAnimated:YES];
}

@end
