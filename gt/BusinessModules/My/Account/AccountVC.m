//
//  AccountVC.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.

#import "AccountVC.h"
#import "AccountMianView.h"
#import "PaymentAccountVM.h"
#import "PaymentAccountModel.h"
#import "AddAccountVC.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "OtherFogetGetPwView.h"
@interface AccountVC (){
    AccountMianView *mainV;
    UIButton *addButton;
}
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) PaymentAccountVM* vm;
@property (nonatomic, strong) MWPhotoBrowser *potoBrowesr;
@end

@implementation AccountVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    AccountVC *vc = [[AccountVC alloc] init];
    vc.block = block;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件
//-(void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"收款账户";
    self.vm = [[PaymentAccountVM alloc] init];
    kWeakSelf(self);
    self->mainV = [[AccountMianView alloc] initWithBlockSuccess:^(NSInteger types, id data) {
        [weakself mainViewAction:types andData:data];
    }];
    [self.view addSubview:self->mainV];
    [self getData];
    [self addRightBarItem];
}

-(void)addRightBarItem{
    self->addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self->addButton.frame = CGRectMake(0, 0, 80, 40);
    self->addButton.titleLabel.font = kFontSize(17);
    [self->addButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    self->addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self->addButton addTarget:self action:@selector(editClickeds) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self->addButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self->addButton.selected = YES;
    [self->addButton setTitle:@"删除" forState:UIControlStateNormal];
    self->addButton.hidden = YES;
}

-(void)mainViewAction:(NSInteger)type andData:(id)data{
    switch (type) {
        case accountAdd:{
            [self addAccountNumber];
        }break;
        case accountfreshHeader:{
            [self getData];
        } break;
        case accountBigPicture:{
            [self accountBigPicture:data];
        }break;
        case accountDetele:{
            [self accountDetele:data];
        } break;
        default:
            break;
    }
}

-(void)addAccountNumber{
    kWeakSelf(self);
    OtherFogetGetPwView *view = [[OtherFogetGetPwView alloc] initOtherFogetTitle:@"请选择收款账户类型" andDataAr:@[@"微信账户",@"支付宝账户",@"银行卡账号"] viewWithBolck:^(NSInteger types, id data) {
        kStrongSelf(self);
        [AddAccountVC pushFromVC:weakself withPaywayType:types+1 paywayOccurType:PaywayOccurTypeCreate success:^(id data) {
                             [self getData];
         }];
    }];
    [kAPPDelegate.window addSubview:view];
}



-(void)accountBigPicture:(PaymentAccountData *)data{
    
    MWPhoto *po = [MWPhoto photoWithURL:[NSURL URLWithString:data.QRCode]];
    NSArray *ar = @[po];
    _potoBrowesr = [[MWPhotoBrowser alloc] initWithPhotos:ar];
    _potoBrowesr.displayActionButton = NO;
    [self.navigationController pushViewController:_potoBrowesr animated:YES];
    [self performSelector:@selector(toChengColer) withObject:nil afterDelay:0.3];
}

-(void)toChengColer{
    if (_potoBrowesr) {
        _potoBrowesr.navigationController.navigationBar.barTintColor = kWhiteColor;
        _potoBrowesr.title = @"收款二维码";
        [YBSystemTool modifyNavigationBarWith:_potoBrowesr.navigationController];
    }
}

-(void)accountDetele:(NSArray*)ar{
    if (ar== nil || ar.count == 0) {
        return;
    }
    kWeakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除所选账号？" message:nil preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakself) strongSelf = weakself;
        strongSelf->addButton.selected = NO;
        [strongSelf editClickeds];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakself) strongSelf = weakself;
        NSString *paymentWayId = @"";
        for (PaymentAccountData *mo in ar) {
            paymentWayId = [NSString stringWithFormat:@"%@,%@",mo.paymentWayId,paymentWayId];
        }
        if (paymentWayId.length > 1) {
            paymentWayId = [paymentWayId substringToIndex:[paymentWayId length] - 1];
        }
        [weakself.vm network_deleteAccountRequestParams:paymentWayId success:^(id data) {
            [weakself getData];
        } failed:^(id data) {
            strongSelf->addButton.selected = YES;
            [strongSelf editClickeds];
        } error:^(id data) {
            strongSelf->addButton.selected = YES;
            [strongSelf editClickeds];
        }];
    }]];
    [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:true completion:nil];
}


-(void)editClickeds{
    if (self->addButton.selected) {
        [self->addButton setTitle:@"完成" forState:UIControlStateNormal];
        self->addButton.selected = NO;
        [self->mainV toEdit:YES];
    }else{
        self->addButton.selected = YES;
        [self->addButton setTitle:@"删除" forState:UIControlStateNormal];
        [self->mainV toEdit:NO];
    }
}

-(void)getData{
    kWeakSelf(self);
    [self.vm network_accountListRequestParams:@(1)
                                      success:^(id data) {
                                          __strong typeof(weakself) strongSelf = weakself;
                                          [strongSelf->mainV reloadDataWith:data];
                                          PaymentAccountModel *mo = data;
                                          NSArray *ar = mo.datas;
                                          if (ar == nil || ar.count == 0) {
                                              strongSelf->addButton.hidden = YES;
                                          }else{
                                              strongSelf->addButton.hidden = NO;
                                          }
                                      } failed:^(id data) {
                                          [self->mainV reloadDataWith:nil];
                                      } error:^(id data) {
                                          [self->mainV reloadDataWith:nil];
                                      }];
}
@end

