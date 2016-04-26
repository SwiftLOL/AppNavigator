//
//  APPNavigator.h
//  SwiftLOL
//
//  Created by 王佳佳 on 16/3/2.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



static  NSString  * _Nonnull  const APPNavigatorParamTypeChar     =  @"char";
static  NSString  * _Nonnull  const APPNavigatorParamTypeBool     =  @"Bool";
static  NSString  * _Nonnull  const APPNavigatorParamTypeInteger  =  @"NSInterger";
static  NSString  * _Nonnull  const APPNavigatorParamTypeFloat    =  @"float";
static  NSString  * _Nonnull  const APPNavigatorParamTypeDouble   =  @"double";
static  NSString  * _Nonnull  const APPNavigatorParamTypeString   =  @"NSString";
static  NSString  * _Nonnull  const APPNavigatorParamTypeDate     =  @"NSDate";


static  NSString  * _Nonnull  const APPNavigatorPresentationTypePush   =  @"push";
static  NSString  * _Nonnull  const APPNavigatorPresentationTypePresent     =  @"present";




#define APPNavigatorAssert(condition,description)  \
       NSCAssert((condition), @"%@: %@", description,@#condition)



#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


typedef  void (^APPNavigatorPresentationCompletion)(void);


@interface NSString (APPNavigatorURL)

//参数个数可变  结尾加nil
+(nonnull NSString *)urlWithComponentName:(nonnull NSString *)componentName KeysAndParams:(nullable id)firstObject,...;

@end


@protocol APPNavigatorProtocol <NSObject>

+(nonnull NSString *)registerComponentName;

+(nullable id)viewControllerWithParams:(nullable NSDictionary *)params;

+(nullable NSDictionary *)componentParams;

-(nullable SEL)selectorForGetTopViewController;

-(nonnull NSString *)presentationType;

-(nullable APPNavigatorPresentationCompletion)presentationCompletion;

@end




@interface UIViewController (APPNavigator)<APPNavigatorProtocol>



@end



@interface APPNavigator : NSObject


@property(nonatomic,strong,nullable) NSString  *scheme;


+(nonnull instancetype) shareInstance;

-(void)createViewControllerByClassNames:(nullable NSArray *)classNames;

-(void) registerAPPScheme:(nonnull NSString *) scheme  window:(nonnull UIWindow *) window;

-(void)registerComponentWithComponentName:(nonnull NSString *)componentName withClassName:(nonnull NSString *)className;

-(nonnull UIViewController *)componentOfUrl:(nonnull NSString *)url;

-(void) openUrl:(nonnull NSString *) url animated:(BOOL)animated;

-(void) popComponentAnimated:(BOOL) animated;

-(void) popToRootComponentAnimated:(BOOL) animated;

-(void) popToPresentingComponentAnimated:(BOOL) animated completion:(void (^ __nullable)(void))completion;

@end
