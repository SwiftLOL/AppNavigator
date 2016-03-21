//
//  DViewController.m
//  chineseBoy0822
//
//  Created by 王佳佳 on 16/3/4.
//  Copyright © 2016年 chineseBoy. All rights reserved.
//

#import "DViewController.h"
#import "APPNavigator.h"
@interface DViewController ()
@property(nonatomic,strong,nullable) NSString *from;

@end

@implementation DViewController

-(instancetype)initWithParams:(NSDictionary *)params
{
    self=[super initWithParams:params];
    if(self)
    {
        self.from=[params objectForKey:@"from"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"D";
    self.view.backgroundColor=[UIColor greenColor];
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
        [[APPNavigator shareAPPNavigator] popComponentAnimated:YES];

}

@end
