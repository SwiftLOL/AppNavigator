//
//  CViewController.m
//  APPNavigator
//
//  Created by wangJiaJia on 16/4/4.
//  Copyright © 2016年 王佳佳. All rights reserved.
//

#import "CViewController.h"
#import "APPNavigator.h"


@implementation CViewController

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
    [[APPNavigator  shareAPPNavigator] popComponentAnimated:YES];
}

@end