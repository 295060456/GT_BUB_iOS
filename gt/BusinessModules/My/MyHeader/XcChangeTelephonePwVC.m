//
//  XcChangeTelephonePwVC.m
//  gt
//
//  Created by XiaoCheng on 10/06/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcChangeTelephonePwVC.h"
#import "UserInfoViewModel.h"
#import "AccountPhoneTipsView.h"
#import "AboutUsModel.h"

@interface XcChangeTelephonePwVC ()
@property (weak, nonatomic) IBOutlet UITextField *pw;
@property (weak, nonatomic) IBOutlet UIButton *yanJing;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, strong) UserInfoViewModel *viewModel;
@end

@implementation XcChangeTelephonePwVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block{
    XcChangeTelephonePwVC *vc = (XcChangeTelephonePwVC*)GetStoryboardObj(@"XcChangeTelephone");
    [rootVC.navigationController pushViewController:vc
                                           animated:true];
    return vc;
}

- (UserInfoViewModel *)viewModel{
    if (!_viewModel) { _viewModel = UserInfoViewModel.new;}
    return _viewModel;
}

- (void)bindViewModelRequest{
    @weakify(self)
    
    [self.pw.rac_textSignal subscribe:RACChannelTo(self.viewModel, pwText)];
    RAC(self.pw,secureTextEntry)= RACObserve(self.yanJing, selected);
    RAC(self.nextBtn,enabled)   = self.viewModel.nextSignal;

    [[self.yanJing rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.yanJing.selected = !self.yanJing.selected;
    }];
    
    [[self.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.verificationPWRequest execute:nil];
    }];
    
    [self.viewModel.verificationPWRequest.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            [AccountPhoneTipsViewObj showFailed:^{
                [self contactService];
            } close:^{}];
        }else{
            [self performSegueWithIdentifier:@"pushPhoneVC" sender:self];
        }
    }];
}

/**
 go 客服
 */
- (void) contactService{
    AboutUsModel *userInfoModel = [AboutUsModel mj_objectWithKeyValues:GetUserDefaultWithKey(SeverData)];
    RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = HandleStringIsNull(userInfoModel.rongCloudId)?userInfoModel.rongCloudId:SERVICE_ID;
    chatService.title = HandleStringIsNull(userInfoModel.rongCloudName)?userInfoModel.rongCloudName:@"客服";
    [self.navigationController pushViewController :chatService animated:YES];
}

@end
