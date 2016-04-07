# AppNavigator


## Overview

**APPNavigator**用于对UIViewController间解耦，通过url实现UIViewController间跳转的中间件。

* **AppNavigator**中不耦合任何的容器控制器，不持有整个控制器层次结构,所以不需要担心控制器的内存管理。通过注册进来的window在控制器层次中进行push\pop\present。

* 适用于window.rootViewController为任何类型的容器控制器(UITabBarController\UINavigationController etc)。

* 设计的过程中，假设了任何presentedViewController都在UINavigationcontroller中，以便在presentedViewController上可以进行push操作。



##note
   目前没用上scheme,因为可能会影响到后续的功能开发。目前使用不完全url格式:
   
       /componentName?arg1=value1&arg2=value2



## 使用说明
* 1.注册scheme，及UIWindow.
 
         [[APPNavigator shareAPPNavigator] registerAPPScheme:@"SwiftLOL" window:self.window];
       
* 2.通过类名，动态加载UIViewController子类的类对象。
          
          [[APPNavigator shareAPPNavigator] loadViewControllerByClassNames:@[@"AViewController",@"BViewController",@"CViewController"]];

* 3.每个自定义UIViewController子类需要遵循下面的协议，用于自定义组件名、参数、主键等信息

```         
      @protocol APPNavigatorProtocol<NSObject>
      @required
      +(nonnull NSString *)registerComponentName;
      @optional
      +(nullable NSDictionary *)registerParams;
      +(nullable NSString *)registerPrimaryKey;
     @end
```

* 4  注册容器控制器的方法－－－用于获取当前展示的是哪个子控制器
 
```  
[[APPNavigator shareAPPNavigator] registerMethodForGetWhichChildInWindow:@selector(topViewController) ComponentOfClassName:NSStringFromClass([UINavigationController class])];

[[APPNavigator shareAPPNavigator] registerMethodForGetWhichChildInWindow:@selector(selectedViewController) ComponentOfClassName:NSStringFromClass([UITabBarController class])];
 ```
   
* 5.通过url加载组件

           UIViewController *aCtr=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/a?userName=swiftlol&userId=1" otherParams:nil];

* 6.通过push/present方法展示组件
           
            [[APPNavigator shareAPPNavigator] pushComponentOfUrl:@"/c" otherParams:nil animated:YES];
           
            [[APPNavigator shareAPPNavigator] presentComponentOfUrl:@"/c" otherParams:nil animated:YES completion:NULL];


* 7.通过pop移除当前组件
           
            [[APPNavigator  shareAPPNavigator] popComponentAnimated:YES];
* 8 移除当前整个presenting链

               [[APPNavigator shareAPPNavigator] popToPresentingComponentAnimated:YES completion:NULL];

* 9 使用openUrl打开其他app

```
     [[APPNavigator shareAPPNavigator] openUrl:@"maps://"];
```

### 更多功能开发中。。。。        
