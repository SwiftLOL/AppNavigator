//
//  APPNavigator.h
//  chineseBoy0822
//
//  Created by 王佳佳 on 16/3/2.
//  Copyright © 2016年 chineseBoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"





@protocol APPNavigatorProtocol <NSObject>

@required
+(nonnull NSString *)registerComponentName;
@optional
+(nullable NSDictionary *)registerParams;
+(nullable NSString *)registerPrimaryKey;

@end


@interface UIViewController (APPNavigator)<APPNavigatorProtocol>

-(nonnull instancetype ) initWithParams:(nullable NSDictionary *)params;

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

//application路由器单例
+(nonnull instancetype) shareAPPNavigator;

-(void)loadViewControllerByClassNames:(nullable NSArray *)classNames;

//注册当前app scheme  依赖注入appDelegate,以便操控整个app视图层次结构
-(void) registerAPPScheme:(nonnull NSString *) scheme  window:(nonnull UIWindow *) window;
/*
   注册一个新的组件及其映射组件类名
   注册组件格式: /componentName/:requiredParamsList(:requiredParam1(PK):requiredParam2)
   PK 表示该组件的主键属性
*/
-(void)registerComponentWithComponentName:(nonnull NSString *)componentName withClassName:(nonnull NSString *)ClassName;

//register selector for component which used for get the most top child view controller
-(void)registerMethodForGetWhichChildInWindow:(nullable SEL) selector ComponentOfClassName:(nullable NSString *)className;
/*
  生成指定url的View controller
*/
-(nonnull UIViewController *)componentOfUrl:(nonnull NSString *)url  otherParams:(nullable NSDictionary *)otherParams;


//push 一个view controller
-(void)pushComponentOfUrl:(nonnull NSString *)url
                             otherParams:(nullable NSDictionary *)otherParams
                             animated:(BOOL)animated;

//present一个view controller
-(void)presentComponentOfUrl:(nonnull NSString *)url
                             otherParams:(nullable NSDictionary *)otherParams
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
