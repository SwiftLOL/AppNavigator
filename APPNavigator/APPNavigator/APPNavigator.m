//
//  APPNavigator.m
//  chineseBoy0822
//
//  Created by 王佳佳 on 16/3/2.
//  Copyright © 2016年 chineseBoy. All rights reserved.
//

#import "APPNavigator.h"
#import <objc/runtime.h>

@implementation UIViewController (APPNavigator)

+(void)initialize
{
    NSString *className=NSStringFromClass([self class]);
    APPNavigator *appNavigator=[APPNavigator shareAPPNavigator];
    [appNavigator registerComponentWithComponentName:[self registerComponentName] withClassName:className];
}



+(NSString *)registerComponentName
{
    return [NSStringFromClass([self class]) lowercaseString];
}



-(nonnull instancetype) initWithParams:(nullable NSDictionary *)params
{
    self =[self init];
  
    return self;
}

@end






@interface APPNavigator ()

//当前app内部 scheme,用于区分访问http、调起第三方app的scheme
@property(nonatomic,strong,nullable) NSString  *scheme;
//component 集合
@property(nonatomic,strong,nonnull) NSMutableArray       *componentArray;
//component 到 UIViewController的映射集合
@property(nonatomic,strong,nonnull) NSMutableDictionary  *componentToViewControllerMaps;

//用于获取某个容器控制器当前展示的是哪个子控制器
@property(nonatomic,strong,nonnull) NSMutableDictionary  *whichChildComponentInWindowSelectorNameMaps;
//当前appDelegate 的 window
@property(strong,nonatomic,nullable) UIWindow            *window;



@end

@implementation APPNavigator

#pragma mark -- 单例

//获取单例
+(nonnull instancetype) shareAPPNavigator
{
    static APPNavigator *appNavigator = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        appNavigator=[[APPNavigator alloc] init];
    });
    
    return appNavigator;
}


-(void)loadViewControllerByClassNames:(NSArray *)classNames
{
    for (NSString *className in classNames) {
        Class c=NSClassFromString(className);
        [c class];
    }
}


-(instancetype)init
{
    self=[super init];
    if(self)
    {
        self.scheme=nil;
        self.componentArray=[NSMutableArray arrayWithArray:@[]];
        self.componentToViewControllerMaps=[NSMutableDictionary dictionaryWithDictionary:@{}];
        self.whichChildComponentInWindowSelectorNameMaps=[NSMutableDictionary dictionaryWithDictionary:@{}];
        self.window=nil;
    }
    return self;
}




#pragma mark -- regisetr

-(void) registerAPPScheme:(nonnull NSString *) scheme  window:(nonnull UIWindow *) window
{
    APPNavigatorAssert(!self.scheme, @"scheme已经注册过了");
    APPNavigatorAssert(!self.window, @"window已经设置过了");
    APPNavigatorAssert(scheme, @"scheme不能为空");
    APPNavigatorAssert(window, @"awindow不能为空");
    self.scheme=scheme;
    self.window=window;
}





-(void)registerComponentWithComponentName:(nonnull NSString *)componentName withClassName:(nonnull NSString *)className
{
    APPNavigatorAssert(componentName, @"组件格式不能为空");
    APPNavigatorAssert(className, @"组件对应ViewController类名不能为空");
    
    if([[APPNavigator shareAPPNavigator].componentToViewControllerMaps objectForKey:componentName])
    {
        NSString *warning=[NSString stringWithFormat:@"该组件%@已经注册过了",className];
        APPNavigatorAssert(className, warning);;
    }else{
        [self.componentArray addObject:componentName];
        [self.componentToViewControllerMaps setObject:className forKey:componentName];
    }
}



-(void)registerMethodForGetWhichChildInWindow:(nullable SEL) selector ComponentOfClassName:(nullable NSString *)className
{
    APPNavigatorAssert(className, @"class name 不能为空");
    APPNavigatorAssert(selector, @"selector 不能为空");
    
    NSString *selectorName=[self.whichChildComponentInWindowSelectorNameMaps objectForKey:className];
    if(selectorName)
    {
        NSString *warning=[NSString stringWithFormat:@"%@的%@已经注册过了",className,NSStringFromSelector(selector)];
        APPNavigatorAssert(className, warning);
    }

    [self.whichChildComponentInWindowSelectorNameMaps setValue:NSStringFromSelector(selector) forKey:className];
}


