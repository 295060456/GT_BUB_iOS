//
//  YBNaviagtionViewController.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "YBNaviagtionViewController.h"


@interface YBNaviagtionViewController ()

@end

@implementation YBNaviagtionViewController

#pragma mark - life cycle

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        [self configNavigationBar];
    }
    return self;
}
#pragma mark - private

- (void)configNavigationBar {
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = YBGeneralColor.navigationBarColor;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:YBGeneralColor.navigationBarTitleColor, NSFontAttributeName:YBGeneralFont.navigationBarTitleFont}];
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:HEXCOLOR(0x333333)}];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
}

#pragma mark - overwrite去

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
+(UINavigationController *)rootNavigationController {
    UITabBarController *tabC = (UITabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    UINavigationController *navigationController = (UINavigationController *)tabC.selectedViewController;
    return navigationController;
}
@end
