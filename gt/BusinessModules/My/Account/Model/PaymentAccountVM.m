
//
//  PaymentAccountVM.m
//  gt
//
//  Created by Aalto on 2019/2/1.
//  Copyright © 2019 GT. All rights reserved.
//

#import "PaymentAccountVM.h"
#import "PaymentAccountModel.h"
@interface PaymentAccountVM()

@property (strong,nonatomic)NSMutableArray   *listData;
@property (nonatomic,strong) PaymentAccountModel* model;

@property (nonatomic, strong) NSDictionary* requestParams;
@end
@implementation PaymentAccountVM
- (void)network_accountListRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    NSDictionary* proDic =
    @{
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_PayMentAccountList] andType:All andWith:proDic success:^(NSDictionary *dic) {
        
        NSMutableDictionary *maxMutDic = [self dicToDicWith:dic];
        self.model = [PaymentAccountModel mj_objectWithKeyValues:maxMutDic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsPayCellInPostAdsRefresh object:nil ];
            success(self.model);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
        
    }];
}

- (void)network_switchAccountRequestParams:(id)requestParams withOpenStatus:(id)status  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    NSDictionary* proDic =
    @{@"paymentWayId":requestParams,
      @"status":status
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_EditAccount] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [PaymentAccountModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
            [YKToastView showToastText:self.model.msg];
            success(weakSelf.model.paymentWay);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
        
    }];
}
- (void)network_deleteAccountRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    NSDictionary* proDic =
    @{@"paymentWayId":requestParams
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_DeleteAccount] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [PaymentAccountModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.model.paymentWay);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
    }];
}

- (void)network_addAccountRequestParams:(NSString *)paymentWay name:(NSString *)name account:(NSString *)account remark:(NSString *)remark tradePwd:(NSString *)tradePwd QRCode:(NSString *)QRCode upperLimit:(NSString*)upperLimit accountOpenBank:(NSString *)accountOpenBank accountOpenBranch:(NSString *)accountOpenBranch accountBankCard:(NSString *)accountBankCard accountBankCardRepeat:(NSString *)accountBankCardRepeat  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    NSDictionary* proDic =
    @{
      @"paymentWay": paymentWay,
      @"name": name,
      @"account": account,
      @"onedaylimit": upperLimit,
      @"tradePwd": tradePwd,
      @"QRCode": QRCode == nil ? @"" : QRCode,
      @"accountOpenBank": accountOpenBank,
      @"accountOpenBranch": accountOpenBranch,
      @"accountBankCard": accountBankCard,
      @"accountBankCardRepeat": accountBankCardRepeat,
      };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_AddAccount] andType:All andWith:proDic success:^(NSDictionary *dic) {
        self.model = [PaymentAccountModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        [YKToastView showToastText:self.model.msg];
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.model);
        }
        else{
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
        
    }];
    
}

-(NSMutableDictionary*)dicToDicWith:(NSDictionary*)dic{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
        [mutDic setObject:dic[@"errcode"] forKey:@"errcode"];
        [mutDic setObject:dic[@"msg"] forKey:@"msg"];
        NSArray *dataAr  = dic[@"paymentWay"];
        if (dataAr && dataAr.count>0) {
            NSMutableArray *ar1 = [NSMutableArray array];
            NSMutableArray *ar2 = [NSMutableArray array];
            NSMutableArray *ar3 = [NSMutableArray array];
            for (NSDictionary *miniDic in dataAr) {
                NSString *typS = [NSString stringWithFormat:@"%@",miniDic[@"paymentWay"]];
                NSInteger ty = [typS integerValue];
                if (ty == 1) {
                    [ar1 addObject:miniDic];
                }else if (ty == 2){
                    [ar3 addObject:miniDic];
                }else if (ty == 3){
                    [ar2 addObject:miniDic];
                }
                
            }
            NSMutableArray *mAr = [NSMutableArray array];
            if (ar2.count > 0) {
                [mAr addObject:@{@"title":@"银行账户",
                                 @"data" : ar2,
                                 }];
            }
            if (ar1.count>0) {
                [mAr addObject: @{@"title":@"微信账号",
                                  @"data" : ar1,
                                  }];
            }
            if (ar3.count > 0) {
                [mAr addObject:@{@"title":@"支付宝",
                                 @"data" : ar3,
                                 }];
            }
            [mutDic setObject:mAr forKey:@"datas"];
        }else{
            [mutDic setObject:@[] forKey:@"datas"];
        }
    return mutDic;
}






@end
