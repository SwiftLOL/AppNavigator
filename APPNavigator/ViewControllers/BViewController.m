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


+(id)viewControllerWithParams:(NSDictionary *)params
{
    BViewController *bCtr=[super viewControllerWithParams:params];
    bCtr.tempId=[[params objectForKey:@"id"] integerValue];
    return bCtr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"b";
    
    
    if(self.tempId%2==0)
      self.view.backgroundColor=[UIColor yellowColor];
    else
        self.view.backgroundColor=[UIColor grayColor];

    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod)];
    [self.view addGestureRecognizer:tapGesture];
}


-(void)tapMethod
{
    
    NSString *title=@"test";
    NSNumber *number=[NSNumber numberWithInteger:10];
    [[APPNavigator shareInstance] openUrl:[NSString urlWithComponentName:@"c" KeysAndParams:@"title",title,@"id",number,nil] animated:YES];
    
    

}

@end
