//
//  YBRootTabBarViewController.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "YBRootTabBarViewController.h"
#import "YBNaviagtionViewController.h"
#import "HomeVC.h"
#import "YBTrendsViewController.h"
//#import "YBMsgViewController.h"
#import "MsgVC.h"
#import "MyVC.h"
#import "AdsVC.h"
#import "TransactionVC.h"
#import "BaseVC.h"

@interface YBRootTabBarViewController ()<UITabBarDelegate,UITabBarControllerDelegate,EAIntroDelegate>{
    
//    UIView *rootView;
//    EAIntroView *_intro;
}

@property (nonatomic, strong) HomeVC *homeVC;
@property (nonatomic, strong) AdsVC *adVC;
@property (nonatomic, strong)TransactionVC*trandsVC;
@property (nonatomic, strong) YBTrendsViewController *trendsVC;
//@property (nonatomic, strong) YBMsgViewController *msgVC;
@property (nonatomic, strong) MsgVC *msgVC;
@property (nonatomic, strong) MyVC *mineVC;

@end

@implementation YBRootTabBarViewController

#pragma mark - life cycle

//static NSString * const sampleDescription1 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
//static NSString * const sampleDescription2 = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
//static NSString * const sampleDescription3 = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
//static NSString * const sampleDescription4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBar.translucent = NO;
    self.tabBar.shadowImage = [UIImage new];
//    self.tabBar.delegate = self;
    [self configSubViewControllers];
    
//    [self showIntroWithCrossDissolve];
}

//-(void)showIntroWithCrossDissolve{
//    
//    EAIntroPage *page1 = [EAIntroPage page];
//    page1.title = @"Hello world";
//    page1.desc = sampleDescription1;
//    page1.bgImage = [UIImage imageNamed:@"bg1"];
////    page1.bgImage = [UIImage imageNamed:@""];
//    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
//    
//    EAIntroPage *page2 = [EAIntroPage page];
//    page2.title = @"This is page 2";
//    page2.desc = sampleDescription2;
//    page2.bgImage = [UIImage imageNamed:@"bg2"];
//    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
//    
//    EAIntroPage *page3 = [EAIntroPage page];
//    page3.title = @"This is page 3";
//    page3.desc = sampleDescription3;
//    page3.bgImage = [UIImage imageNamed:@"bg3"];
//    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
//    
//    EAIntroPage *page4 = [EAIntroPage page];
//    page4.title = @"This is page 4";
//    page4.desc = sampleDescription4;
//    page4.bgImage = [UIImage imageNamed:@"bg4"];
//    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title4"]];
//    
//    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
//    intro.skipButtonAlignment = EAViewAlignmentCenter;
//    intro.skipButtonY = 80.f;
//    intro.pageControlY = 42.f;
//    
//    [intro setDelegate:self];
//    
//    [intro showInView:self.view animateDuration:0.3];
//}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex!=1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsSelectedNoTransactionTabarRefresh object:nil];
    }
    if (tabBarController.selectedIndex!=0&&tabBarController.selectedIndex!=1) {
        YBNaviagtionViewController* naviC = (YBNaviagtionViewController*)viewController;
        NSArray *viewControllers = naviC.viewControllers;
        for (int i=0; i<viewControllers.count; i++) {
            BaseVC* vc = (BaseVC*)viewControllers[i];
            if ([vc isloginBlock]) {
                [vc locateTabBar:0];
                return;
            }
        }
    }
}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView wasSkipped:(BOOL)wasSkipped {
    if(wasSkipped) {
        NSLog(@"Intro skipped");
    } else {
        NSLog(@"Intro finished");
    }
}

#pragma mark - private
- (void)configSubViewControllers {
    self.viewControllers = @[
        [self getViewControllerWithVC:self.homeVC title:@"首页" normalImage:[UIImage imageNamed:@"icon_home_gray"] selectImage:[UIImage imageNamed:@"icon_home_blue"]],
        [self getViewControllerWithVC:self.trandsVC title:@"买币" normalImage:[UIImage imageNamed:@"icon_deal_gray"] selectImage:[UIImage imageNamed:@"icon_deal_blue"]],
        [self getViewControllerWithVC:self.msgVC title:@"消息" normalImage:[UIImage imageNamed:@"icon_massage_gray"] selectImage:[UIImage imageNamed:@"icon_massage_blue"]],
        [self getViewControllerWithVC:self.mineVC title:@"我的" normalImage:[UIImage imageNamed:@"icon_my_gray"] selectImage:[UIImage imageNamed:@"icon_my_blue"]]];
}

- (UIViewController *)getViewControllerWithVC:(UIViewController *)vc title:(NSString *)title normalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage {
    
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:YBGeneralColor.tabBarTitleSelectedColor} forState:UIControlStateSelected];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:YBGeneralColor.tabBarTitleNormalColor} forState:UIControlStateNormal];
    [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
    vc.navigationItem.title = title;
    YBNaviagtionViewController *nav = [[YBNaviagtionViewController alloc] initWithRootViewController:vc];
    return nav;
}

#pragma mark - getter

- (HomeVC *)homeVC {
    if (!_homeVC) {
        _homeVC = [HomeVC new];
    }
    return _homeVC;
}

- (AdsVC *)adVC {
    if (!_adVC) {
        _adVC = [AdsVC new];
    }
    return _adVC;
}

- (TransactionVC *)trandsVC {
    if (!_trandsVC) {
        _trandsVC = [TransactionVC new];
    }
    return _trandsVC;
}
- (YBTrendsViewController *)trendsVC {
    if (!_trendsVC) {
        _trendsVC = [YBTrendsViewController new];
    }
    return _trendsVC;
}

//- (YBMsgViewController *)msgVC {
//    if (!_msgVC) {
//        _msgVC = [YBMsgViewController new];
//    }
//    return _msgVC;
//}

- (MsgVC *)msgVC {
    if (!_msgVC) {
        _msgVC = [MsgVC new];
    }
    return _msgVC;
}
- (MyVC *)mineVC {
    if (!_mineVC) {
        _mineVC = [MyVC new];
    }
    return _mineVC;
}

@end
