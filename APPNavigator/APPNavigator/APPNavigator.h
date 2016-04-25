//
//  APPNavigator.h
//  SwiftLOL
//
//  Created by 王佳佳 on 16/3/2.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (url)

+(nonnull NSString *)urlWithComponentName:(nonnull NSString *)componentName KeysAndParams:(nullable id)firstObject,...;

@end



@protocol APPNavigatorProtocol <NSObject>

@required
+(nonnull NSString *)registerComponentName;
+(nullable id)viewControllerWithParams:(nullable NSDictionary *)params;
@optional
-(BOOL)shouldNavigatedToWindow;
+(nullable SEL)registerSelectorForGetTopViewController;
@end


@interface UIViewController (APPNavigator)<APPNavigatorProtocol>


@end


#define APPNavigatorAssert(condition,description)  NSCAssert((condition), @"%@: %@", description,@#condition)

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


@interface APPNavigator : NSObject


//当前app内部 scheme,用于区分访问http、调起第三方app的scheme
@property(nonatomic,strong,nullable) NSString  *scheme;


//application路由器单例
+(nonnull instancetype) shareInstance;





-(void)createViewControllerByClassNames:(nullable NSArray *)classNames;





//注册当前app scheme  依赖注入appDelegate,以便操控整个app视图层次结构
-(void) registerAPPScheme:(nonnull NSString *) scheme  window:(nonnull UIWindow *) window;




/*
   注册一个新的组件及其映射组件类名
   注册组件格式:componentName
*/
-(void)registerComponentWithComponentName:(nonnull NSString *)componentName withClassName:(nonnull NSString *)className;





//register selector for component which used for get the most top child view controller
-(void)registerMethodForGetWhichChildInWindow:(nullable SEL) selector componentOfClassName:(nullable NSString *)className;




/*
  生成指定url的View controller  
  url格式: scheme://componentName?param1=value1&params2=value2
*/
-(nonnull UIViewController *)componentOfUrl:(nonnull NSString *)url;




-(void)pushComponentOfUrl:(nonnull NSString *)url
                             animated:(BOOL)animated;




-(void)presentComponentOfUrl:(nonnull NSString *)url
                             animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;




-(void)pushComponentOfViewController:(nonnull UIViewController *)controller
                 animated:(BOOL)animated;




-(void)presentComponentOfViewController:(nonnull UIViewController *)controller
                    animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;



//返回到前一个画面
-(void) popComponentAnimated:(BOOL) animated;

//返回到当前所在容器控制器的根部 一般用于导航控制器
-(void) popToRootComponentAnimated:(BOOL) animated;

//返回到当前view controller的presenting view controller
-(void) popToPresentingComponentAnimated:(BOOL) animated completion:(void (^ __nullable)(void))completion;

//打开第三方app
-(void) openUrl:(nonnull NSString *) url;


@end
