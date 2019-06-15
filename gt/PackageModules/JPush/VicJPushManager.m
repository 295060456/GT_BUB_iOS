//
//  VicJPushManager.m
//  OTC
//
//  Created by Dodgson on 2/23/19.
//  Copyright © 2019 yang peng. All rights reserved.
//

#import "VicJPushManager.h"
#import "BuyBubDetailVC.h"

@implementation VicJPushManager
+ (VicJPushModel *)receivePushContent:(NSDictionary *)dict{
    VicJPushModel *model = [VicJPushModel new];
    NSString *type = [dict objectOrNilForKey:@"pageType"];
    [model setPageType:type.integerValue];
    
    [model setTitle:[dict objectOrNilForKey:@"title"]];
    [model setContent:[dict objectOrNilForKey:@"content"]];
    
    NSDictionary *param = @{};
    param = [param vic_appendKey:@"orderId" value:[dict objectOrNilForKey:@"orderId"]];
    param = [param vic_appendKey:@"otcOrderId" value:[dict objectOrNilForKey:@"otcOrderId"]];
    
    [model setParam:param];
    return model;
}

+ (UIViewController *)getJumpViewControllerWith:(VicJPushModel *)model{
    UIViewController *vc;
    switch (model.pageType) {
        case VicPushPageType_OrderDetail:{
            if (GetUserDefaultBoolWithKey(kIsLogin)) {
//                MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
//                vc = myOrderVC;
            }
            
        }
            break;
    }
    return vc;
}

+ (void)handleJump:(NSDictionary *)dict{
    VicJPushModel *model = [self receivePushContent:dict];
//    OrderDetailVC * orderVC = [OrderDetailVC new];
    
    if(model.pageType == VicPushPageType_OrderDetail){
        
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        
        UIViewController *tabbarController = window.rootViewController;
        
        if ([tabbarController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tabbarVC = (UITabBarController *)tabbarController;
            
            if([tabbarVC.selectedViewController isKindOfClass:[UINavigationController class]]){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",model.title]
                                                                               message:[NSString stringWithFormat:@"%@",model.content]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"稍后再说"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"现在去看"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {

                                                            [BuyBubDetailVC pushFromVC:tabbarVC.navigationController requestParams:[model.param objectOrNilForKey:@"otcOrderId"] success:^(id data) {
                                                                
                                                            }];
                                                            
//                    [OrderDetailVC pushViewController:tabbarVC
//                                        requestParams:[model.param objectOrNilForKey:@"otcOrderId"]
//                                              success:^(id data) {
//
//                    }];
                }]];
                
                [tabbarVC presentViewController:alert
                                       animated:true
                                     completion:nil];
                
//                [OrderDetailVC pushTabViewController:tabbarVC requestParams:[model.param objectOrNilForKey:@"otcOrderId"] success:^(id data) {
//
//                }];
                
            }
        }
    }
}

@end
