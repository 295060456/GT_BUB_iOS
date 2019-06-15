//
//  HomeVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "HomeVC.h"
#import "HomeView.h"
#import "HomeVM.h"
#import "HomeGuidePageManager.h"
#import "WebViewController.h"
#import "HomeScanView.h"
#import "ScanCodeVC.h"
#import "TransferRecordVC.h"
#import "TransactionVC.h"
#import "OrdersVC.h"
#import "ExchangeVC.h"
#import "SlideTabBarVC.h"
#import "XcPostAdsVC.h"
#import "HelpCentreVC.h"
#import "LoginModel.h"
#import "IdentityAuthVC.h"
#import "AssetsVC.h"
#import "Pop_up_windowsView.h"
#import "SubmitOrderPopView.h"
#import "UbuXCNetworking.h"
#import "UpgradeAlertView.h"
#import "BuyBubDetailVC.h"
#import "OrderDetailModel.h"

@interface HomeVC () <HomeViewDelegate>
@property (nonatomic, strong) HomeView *mainView;
@property (nonatomic, strong) HomeVM *homeVM;

@end

@implementation HomeVC

#pragma mark - life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initView];
    
    [self.homeVM network_checkFixedPricesSuccess:^(id data) {

    } failed:^(id data) {

    } error:^(id data) {

    }];
    [self showGuidePages];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    self.navigationController.delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES
                                             animated:animated];
    [self setStatusBarBackgroundColor:kClearColor];
    [self loginSuccessBlockMethod];
    
    [self getInformation];

}


-(void)getInformation{
    
     BOOL valueLogin = GetUserDefaultBoolWithKey(kIsLogin);
    if (valueLogin) {
        //    Xiran   要是登录情况才会获取个人信息
        /*获取个人信息
         */
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_CheckUserInfo]
                                                         andType:All
                                                         andWith:@{}
                                                         success:^(NSDictionary *dic) {
                                                             if ([NSString getDataSuccessed:dic]) {
                                                                 [[RACScheduler mainThreadScheduler]afterDelay:.5 schedule:^{
                                                                     SetUserDefaultKeyWithObject(kUserInfo, dic);
                                                                     UserDefaultSynchronize;
                                                                 }];
                                                             }
                                                         } error:^(NSError *error) {}];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)initView {
    
    [self.view addSubview:self.mainView];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self.mainView actionBlock:^(id data, id data2) {
        EnumActionTag type = [data integerValue];
    
        switch (type) {
                
            case EnumActionTag7://scan
            case EnumActionTag0:
            {
                if([self isloginBlock])return;
                if (GetUserDefaultBoolWithKey(kIsScanTip)) {
                    [ScanCodeVC pushFromVC:self];
                }else{
                    HomeScanView* scanView = [[HomeScanView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
                    //                    __weak __typeof(scanView) weakView = scanView;
                    scanView.scanBlock = ^{
                        [ScanCodeVC pushFromVC:self];
                    };
                    scanView.buyBlock = ^{
                        [self locateTabBar:1];
                    };
                    scanView.helpBlock = ^{
                        [HelpCentreVC pushFromVC:self requestParams:@1 success:^(id data) {
                            
                        }];
                    };
                    scanView.cancelBlock = ^{
                    };
                    //                    [self.tabBarController.view addSubview:scanView];
                    [[UIApplication sharedApplication].keyWindow addSubview:scanView];
                }
                
            }
                break;
            case EnumActionTag1:
            {
                //                if([self isloginBlock])return;
                [self locateTabBar:1];
            }
                break;
            case EnumActionTag2:
            {
                if([self isloginBlock])return;
                [OrdersVC pushFromVC:self];
            }
                break;
            case EnumActionTag3:
            {
                if([self isloginBlock])return;
                [ExchangeVC pushFromVC:self];
            }
                break;
            case EnumActionTag4:
            {
                if([self isloginBlock])return;
                
                [self netWorkMyPaymentWay];
            }
                break;
            case EnumActionTag5://help
            {
                [HelpCentreVC pushFromVC:self requestParams:@1 success:^(id data) {
                    
                }];
            }
                break;
            case EnumActionTag6://remind
            {
                if([self isloginBlock])return;
                [self locateTabBar:2];
            }
                break;
                
            case EnumActionTag8://login
            {
                if([self isloginBlock])return;
            }
                break;
            case EnumActionTag9://record
            {
                if([self isloginBlock])return;
                [TransferRecordVC pushFromVC:self];
            }
                break;
            case EnumActionTag10://banner
            {
                //                if([self isloginBlock])return;
                HomeBannerData *model = data2;
                if (HandleStringIsNull(model.clickUrl) && [model.clickUrl containsString:@"http"]) {
                    [WebViewController pushFromVC:self requestUrl:model.clickUrl //data2[kTit]
                                withProgressStyle:DKProgressStyle_Gradual success:^(id data) {}];
                }
            }
                break;
            case EnumActionTag11://banner
            {
                [self netwoekingErrorDataRefush];
            }
                break;
            case EnumActionTag12://asset
            {
                [AssetsVC pushFromVC:self requestParams:@1 success:^(id data) {
                    
                }];
            }
                break;
            case EnumActionTag13://asset
            {
                 if([self isloginBlock])return;
                [self toBuyBUB:data2];
            }
                break;
            default:
                break;
        }
    }];
}

//请求我的收款方式
-(void)netWorkMyPaymentWay{
    [XcPostAdsVC pushFromVC:self requestParams:nil success:^(id data) {}];
}

-(void)loginSuccessBlockMethod{
    
    [self homeView:self.mainView requestHomeListWithPage:1];
}

-(void)netwoekingErrorDataRefush{
    
    [self homeView:self.mainView requestHomeListWithPage:1];
}

#pragma mark - HomeViewDelegate
- (void)homeView:(HomeView *)view requestHomeListWithPage:(NSInteger)page {
    
    kWeakSelf(self);
    [self.homeVM network_getHomeListWithPage:page
                                     success:^(id data) {
                                         
                                         kStrongSelf(self);
                                         
                                         if ([data isKindOfClass:[NSNumber class]]) {
                                             
                                             NSNumber* n= data;
                                             
                                             NSInteger i =  [n integerValue];
                                             
                                             if (i != 1) {
                                                 
                                                 if([self isloginBlock])return;
                                             }
                                         }
                                         
                                         [self.mainView requestHomeListSuccessWithArray:data
                                                                               WithPage:page];
                                         
                                     } failed:^(id data) {
                                         
                                         kStrongSelf(self);
                                         
                                         [self.mainView requestHomeListFailed];
                                     } error:^(id data) {
                                         
                                         kStrongSelf(self);
                                         
                                         [self.mainView requestHomeListFailed];
                                     }];
    
}

#pragma mark - getter

- (HomeView *)mainView {
    
    if (!_mainView) {
        
        _mainView = [HomeView new];
        
        _mainView.delegate = self;
    }
    
    return _mainView;
}

- (HomeVM *)homeVM {
    
    if (!_homeVM) {
        
        _homeVM = [HomeVM new];
    }
    return _homeVM;
}

- (void)showGuidePages{
    
    kWeakSelf(self);
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FOURORDER"]) {//上线的时候记得要把引导页打开
//        [[HomeGuidePageManager shareManager] showGuidePageWithType:ABGuidePageTypeScan
//                                                        completion:^{
//                                                            [[HomeGuidePageManager shareManager] showGuidePageWithType:ABGuidePageTypeBuy
//                                                                                                            completion:^{
//                                                                                                                [[HomeGuidePageManager shareManager] showGuidePageWithType:ABGuidePageTypeSale
//                                                                                                                                                                completion:^{
//                                                                                                                                                                    [[HomeGuidePageManager shareManager] showGuidePageWithType:ABGuidePageTypeOrder
//                                                                                                                                                                                                                    completion:^{
//                                                                                                                                                                                                                        kStrongSelf(self);
//                                                                                                                                                                                                                        [self pop_up_window];
//                                                                                                                                                                                                                    }];
//                                                                                                                                                                }];
//                                                                                                            }];
//                                                        }];
    }else{
        [self checkVersionNew];
    }
}


