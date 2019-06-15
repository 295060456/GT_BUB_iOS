//
//  AppDelegate.m
//  gtp
//
//  Created by Aalto on 2018/12/15.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "AppDelegate.h"
#import "YBRootTabBarViewController.h"
#import "LoginVM.h"
#import "LoginModel.h"

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "VicJPushManager.h"

#import <RongIMKit/RongIMKit.h>
#import "RongCloudManager.h"
//#import <IQKeyboardManager/IQKeyboardManager.h>

@interface AppDelegate ()<JPUSHRegisterDelegate,RCIMConnectionStatusDelegate,RCIMUserInfoDataSource>
@property (nonatomic, strong) LoginVM* vm;
@end

@implementation AppDelegate

- (void)initRootUI {
    [self setNetWorkErrInfo];
    _window.rootViewController = [YBRootTabBarViewController new];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [self initRootUI];
    [self setKeyBoard];
    
//    [self setJPushWithOptions:launchOptions];
    
    [self setRCIM];
    
    return YES;
}

- (void)setJPushWithOptions:(NSDictionary *)launchOptions{
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound | JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity
                                             delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    BOOL isProduction = YES;
#ifdef DEBUG
    isProduction = NO;
#endif
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPush_Key
                          channel:JPush_Channel
                 apsForProduction:isProduction
            advertisingIdentifier:@""];
}

- (void)setRCIM{
    
    [[RCIM sharedRCIM] initWithAppKey:RongCloud_Key];
    
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    BOOL isLogin = GetUserDefaultBoolWithKey(kIsLogin);
    
    LoginModel *userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    
    if (isLogin) {
//        [self getAsset];
        
        [self.vm network_rongCloudTokenWithRequestParams:userInfoModel.userinfo.userid
                                                 success:^(id data) {
            LoginModel *model = data;
                                                     
            [RongCloudManager loginWith:model.rongyunToken
                                success:^(NSString *userId) {
                                    
//                [UserManager defaultCenter].userInfo.rongyunToken = response.rongyunToken;
            } error:^(RCConnectErrorCode status) {
                
            } tokenIncorrect:^{
                
            }];
        } failed:^(id data) {
            
        } error:^(id data) {
            
        }];
    }
}

#pragma mark- RCIMDelegate
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    NSLog(@"-------%zd",status);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support //1.程序在运行时收到通知，点击通知栏进入app
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [VicJPushManager handleJump:userInfo];
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

// iOS 10 Support //2.程序在后台时收到通知，点击通知栏进入app
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response
          withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    [VicJPushManager handleJump:userInfo];
    
    completionHandler();  // 系统要求执行这个方法
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    
    [VicJPushManager handleJump:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)setKeyBoard{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = YES; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}

#pragma mark - RC实现代理方法，以个人信息为例：
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    if ([userId isEqualToString:userInfoModel.userinfo.userid]){
        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:userInfoModel.userinfo.nickname portrait:@""];
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
        completion(user);
    }
    else{
        NSArray *usersArr = @[userId];
        NSDictionary *param = @{};
        NSMutableString *users = @"".mutableCopy;
        for (NSInteger i = 0; i < usersArr.count; i++) {
            if(i == usersArr.count - 1){
                [users appendString:[usersArr objectAtIndex:i]];
            }else{
                [users appendString:[usersArr objectAtIndex:i]];
                [users appendString:@","];
            }
        }
        param = [param vic_appendKey:@"userIds" value:users.copy];
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_FetchNickName] andType:All andWith:param success:^(NSDictionary *dic) {
            LoginModel* model = [LoginModel mj_objectWithKeyValues:dic];
            if ([NSString getDataSuccessed:dic]) {
                for (NSDictionary *dict in model.userNickname) {
                    if([[dict objectForKey:@"userId"] isEqualToString:userId]){
                        NSString *nickName = [dict objectOrNilForKey:@"nickname"];
                        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:nickName portrait:@""];
                        completion(user);
                    }
                }  
            }
            else{}
        } error:^(NSError *error) {}];
        
        //        RCUserInfo *user = [[RCUserInfo alloc] initWithUserId:userId name:userId portrait:@""];
        //        completion(user);
        //        RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:userId];
        //        if(!user){
        //            user = [RCUserInfo new];
        //            [user setName:userId];
        //            [user setUserId:userId];
        //            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
        //        }
        //        completion(user);
    }
}


//-(void)setChatRCIM{
//    [[RCIM sharedRCIM] initWithAppKey:@"8luwapkv8bm7l"];
//    [[RCIM sharedRCIM] connectWithToken:@"eYbxBvNKxbmxtrsqgjTkOZ0Gjtd6aLNiwGROspSycN4AxqZusMAmEd41O2HX5C+d9cxE6vYnphadxVyRQvIg3A==" success:^(NSString *userId) {
//
//        //        2
//        //                    [[RCIM sharedRCIM] connectWithToken:@"YlktLb1Ut8D1+YON7TDiijDHUl/4p6cC2bpS+i9/O5rZnJlm9BZkFnRPxhzfMlHQxDDsJsDWVN0=" success:^(NSString *userId) {
//        //        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//
//        //新建一个聊天会话View Controller对象,建议这样初始化
//
//        //设置会话的类型，如单聊、群聊、聊天室、客服、公众服务会话等
//        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，群聊、聊天室为会话的ID）
//        //        RCConversationViewController *chat = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE
//        //                                                                                                   targetId:@"2"];
//        //
//        //        //设置聊天会话界面要显示的标题
//        //        chat.title = title;
//        //        //显示聊天会话界面
//        //        [self.navigationController pushViewController:chat animated:YES];
//
//
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"登陆的错误码为:%ld", (long)status);
//    } tokenIncorrect:^{
//        //token过期或者不正确。
//        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//        NSLog(@"token错误");
//    }];
//    //
//}

-(void)setNetWorkErrInfo{
    [[YTSharednetManager sharedNetManager] setAFNetStatusChangeBlock:^(managerAFNetworkStatus status) {
        NSMutableDictionary *notiDic = [NSMutableDictionary dictionary];
        [notiDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)status] forKey:@"status"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_NetWorkingStatusRefresh object:notiDic];
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

//4.按Home键使App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
        // To remove all pending notifications which are not delivered yet but scheduled.
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications]; // To remove all delivered notifications
    } else {
        [application cancelAllLocalNotifications];
    }
}
/*发现手机上的app图标右上角一直有个红色的数字1无法清除，但是在代码中已经设置了使角标清除的方法。
 通过测试发现，如果收到通知后点击通知栏进入app，则角标会清除；
 如果收到通知后直接点击app图标或者设置方法使得接收通知后直接跳转页面进入app，则角标不会清除；*/

//3.点击App图标，使App从后台恢复至前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    
    if (@available(iOS 10.0, *)) {
         [[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
        // To remove all pending notifications which are not delivered yet but scheduled.
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications]; // To remove all delivered notifications
    } else {
        [application cancelAllLocalNotifications];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (LoginVM *)vm {
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}

@end
