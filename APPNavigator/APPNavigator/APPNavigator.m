//
//  APPNavigator.m
//  SwiftLOL
//
//  Created by 王佳佳 on 16/3/2.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import "APPNavigator.h"
#import <objc/runtime.h>


@implementation NSString (APPNavigatorURL)

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


+(nullable NSDictionary *)componentParams
{
    return nil;
}



-(SEL)selectorForGetTopViewController
{
    return nil;
}


-(NSString *)presentationType
{
    return APPNavigatorPresentationTypePush;
}


-(APPNavigatorPresentationCompletion)presentationCompletion
{
    return nil;
}


@end



@implementation UINavigationController (APPNavigator)

-(SEL)selectorForGetTopViewController
{
    return  @selector(topViewController);
}

@end



@implementation UITabBarController (APPNavigator)

-(SEL)selectorForGetTopViewController
{
    return  @selector(selectedViewController);
}

@end




@interface APPNavigator ()

@property(nonatomic,strong,nonnull) NSMutableDictionary  *componentToViewControllerMaps;
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
        self.componentToViewControllerMaps=[NSMutableDictionary dictionaryWithDictionary:@{}];
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
        [self.componentToViewControllerMaps setObject:className forKey:componentName];
    }
}





#pragma mark -- 生成一个指定url的view controller
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
        
        Class<APPNavigatorProtocol> componentClass = NSClassFromString(componentClassName);
        
        if(array.count==2)
        {
            paramsString=array[1];
            NSArray *paramsArray=[paramsString componentsSeparatedByString:@"&"];
            for (NSString *tempString in paramsArray)
            {
                NSArray *valueAndKeyArray=[tempString componentsSeparatedByString:@"="];
                
                if(valueAndKeyArray.count==1)
                {
                   [self handleParams:@"" key:valueAndKeyArray[0] dictionary:mutabledic class:componentClass];
                }else
                {
                    
                    [self handleParams:valueAndKeyArray[1] key:valueAndKeyArray[0] dictionary:mutabledic class:componentClass];
                    
                }
            }
        }
        
       viewController=[componentClass viewControllerWithParams:mutabledic];
        
        return viewController;
      
    }
    
    return viewController;

}


-(void)handleParams:(id )param key:(id )key  dictionary:(NSMutableDictionary *)mutableDic class:(Class<APPNavigatorProtocol>)class
{
    NSDictionary *paramsMaps=[class componentParams];
    NSString *paramType=[paramsMaps objectForKey:key];
    if(![param isEqualToString:@"(null)"]&&![param isEqualToString:@"<null>"])
    {
      if(!paramType)
      {
          [mutableDic setObject:param forKey:key];
          return;
      }
      if([paramType isEqualToString:APPNavigatorParamTypeString])
      {
          [mutableDic setObject:param forKey:key];
      }else if([paramType isEqualToString:APPNavigatorParamTypeChar]&&[NSNumber numberWithChar:[param charValue]])
      {
          [mutableDic setObject:[NSNumber numberWithChar:[param charValue]] forKey:key];
      }else
      {
            if(![param isEqualToString:@""])
            {
               if([paramType isEqualToString:APPNavigatorParamTypeInteger]&&[NSNumber numberWithInteger:[param integerValue]])
                   [mutableDic setObject:[NSNumber numberWithInteger:[param integerValue]] forKey:key];
                if([paramType isEqualToString:APPNavigatorParamTypeDouble]&&[NSNumber numberWithDouble:[param doubleValue]])
                   [mutableDic setObject:[NSNumber numberWithDouble:[param doubleValue]] forKey:key];
                 if([paramType isEqualToString:APPNavigatorParamTypeBool]&&[NSNumber numberWithBool:[param boolValue]])
                     [mutableDic setObject:[NSNumber numberWithBool:[param boolValue]] forKey:key];
                if([paramType isEqualToString:APPNavigatorParamTypeFloat]&&[NSNumber numberWithFloat:[param floatValue]])
                    [mutableDic setObject:[NSNumber numberWithFloat:[param floatValue]] forKey:key];
                if([paramType isEqualToString:APPNavigatorParamTypeDate])
                {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date = [dateFormatter dateFromString:param];
                    if(date)
                    {
                        [mutableDic setObject:date forKey:key];
                    }
                }
                
            }
      }
    }

}


#pragma mark -- open 、push 、present

//打开第三方app
-(void) openUrl:(nonnull NSString *) url animated:(BOOL)animated
{
    if([url hasPrefix:[NSString stringWithFormat:@"%@://",self.scheme]])
    {
        UIViewController *viewController=[self componentOfUrl:url];
        if([[viewController presentationType] isEqualToString:APPNavigatorPresentationTypePresent])
        {
            UINavigationController *navigationCtr=[[UINavigationController alloc] initWithRootViewController:viewController];
            [[self topViewController] presentViewController:navigationCtr animated:animated completion:[viewController presentationCompletion]];
        }else
        {
            [[self topViewController].navigationController pushViewController:viewController animated:animated];
        }
        
    }else
    {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
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
            
            if([topViewCtr respondsToSelector:@selector(selectorForGetTopViewController)])
            {
                SEL seletor=[topViewCtr selectorForGetTopViewController];
                SuppressPerformSelectorLeakWarning(
                                                   topViewCtr=[topViewCtr performSelector:seletor withObject:nil];
                                                   );
            }
        }
    }
    return topViewCtr;
}



@end
