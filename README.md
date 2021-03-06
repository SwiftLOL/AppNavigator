# AppNavigator


## Overview

**APPNavigator**用于对UIViewController间解耦，通过url实现UIViewController间跳转的中间件。

* **AppNavigator**中不耦合任何的容器控制器，不持有整个控制器层次结构,所以不需要担心控制器的内存管理。通过注册进来的window在控制器层次中进行push\pop\present。

* 适用于window.rootViewController为任何类型的容器控制器(UITabBarController\UINavigationController etc)。

* 设计的过程中，假设了任何presentedViewController都在UINavigationcontroller中，以便在presentedViewController上可以进行push操作。




## 使用说明
* 1.注册scheme，及UIWindow.
 
 
```
[[APPNavigator shareInstance] registerAPPScheme:@"SwiftLOL" window:self.window];
 
```
      
* 2.通过类名，动态加载UIViewController子类的类对象。

```
[[APPNavigator shareInstance] createViewControllerByClassNames:@[@"AViewController",@"BViewController",@"CViewController"]];

```

* 3.每个自定义UIViewController子类需要遵循下面的协议，用于自定义组件名、初始化、参数、主键等信息

```         
      @protocol APPNavigatorProtocol<NSObject>
      
      +(nonnull NSString *)registerComponentName;
      
      +(nullable NSString *)authenticationFilterUrl;

      +(nullable id)viewControllerWithParams:(nullable NSDictionary *)params;

      +(nullable NSDictionary *)componentParams;

      -(nullable SEL)selectorForGetTopViewController;

      -(nonnull NSString *)presentationType;

      -(nullable APPNavigatorPresentationCompletion)presentationCompletion;

      @end
```
   
* 4.通过url加载组件

```
 UIViewController *bCtr=[[APPNavigator shareInstance] componentOfUrl:@"SwiftLOL://b?id=1"];


```
* 5.通过openUrl:(nonnull NSString *) url animated:(BOOL)animated方法展示组件
       
```    
   [[APPNavigator shareInstance] openUrl:@"SwiftLOL://c?id=1&title=swiftLOL" animated:YES];

```

* 6.通过pop移除当前组件

```           
[[APPNavigator  shareInstance] popComponentAnimated:YES];

```
* 7 移除当前整个presenting链

```
[[APPNavigator shareInstance] popToPresentingComponentAnimated:YES completion:NULL];

```

##更新日志       
1.4 version
    
    增加跳转前认证功能。app中，未登陆前，点击一些button的时候，需要跳转到登陆页，为了省去这些重复性创建登陆页跳转到登陆页面的代码，所有添加认证功能。

    +(nullable NSString *)authenticationFilterUrl;

