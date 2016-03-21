//
//  AViewController.m
//  chineseBoy0822
//
//  Created by 王佳佳 on 16/3/2.
//  Copyright © 2016年 chineseBoy. All rights reserved.
//

#import "AViewController.h"
#import "APPNavigator.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"A";
   self.view.backgroundColor=[UIColor redColor];
    
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%@",self.navigationController);
    NSLog(@"%@",self.tabBarController);
    NSLog(@"%@",self.parentViewController);
    NSLog(@"%@",self.childViewControllers);
    NSLog(@"%@",self.navigationController.parentViewController);
    NSLog(@"%@",self.presentingViewController);
}


-(void)tapMethod
{
    [[APPNavigator shareAPPNavigator] pushComponentOfUrl:@"/DComponent/" otherParams:nil animated:YES];
}


@end
