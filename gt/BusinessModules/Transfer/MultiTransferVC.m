//
//  TransferVC.m
//  OTC
//
//  Created by mac30389 on 2018/11/29.
//  Copyright © 2018 yang peng. All rights reserved.
//

#import "MultiTransferVC.h"
#import "InputPWPopUpView.h"
#import "PayTablePopUpView.h"
#import "TransferVM.h"
#import "TransferDetailVC.h"
#import "LoginModel.h"
#import "AssetsVC.h"
@interface MultiTransferVC ()<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UIButton * headBtn;
@property (nonatomic,strong)UIButton * IDBtn;
@property (nonatomic, copy) NSString* brokeageRate;
@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, strong) TransferVM *vm;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) PayTablePopUpView* popupView;
@end

@implementation MultiTransferVC

#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    MultiTransferVC *vc = [[MultiTransferVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
//    self.title = @"转账BUB";
//    self.view.backgroundColor = HEXCOLOR(0xf6f5fa);
    [self YBGeneral_baseConfig];
    [self initView];
    
}

#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件 
- (void)YBGeneral_clickBackItem:(UIBarButtonItem *)item {//noscan
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) initView{
    self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headBtn.titleLabel.numberOfLines = 0;
    self.headBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.headBtn];
    [self.headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(0);
        make.trailing.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(50);
        //        make.bottom.equalTo(self.contentView).offset(-48);
        make.height.equalTo(@(20));
    }];
    
    self.IDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.IDBtn.titleLabel.numberOfLines = 0;
    self.IDBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.IDBtn];
    [self.IDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(0);
        make.trailing.equalTo(self.view).offset(0);
        make.top.equalTo(self.headBtn.mas_bottom).offset(7);
        //        make.bottom.equalTo(self.contentView).offset(-48);
        make.height.equalTo(@(20));
    }];
    
    [self richElements];
}
-(void)richElements{
    
    NSString *orderNo =@"";
    NSString * number= @"";
    NSString * rechargeTime= @"";
    
    
    NSString* str = [NSString stringWithFormat:@"%@&" ,self.requestParams];
    NSRange imgSubStart= [str rangeOfString:@"orderNo="];
    NSRange imgSubEnd= [str rangeOfString:@"&"];
    while (imgSubStart.location != NSNotFound) {
        NSRange imgRag = NSMakeRange(imgSubStart.location, imgSubEnd.location - imgSubStart.location + imgSubEnd.length);
        
        orderNo =  [str substringWithRange:imgRag];
        orderNo = [orderNo stringByReplacingOccurrencesOfString:@"orderNo=" withString:@""];
        orderNo = [orderNo stringByReplacingOccurrencesOfString:@"&" withString:@""];
        
        str = [str stringByReplacingCharactersInRange:imgRag withString:@""];
        
        imgSubStart = [str rangeOfString:@"orderNo="];
        imgSubEnd = [str rangeOfString:@"&"];
    }
    self.orderNo = ![NSString isEmpty:orderNo]?orderNo:@"";
    
    NSRange smiSubStart= [str rangeOfString:@"number="];
    NSRange smiSubEnd= [str rangeOfString:@"&"];
    while (smiSubStart.location != NSNotFound) {
        NSRange smiRag = NSMakeRange(smiSubStart.location, smiSubEnd.location - smiSubStart.location + smiSubEnd.length);
        
        number = [str substringWithRange:smiRag];
        number = [number stringByReplacingOccurrencesOfString:@"number=" withString:@""];
        number = [number stringByReplacingOccurrencesOfString:@"&" withString:@""];
        
        str = [str stringByReplacingCharactersInRange:smiRag withString:@""];
        
        smiSubStart = [str rangeOfString:@"number="];
        smiSubEnd = [str rangeOfString:@"&"];
    }
    
    NSRange linSubStart= [str rangeOfString:@"rechargeTime="];
    NSRange linSubEnd= [str rangeOfString:@"&"];
    while (linSubStart.location != NSNotFound) {
        NSRange linRag = NSMakeRange(linSubStart.location, linSubEnd.location - linSubStart.location + linSubEnd.length);
        rechargeTime = [str substringWithRange:linRag];
        rechargeTime = [rechargeTime stringByReplacingOccurrencesOfString:@"rechargeTime=" withString:@""];
        rechargeTime = [rechargeTime stringByReplacingOccurrencesOfString:@"&" withString:@""];
        rechargeTime = [NSString getTimeString:rechargeTime];
        
        str = [str stringByReplacingCharactersInRange:linRag withString:@""];
        
        linSubStart = [str rangeOfString:@"rechargeTime="];
        linSubEnd = [str rangeOfString:@"&"];
    }
    str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@""];
    
    
    LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    
    [self.headBtn setTitle:userInfoModel.userinfo.nickname forState:UIControlStateNormal];
    [self.headBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    self.headBtn.titleLabel.font = kFontSize(20);
    
    
    [self.IDBtn setTitle:userInfoModel.userinfo.userid forState:UIControlStateNormal];
    [self.IDBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    self.IDBtn.titleLabel.font = kFontSize(13);
    
//    [self.headBtn setAttributedTitle:[NSString attributedStringWithString:userInfoModel.userinfo.nickname stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(20) subString:[NSString stringWithFormat:@"\nID：%@",userInfoModel.userinfo.userid] subStringColor:HEXCOLOR(0x666666) subStringFont:kFontSize(13)] forState:UIControlStateNormal];
    
    PayTablePopUpView* popupView = [[PayTablePopUpView alloc]init];
    self.popupView = popupView;
    [popupView richElementsInViewWithModel:@[@{@"订单号":[NSString stringWithFormat:@"%@",orderNo]},@{@"充值时间":[NSString stringWithFormat:@"%@",rechargeTime]}] WithAmount:number];
    [popupView showInApplicationKeyWindow];
//    [popupView showInView:self.view];
    [popupView actionBlock:^(id data) {
        [self postTransEvent:data];
        
    }];
}

- (void)postTransEvent:(NSDictionary*)data{
    [self.vm network_postMultiTransferWithPage:1 WithRequestParams:@[self.orderNo,data.allKeys[0],data.allValues[0],@(TransferWayTypeApp)] success:^(id data) {
        
        [self.popupView showSuccessView:^(id data) {
//            [self.popupView disMissView];
//            [self locateTabBar:3];
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_jumpAssetVC object:nil];
            [AssetsVC pushFromVC:self requestParams:@1 success:^(id data) {
//                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
            
            [self.popupView disMissView];
        }];
        
    } failed:^(id data) {//test
//        [self.popupView showSuccessView:^(id data) {
//            [AssetsVC pushFromVC:self requestParams:@1 success:^(id data) {
////                [self.navigationController popToRootViewControllerAnimated:YES];
//            }];
//
//            [self.popupView disMissView];
//        }];
        
    } error:^(id data) {
        
    }];
    
}
- (TransferVM *)vm {
    if (!_vm) {
        _vm = [TransferVM new];
    }
    return _vm;
}
@end
