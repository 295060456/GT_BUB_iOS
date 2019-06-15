//
//  XcPostAdsVC.m
//  gt
//
//  Created by XiaoCheng on 27/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcPostAdsVC.h"
#import "XcPostAdsXETVC.h"
#import "XcPostAdsGETVC.h"
#import "PostAdsPayChooseView.h"
#import "InputPWPopUpView.h"
#import "XcSafetySetView.h"

#import "XcSecuritySettingsVC.h"
#import "IdentityInfoVC.h"
#import "IdentityAuthVC.h"
#import "AccountVC.h"

@interface XcPostAdsVC()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *xeBtn;
@property (weak, nonatomic) IBOutlet UIButton *geBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *ggScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeading;

@property (nonatomic, strong) XcPostAdsXETVC *receive;
@end

@implementation XcPostAdsVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block{
    
    LoginModel *userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    BOOL istrpwd = [userInfoModel.userinfo.istrpwd isEqualToString:@"1"];
    BOOL bindPayee = [userInfoModel.userinfo.isPaymentWay isEqualToString:@"1"];
    BOOL autonym = [userInfoModel.userinfo.valiidnumber isEqualToString:@"3"];
    BOOL seniorAutonym = [userInfoModel.userinfo.isSeniorCertification isEqualToString:@"1"];

    if (!istrpwd || !bindPayee || !autonym || !seniorAutonym) {
        XcSafetySetView *sView = [[XcSafetySetView alloc] initWithFrame:CGRectZero];
        [sView setPayPwd:istrpwd :^{
            [XcSecuritySettingsVC pushFromVC:rootVC requestParams:@1 success:^(id data) {

            }];
        }];

        [sView setBindPayee:bindPayee :^{
            [AccountVC pushFromVC:rootVC requestParams:@1 success:^(id data) {}];
        }];

        [sView setAutonym:autonym :^{
            [IdentityAuthVC pushFromVC:rootVC requestParams:@1 success:^(id data) {}];
        }];

        [sView setSeniorAutonym:seniorAutonym :^{
            [IdentityAuthVC pushFromVC:rootVC requestParams:@1 success:^(id data) {}];
        }];
        return nil;
    }
    
    XcPostAdsVC *vc = (XcPostAdsVC*)GetStoryboardObj(@"XcPostAdsVC");
    vc.viewModel.requestParams = requestParams;
//    vc.block = block;
    [rootVC.navigationController pushViewController:vc
                                           animated:true];
    return vc;
}

- (void) updateViewConstraints{
    [super updateViewConstraints];
    self.scrollerViewWidth.constant = MAINSCREEN_WIDTH*2;
    singLeton.chooseModelAr1 = [NSMutableArray array];
    singLeton.chooseModelAr2 = [NSMutableArray array];
    [self bindViewModelRequest];
    [self.viewModel.getUserAssertRequest execute:nil];
    [self.viewModel.getPostAdsRequest execute:nil];
    [self.viewModel.getMyAccTypeRequest execute:nil];
    [SVProgressHUD showWithStatus:@"加载中"];
}

- (XcPostAdsViewModel *) viewModel{
    if (!_viewModel) {_viewModel = XcPostAdsViewModel.new;}
    return _viewModel;
}

- (void)bindViewModelRequest{
    @weakify(self)
    [[self.xeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewModel.currentPageType = TransactionAmountTypeLimit;
    }];
    
    [[self.geBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewModel.currentPageType = TransactionAmountTypeFixed;
    }];
    
    //订阅用户资产
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        [self.viewModel.getUserAssertRequest.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:@"1"];
        }];
        
        [self.viewModel.getUserAssertRequest.errors subscribeNext:^(NSError * _Nullable x) {
            [subscriber sendError:x];
        }];
        return nil;
    }];
    
    //订阅广告限额
    RACSignal *s2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        [self.viewModel.getPostAdsRequest.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:@"1"];
        }];
        [self.viewModel.getPostAdsRequest.errors subscribeNext:^(NSError * _Nullable x) {
            [subscriber sendError:x];
        }];
        return nil;
    }];
    
    //订阅收款方式
    RACSignal *s3 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        [self.viewModel.getMyAccTypeRequest.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:@"1"];
        }];
        [self.viewModel.getMyAccTypeRequest.errors subscribeNext:^(NSError * _Nullable x) {
            [subscriber sendError:x];
        }];
        return nil;
    }];
    
    //订阅发布or编辑广告
    [self.viewModel.sendAdsRequest.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[RACObserve(self.viewModel, currentPageType) ignore:nil] subscribeNext:^(id  x) {
        @strongify(self)
        [self setHeaderUI:self.viewModel.currentPageType==TransactionAmountTypeLimit];
    }];
    
    //传数据时调用
    [RACObserve(self.viewModel, requestParams) subscribeNext:^(ModifyAdsModel * x) {
        @strongify(self)
        self.viewModel.currentPageType = [x.amountType isEqualToString:@"2"]?TransactionAmountTypeFixed:TransactionAmountTypeLimit;
    }];
    
    RACSignal *hud = [RACSignal combineLatest:@[s1,s2,s3]];
    [[hud filter:^BOOL(RACTuple *x) {
        return [x.first boolValue]&&[x.second boolValue]&&[x.third boolValue];
    }] subscribeNext:^(id x) {
        @strongify(self)
        for (UIView *v in self.view.subviews) v.hidden = NO;
        [SVProgressHUD dismiss];
    }];
    [[hud filter:^BOOL(RACTuple *x) {
        return [x.first boolValue]&&[x.second boolValue]&&[x.third boolValue];
    }] subscribeError:^(NSError * _Nullable error) {
        @strongify(self)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络异常，请重新加载" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
#pragma clang diagnostic pop
        [alertView show];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
            if ([x isEqual:@(0)]) [self.navigationController popViewControllerAnimated:YES];
        }];
        [SVProgressHUD dismiss];
    }];
}