#pragma mark -- 生成一个指定url的view controller
// scheme://host/path?param1=value1&param2=value2
//目前不使用scheme://host/
//目前格式 /componentName?param1=value1&param2=value2
-(nonnull UIViewController *)componentOfUrl:(nonnull NSString *)url  otherParams:(nullable NSDictionary *)otherParams
{
    APPNavigatorAssert(url, @"url不能为空");
    
    UIViewController *viewController=nil;
    
    NSMutableDictionary *mutabledic=[[NSMutableDictionary alloc] init];
    
    for (NSString *key in otherParams) {
        [mutabledic setObject:[otherParams objectForKey:key] forKey:key];
    }

    NSString *path=nil;
    NSString *paramsString=nil;
    NSString *componentName=nil;
    NSString *componentClassName=nil;
    
    NSArray *array=[url componentsSeparatedByString:@"?"];
    
    path=array[0];
    
   componentName=[path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    componentClassName=[self.componentToViewControllerMaps objectForKey:componentName];
    
    if(array.count==2)
    {
        paramsString=array[1];
        NSArray *paramsArray=[paramsString componentsSeparatedByString:@"&"];
        for (NSString *tempString in paramsArray) {
            NSArray *valueAndKeyArray=[tempString componentsSeparatedByString:@"="];
            
            [mutabledic setObject:valueAndKeyArray[1] forKey:valueAndKeyArray[0]];
        }
    }
    
    viewController=[[NSClassFromString(componentClassName) alloc] initWithParams:mutabledic];
    
    return viewController;
}


#pragma mark -- open 、push 、present

//打开第三方app
-(void) openUrl:(nonnull NSString *) url
{
    APPNavigatorAssert(url, @"url不可为空");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

//push 一个view controller
//  /createOrder?categoryid=1&
-(void)pushComponentOfUrl:(nonnull NSString *)url
                                    otherParams:(nullable NSDictionary *)otherParams
                                       animated:(BOOL)animated
{
    UIViewController *topViewController=[self topViewController];
    
    UIViewController *viewController=[self componentOfUrl:url otherParams:otherParams];
    
    [topViewController.navigationController pushViewController:viewController animated:animated];
    
}





-(void)presentComponentOfUrl:(nonnull NSString *)url
                                       otherParams:(nullable NSDictionary *)otherParams
                                          animated:(BOOL)animated  completion:(void (^ __nullable)(void))completion
{
    UIViewController *topViewController=[self topViewController];
    
    UIViewController *viewController=[self componentOfUrl:url otherParams:otherParams];
    
    UINavigationController *navigationCtr=[[UINavigationController alloc] initWithRootViewController:viewController];
    
    [topViewController presentViewController:navigationCtr animated:animated completion:completion];
}


#pragma mark --  pop

-(void) popComponentAnimated:(BOOL) animated
{
    UIViewController *topViewController=[self topViewController];
    
    UINavigationController *navigationCtr=topViewController.navigationController;
    
       if(navigationCtr&&topViewController!=navigationCtr.viewControllers[0])
       {
           [topViewController.navigationController popViewControllerAnimated:animated];
       }else
       {
           [topViewController.presentingViewController dismissViewControllerAnimated:animated completion:NULL];
       }
}



-(void) popToRootComponentAnimated:(BOOL) animated
{
    UIViewController *topViewController=[self topViewController];
    
    UINavigationController *navigationCtr=topViewController.navigationController;
    
    if(navigationCtr)
        [topViewController.navigationController popToRootViewControllerAnimated:animated];
}



-(void) popToPresentingComponentAnimated:(BOOL) animated completion:(void (^ __nullable)(void))completion
{
    UIViewController *topViewController=[self topViewController];
    
    if(topViewController.presentingViewController)
        [topViewController.presentingViewController dismissViewControllerAnimated:animated completion:completion];
}




#pragma mark --- top View controller

-(UIViewController *)topViewController
{
    UIViewController *topViewCtr=self.window.rootViewController;
    
    while (topViewCtr.presentedViewController||topViewCtr.childViewControllers.count>0) {
        
        if(topViewCtr.presentedViewController)
        {
            topViewCtr=topViewCtr.presentedViewController;
            continue;
        }else if(topViewCtr.childViewControllers)
        {
            NSString *seletor=nil;
            for (NSString *key in self.whichChildComponentInWindowSelectorNameMaps) {
                if([key isEqualToString:NSStringFromClass([topViewCtr class])])
                {
                    seletor=[self.whichChildComponentInWindowSelectorNameMaps objectForKey:key];
                    if([topViewCtr respondsToSelector:NSSelectorFromString(seletor)])
                        SuppressPerformSelectorLeakWarning(
                        topViewCtr=[topViewCtr performSelector:NSSelectorFromString(seletor) withObject:nil];
                                                           );
                    break;
                }
            }
        }
    }
    
    return topViewCtr;
}



@end