-(void)pop_up_window{
    
    if ([NSObject isFirstLaunchApp]) {//当日首次启动App展示
        Pop_up_windowsView *popView = [[Pop_up_windowsView alloc]init];
        [self.view addSubview:popView];
        [popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

-(void)toBuyBUB:(NSString*)number{
    SubmitOrderPopView *submitOrderPopView = [[SubmitOrderPopView alloc]initWithPaymentWay:@"123"
                                                                                QuotaStyle:TransactionAmountTypeLimit];
    submitOrderPopView.leftTextField.text = number?number:@"";
    submitOrderPopView.rightTextField.text = number?number:@"";
    [submitOrderPopView showInApplicationKeyWindow];
        kWeakSelf(self);
    [submitOrderPopView noeBuyBubActionAnd:number.length>0?YES:NO block:^(id data) {
        [weakself gotoOrderDetailVC:submitOrderPopView.rightTextField.text andPayType:[NSString stringWithFormat:@"%@",data] and:submitOrderPopView];
    }];

}

-(void)checkVersionNew{
    [UbuXCNetworkingObj getVersionInfo:@{}
                               succeed:^(AboutUsModel * _Nonnull result) {
                                   if (result) {
                                       if (result.errcode && result.errcode.intValue == 1) {
                                           XcUpgradeAlertViewObj.model = result;
                                       }
                                   }} failed:^(NSError * _Nonnull error) {}];
}

-(void)gotoOrderDetailVC:(NSString*)payCny andPayType:(NSString*)payType and:(SubmitOrderPopView *)submitOrderPopView{
    if (!HandleStringIsNull(payCny)) {
        [YKToastView showToastText:@"输入的金额不能为空"];
        return;
    }
    NSDictionary *dic = @{@"payCny":payCny,@"getBub":payCny,@"payWay":payType};
    kWeakSelf(self);
    [self.homeVM networkNoeBuyBubPostDataWith:dic esSuccess:^(id data) {
        [submitOrderPopView disMissView];
        [BuyBubDetailVC pushFromVC:weakself.navigationController requestParams:data success:^(id data) {}];
    } failed:^(id data) {} error:^(id data) {}];
}


@end