- (void) setHeaderUI:(BOOL) isxe{
    self.xeBtn.selected = isxe;
    self.geBtn.selected = !isxe;
    
    if (self.ggScrollView.contentSize.width != self.ggScrollView.mj_w*2){
        @weakify(self)
        [[RACScheduler mainThreadScheduler] afterDelay:.2 schedule:^{
            @strongify(self)
            [self.ggScrollView setContentOffset:CGPointMake(isxe?0:self.ggScrollView.mj_w, 0) animated:NO];
        }];
    }else{
        [self.ggScrollView setContentOffset:CGPointMake(isxe?0:self.ggScrollView.mj_w, 0) animated:YES];
    }
}

#pragma mark —— UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    self.lineLeading.constant = (self.xeBtn.mj_w+30)*offset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.x;
    offset = offset/CGRectGetWidth(scrollView.frame);
    self.viewModel.currentPageType = !offset?TransactionAmountTypeLimit:TransactionAmountTypeFixed;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    XcPostAdsXETVC *receive = segue.destinationViewController;
    
    if (self.viewModel.requestParams && [self.viewModel.requestParams.amountType isEqualToString:@"1"] && [receive isMemberOfClass:[XcPostAdsXETVC class]]) {
        RAC(receive.viewModel,requestParams)            = RACObserve(self.viewModel, requestParams);
    }else if (self.viewModel.requestParams && [self.viewModel.requestParams.amountType isEqualToString:@"2"] && [receive isMemberOfClass:[XcPostAdsGETVC class]]) {
        RAC(receive.viewModel,requestParams)            = RACObserve(self.viewModel, requestParams);
    }
    
    RAC(receive.viewModel,adsModel)                 = RACObserve(self.viewModel, adsModel);
    RAC(receive.viewModel,queryUserPropertyModel)   = RACObserve(self.viewModel, queryUserPropertyModel);
    RAC(receive.viewModel,myAccs)                   = RACObserve(self.viewModel, myAccs);
    
    __weak typeof(receive) weakReceive = receive;
    @weakify(self)
    receive.viewModel.alertBlock = ^(NSInteger type) {
        @strongify(self)
        PostAdsPayChooseView *v = [[PostAdsPayChooseView alloc] initWithMydata:self.viewModel.myAccs andType:type block:^(id data) {
            __strong typeof(receive) strongReceive = weakReceive;
            strongReceive.viewModel.reloadDataView();
        }];
        [kAPPDelegate.window addSubview:v];
    };
    if ([receive isKindOfClass:[XcPostAdsXETVC class]]) self.receive = receive;
    
    self.viewModel.submit = ^() {
        @strongify(self)
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:(self.viewModel.currentPageType==TransactionAmountTypeLimit ?self.receive.parameter1:((XcPostAdsGETVC*)receive).parameter2)];
        if (dic.count>0) {
            InputPWPopUpView *popUpView = [[InputPWPopUpView alloc]initWithFrame:CGRectZero
                                                  WithIsForceShowGoogleCodeField:YES];
            [popUpView showInApplicationKeyWindow];
            [popUpView actionBlock:^(NSDictionary* data){
                [dic setObject:[NSString MD5WithString:data.allKeys.firstObject isLowercase:YES] forKey:@"transactionPassword"];
                [dic setObject:data.allValues.firstObject forKey:@"googlecode"];
                [self.viewModel.sendAdsRequest execute:dic];
            }];
        }
    };
}

- (IBAction)clickIssuedAdisAds:(UIButton *)sender {
    self.viewModel.submit();
}

- (void) dealloc{
//    XCLog(@"(%@)-释放成功",self.class);
    singLeton.chooseModelAr1 = nil;
    singLeton.chooseModelAr2 = nil;
}

@end
