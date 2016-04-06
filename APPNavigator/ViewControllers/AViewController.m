//
//  AViewController.m
//  APPNavigator
//
//  Created by wangJiaJia on 16/4/4.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import "AViewController.h"
#import "APPNavigator.h"



@implementation AViewController




+(NSString *)registerComponentName
{
   return @"a";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"a";
    
    self.view.backgroundColor=[UIColor redColor];
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tapGesture];
}


-(void)tapMethod
{
    [[APPNavigator shareAPPNavigator] pushComponentOfUrl:@"/c" otherParams:nil animated:YES];
}
@end


