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


+(id)viewControllerWithParams:(NSDictionary *)params
{
    AViewController *aCtr=[super viewControllerWithParams:params];
    
    aCtr.name=[params objectForKey:@"name"];
    
    return aCtr;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=self.name;
    
    self.view.backgroundColor=[UIColor redColor];
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tapGesture];
}


-(void)tapMethod
{
    [[APPNavigator shareInstance] pushComponentOfUrl:[NSString urlWithComponentName:@"c" KeysAndParams:nil] animated:YES];
}
@end


