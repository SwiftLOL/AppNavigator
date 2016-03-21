//
//  BViewController.m
//  chineseBoy0822
//
//  Created by 王佳佳 on 16/3/2.
//  Copyright © 2016年 chineseBoy. All rights reserved.
//

#import "BViewController.h"
#import "APPNavigator.h"

@interface BViewController ()

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"B";
    self.view.backgroundColor=[UIColor blueColor];
    
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}




-(void)tapMethod
{
    [[APPNavigator shareAPPNavigator] presentComponentOfUrl:@"/DComponent" otherParams:nil animated:YES completion:NULL];

}


@end
