//
//  APPNavigator.m
//  SwiftLOL
//
//  Created by 王佳佳 on 16/3/2.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import "APPNavigator.h"
#import <objc/runtime.h>


@implementation NSString (url)

+(nonnull NSString *)urlWithComponentName:(nonnull NSString *)componentName KeysAndParams:(nullable id)firstObject,...
{
   
   NSString *url=[NSString stringWithFormat:@"%@://%@",[APPNavigator shareInstance].scheme,componentName];
    va_list varList;
    id param=firstObject;
    if(param)
    {
        url=[url stringByAppendingString:[NSString stringWithFormat:@"?%@",param]];
        va_start(varList, firstObject);
        int i=1;
        while ((param = va_arg(varList, id))) {
            if(i%2==0)
            {
                    url=[url stringByAppendingString:[NSString stringWithFormat:@"&%@",param]];
            }else
            {
                NSString *value=[[NSString stringWithFormat:@"%@",param] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                url=[url stringByAppendingString:[NSString stringWithFormat:@"=%@",value]];
            }
            i++;
            
        }
        
        va_end(varList);
        
      
    }
    
    
    return url;
}

@end




@implementation UIViewController (APPNavigator)

+(void)initialize
{
    NSString *className=NSStringFromClass([self class]);
    APPNavigator *appNavigator=[APPNavigator shareInstance];
    [appNavigator registerComponentWithComponentName:[self registerComponentName] withClassName:className];
    [appNavigator registerMethodForGetWhichChildInWindow:[self registerSelectorForGetTopViewController] componentOfClassName:className];
}



+(nullable id)viewControllerWithParams:(nullable NSDictionary *)params
{
    return [[[self class] alloc] init];
}



+(NSString *)registerComponentName
{
    NSString *name=[NSStringFromClass([self class]) lowercaseString];
    
    if([name hasPrefix:@"ui"])
    {
        name=[name substringFromIndex:2];
    }
    
    if([name hasSuffix:@"controller"])
    {
        name=[name substringToIndex:name.length-10];
    }
    
    if([name hasSuffix:@"view"])
    {
        name=[name substringToIndex:name.length-4];
    }
    
    if([name isEqualToString:@""])
    {
       name=@"vc";
    }
    
    return name;
}




+(SEL)registerSelectorForGetTopViewController
{
    return nil;
}



-(BOOL)shouldNavigatedToWindow
{
    return YES;
}


@end



@implementation UINavigationController (APPNavigator)

+(SEL)registerSelectorForGetTopViewController
{
    return  @selector(topViewController);
}

@end



@implementation UITabBarController (APPNavigator)

+(SEL)registerSelectorForGetTopViewController
{
    return  @selector(selectedViewController);
}

@end




@interface APPNavigator ()

//component 集合
@property(nonatomic,strong,nonnull) NSMutableArray       *componentArray;
//component 到 UIViewController的映射集合
@property(nonatomic,strong,nonnull) NSMutableDictionary  *componentToViewControllerMaps;

//用于获取某个容器控制器当前展示的是哪个子控制器
@property(nonatomic,strong,nonnull) NSMutableDictionary  *whichChildComponentInWindowSelectorNameMaps;

@property(nonatomic,strong,nonnull) NSMutableDictionary *componentParamsMaps;
//当前appDelegate 的 window
@property(strong,nonatomic,nullable) UIWindow            *window;



@end

@implementation APPNavigator

#pragma mark -- 单例

//获取单例
+(nonnull instancetype) shareInstance
{
    static APPNavigator *appNavigator = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        appNavigator=[[APPNavigator alloc] init];
    });
    
    return appNavigator;
}


-(void)createViewControllerByClassNames:(NSArray *)classNames
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
    
    if([[APPNavigator shareInstance].componentToViewControllerMaps objectForKey:componentName])
    {
        NSString *warning=[NSString stringWithFormat:@"该组件%@已经注册过了",className];
        APPNavigatorAssert(className, warning);;
    }else{
        [self.componentArray addObject:componentName];
        [self.componentToViewControllerMaps setObject:className forKey:componentName];
    }
}




-(void)registerMethodForGetWhichChildInWindow:(nullable SEL) selector componentOfClassName:(nullable NSString *)className
{
    if (!selector) {
        return;
    }
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
-(nonnull UIViewController *)componentOfUrl:(nonnull NSString *)url
{
    APPNavigatorAssert(url, @"url不能为空");
    
    UIViewController *viewController=nil;
    
    NSMutableDictionary *mutabledic=[[NSMutableDictionary alloc] init];
    
    NSString *paramsString=nil;
    NSString *componentName=nil;
    NSString *componentClassName=nil;
    
    
    if([url hasPrefix:[NSString stringWithFormat:@"%@://",self.scheme]])
    {
        
        url=[url substringFromIndex:self.scheme.length+3];
        
        
        NSArray *array=[url componentsSeparatedByString:@"?"];
        
        componentName=array[0];
        componentClassName=[self.componentToViewControllerMaps objectForKey:componentName];
        
        if(array.count==2)
        {
            paramsString=array[1];
            NSArray *paramsArray=[paramsString componentsSeparatedByString:@"&"];
            for (NSString *tempString in paramsArray)
            {
                NSArray *valueAndKeyArray=[tempString componentsSeparatedByString:@"="];
                
                if(valueAndKeyArray.count==1)
                {
                    [mutabledic setObject:@"" forKey:valueAndKeyArray[0]];
                }else
                {
                    if(![valueAndKeyArray[1] isEqualToString:@"(null)"]&&![valueAndKeyArray[1] isEqualToString:@"<null>"])
                       [mutabledic setObject:[valueAndKeyArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:valueAndKeyArray[0]];
                }
            }
        }
        
       viewController=[NSClassFromString(componentClassName) viewControllerWithParams:mutabledic];
        
        return viewController;
      
    }
    
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
                                       animated:(BOOL)animated
{
    UIViewController *topViewController=[self topViewController];
    
    UIViewController *viewController=[self componentOfUrl:url];
    
    [topViewController.navigationController pushViewController:viewController animated:animated];
    
}





-(void)presentComponentOfUrl:(nonnull NSString *)url
                                          animated:(BOOL)animated  completion:(void (^ __nullable)(void))completion
{
    UIViewController *topViewController=[self topViewController];
    
    UIViewController *viewController=[self componentOfUrl:url];
    
    UINavigationController *navigationCtr=[[UINavigationController alloc] initWithRootViewController:viewController];
    
    [topViewController presentViewController:navigationCtr animated:animated completion:completion];
}





-(void)pushComponentOfViewController:(nonnull UIViewController *)controller
                            animated:(BOOL)animated
{
    UIViewController *topViewController=[self topViewController];
    
    [topViewController.navigationController pushViewController:controller animated:animated];
}




-(void)presentComponentOfViewController:(nonnull UIViewController *)controller
                               animated:(BOOL)animated completion:(void (^ __nullable)(void))completion
{

    UIViewController *topViewController=[self topViewController];
    
    UINavigationController *navigationCtr=[[UINavigationController alloc] initWithRootViewController:controller];
    
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
                if([topViewCtr isKindOfClass:NSClassFromString(key)])
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
