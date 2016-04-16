//
//  BViewController.m
//  APPNavigator
//
//  Created by wangJiaJia on 16/4/4.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import "BViewController.h"
#import "APPNavigator.h"

@implementation BViewController

+(NSString *)registerComponentName
{
    return @"b";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"b";
    
    self.view.backgroundColor=[UIColor yellowColor];
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tapGesture];
}


-(void)tapMethod
{
    [[APPNavigator shareInstance] presentComponentOfUrl:@"/c" otherParams:nil animated:YES completion:NULL];
}

@end
