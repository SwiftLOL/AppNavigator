//
//  CViewController.m
//  chineseBoy0822
//
//  Created by 王佳佳 on 16/3/2.
//  Copyright © 2016年 chineseBoy. All rights reserved.
//

#import "CViewController.h"
#import "APPNavigator.h"
@interface CViewController ()

@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"C";
    self.view.backgroundColor=[UIColor yellowColor];
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    NSLog(@"**********************************");
    NSLog(@"%@",self.navigationController);
    NSLog(@"%@",self.tabBarController);
    NSLog(@"%@",self.parentViewController);
    NSLog(@"%@",self.childViewControllers);
    NSLog(@"%@",self.navigationController.parentViewController);
    
    NSLog(@"%@",self.presentingViewController);
    
}


-(void)tapMethod
{
    //打开地图 app
    [[APPNavigator shareAPPNavigator] openUrl:@"maps://"];
}

@end
