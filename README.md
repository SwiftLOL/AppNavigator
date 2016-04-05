# AppNavigator


APPNavigator是用于UIViewController间解耦，通过url实现UIViewController间跳转的中间件。


使用说明:
        1.注册scheme，及UIWindow
          [[APPNavigator shareAPPNavigator] registerAPPScheme:@"edaixi" window:self.window];
       
        2.通过类名，动态加载UIViewController子类的类对象。
          [[APPNavigator shareAPPNavigator] createViewControllerByClassNames:@[@"AViewController",@"BViewController",@"CViewController"]];

        3.每个子类需要遵循下面的协议，用于自定义组件名、参数、主键等信息
                    @protocol APPNavigatorProtocol <NSObject>

                    @required
                      +(nonnull NSString *)registerComponentName;
                    @optional
                      +(nullable NSDictionary *)registerParams;
                      +(nullable NSString *)registerPrimaryKey;

                    @end


        4.通过url加载组件
           UIViewController *aCtr=[[APPNavigator shareAPPNavigator] componentOfUrl:@"/a?userName=wangjiajia&userId=1" otherParams:nil];


        5.通过push/present方法展示组件
            [[APPNavigator shareAPPNavigator] pushComponentOfUrl:@"/c" otherParams:nil animated:YES];


        6.通过pop移除组件
            [[APPNavigator  shareAPPNavigator] popComponentAnimated:YES];



        详看demo


        