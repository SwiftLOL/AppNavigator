# AppNavigator


## Overview

**APPNavigator**是用于UIViewController间解耦，通过url实现UIViewController间跳转的中间件。


## 使用说明
* 1.注册scheme，及UIWindow.
 
         [[APPNavigator shareAPPNavigator] registerAPPScheme:@"SwiftLOL" window:self.window];
       
* 2.通过类名，动态加载UIViewController子类的类对象。
          
          [[APPNavigator shareAPPNavigator] loadViewControllerByClassNames:@[@"AViewController",@"BViewController",@"CViewController"]];

* 3.每个子类需要遵循下面的协议，用于自定义组件名、参数、主键等信息

```         
      @protocol APPNavigatorProtocol<NSObject>
      @required
      +(nonnull NSString *)registerComponentName;
      @optional
      +(nullable NSDictionary *)registerParams;
      +(nullable NSString *)registerPrimaryKey;
     @end
```
* 4.通过url加载组件

           UIViewController *aCtr=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/a?userName=swiftlol&userId=1" otherParams:nil];

* 5.通过push/present方法展示组件
           
            [[APPNavigator shareAPPNavigator] pushComponentOfUrl:@"/c" otherParams:nil animated:YES];
           
            [[APPNavigator shareAPPNavigator] presentComponentOfUrl:@"/c" otherParams:nil animated:YES completion:NULL];


* 6.通过pop移除当前组件
           
            [[APPNavigator  shareAPPNavigator] popComponentAnimated:YES];
* 7 移除当前整个presenting链

               [[APPNavigator shareAPPNavigator] popToPresentingComponentAnimated:YES completion:NULL];

* 8 使用openUrl打开其他app

       [[APPNavigator shareAPPNavigator] openUrl:@"maps://"];

### 其他功能详看源代码，更多功能待开发中。。。。        
