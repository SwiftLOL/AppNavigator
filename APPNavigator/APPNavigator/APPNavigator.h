//
//  APPNavigator.h
//  SwiftLOL
//
//  Created by 王佳佳 on 16/3/2.
//  Copyright © 2016年 SwiftLOL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark -- param type
static  NSString  * _Nonnull  const APPNavigatorParamTypeChar     =  @"char";
static  NSString  * _Nonnull  const APPNavigatorParamTypeBool     =  @"Bool";
static  NSString  * _Nonnull  const APPNavigatorParamTypeInteger  =  @"NSInterger";
static  NSString  * _Nonnull  const APPNavigatorParamTypeFloat    =  @"float";
static  NSString  * _Nonnull  const APPNavigatorParamTypeDouble   =  @"double";
static  NSString  * _Nonnull  const APPNavigatorParamTypeString   =  @"NSString";
static  NSString  * _Nonnull  const APPNavigatorParamTypeDate     =  @"NSDate";


#pragma mark -- presentation type
static  NSString  * _Nonnull  const APPNavigatorPresentationTypePush   =  @"push";
static  NSString  * _Nonnull  const APPNavigatorPresentationTypePresent     =  @"present";


#pragma mark -- APPNavigatorPresentationTypePresent completion block
typedef  void (^APPNavigatorPresentationCompletion)(void);

#pragma mark --  customing behavior  for controllers
@protocol APPNavigatorProtocol <NSObject>

//compnent name used  for loading the corresponding view controller class
+(nonnull NSString *)registerComponentName;
//whether require Authentication or not
+(nullable NSString *)authenticationFilterUrl;
//default initial method
+(nullable id)viewControllerWithParams:(nullable NSDictionary *)params;
//used for pointint out the required params with corresponding data type
+(nullable NSDictionary *)componentParams;
//used fo getting the top view controller in the container view controller
-(nullable SEL)selectorForGetTopViewController;
//presentation type when the view controller presented in the window
-(nonnull NSString *)presentationType;
//completion block when the view controller presnted in the window with the type of present
-(nullable APPNavigatorPresentationCompletion)presentationCompletion;

@end



#pragma mark -- APPNavigator definition
@interface APPNavigator : NSObject

//the scheme of current application
@property(nonatomic,strong,nullable) NSString  *scheme;
//singleton method
+(nonnull instancetype) shareInstance;
//used for load all view controller information by runtime
-(void)createViewControllerByClassNames:(nullable NSArray *)classNames;
//register scheme and window for the natigator
-(void) registerAPPScheme:(nonnull NSString *) scheme  window:(nonnull UIWindow *) window;
//register the component name and the corresponding class name
-(void)registerComponentWithComponentName:(nonnull NSString *)componentName withClassName:(nonnull NSString *)className;
//return  the view controller used the component and params provided by url
-(nonnull UIViewController *)componentOfUrl:(nonnull NSString *)url;
//show the view controller corresponding to the url  in window
-(void) openUrl:(nonnull NSString *) url animated:(BOOL)animated;
//pop the top view controller
-(void) popComponentAnimated:(BOOL) animated;
//pop to root
-(void) popToRootComponentAnimated:(BOOL) animated;
//pop to presenting view controller
-(void) popToPresentingComponentAnimated:(BOOL) animated completion:(void (^ __nullable)(void))completion;

@end


#define APPNavigatorAssert(condition,description)  \
NSCAssert((condition), @"%@: %@", description,@#condition)


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)



#pragma mark --NSString category  used for creating url prefixed application scheme
@interface NSString (APPNavigatorURL)

+(nonnull NSString *)urlWithComponentName:(nonnull NSString *)componentName KeysAndParams:(nullable id)firstObject,...;

@end

#pragma mark -- UIView controller category used for conform the protocol of APPNavigatorProtocol
@interface UIViewController (APPNavigator)<APPNavigatorProtocol>
@end

