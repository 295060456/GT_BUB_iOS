//
//  PageVM.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "IdentityAuthVM.h"
#import "IdentityAuthModel.h"
@interface IdentityAuthVM()
@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) IdentityAuthModel* model;
@end

@implementation IdentityAuthVM

- (void)postIdentitySaveFacePlusResultWithRequestParams:(id)requestParams
                                                success:(DataBlock)success
                                                 failed:(DataBlock)failed
                                                  error:(DataBlock)err {
    _listData = [NSMutableArray array];
    
    //    NSString* p =  [NSString stringWithFormat:@"%ld",page];
    //    NSString* pagesize =  @"10";
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    NSDictionary *params = [NSDictionary dictionary];
    
    
    params= requestParams;
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_IdentitySaveFacePlusResult]
                                                     andType:All
                                                     andWith:params
                                                     success:^(NSDictionary *dic) {
                                                         
        self.model = [IdentityAuthModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            //            [YKToastView showToastText:weakSelf.model.msg];
            //            [YKToastView showToastText:[NSString stringWithFormat:@"您的信息已提交，审核中...\n\n如有任何疑问请联系客服：%@",self.model.contact]];
            
            weakSelf.model = [IdentityAuthModel mj_objectWithKeyValues:dic];
            success(weakSelf.model);
            //            [self assembleApiData:weakSelf.model];
            //            success(weakSelf.listData);
        }
        else{
            [YKToastView showToastText:weakSelf.model.msg];
            failed(weakSelf.model);
            
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
        err(error);
    }];
}

- (void)postIdentityApplyWithidCardFont:(NSString *)idCardFont
                          idCardReverse:(NSString *)idCardReverse
                                success:(DataBlock)success
                                 failed:(DataBlock)failed
                                  error:(DataBlock)err {
    
    _listData = [NSMutableArray array];
    
//    NSString* p =  [NSString stringWithFormat:@"%ld",page];
//    NSString* pagesize =  @"10";
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    NSDictionary *params = [NSDictionary dictionary];
    
    params= @{
              @"idCardFont": idCardFont ,
              @"idCardReverse": idCardReverse,
              @"type": @"idno",
              };
    
    [SVProgressHUD showWithStatus:@"数据请求中..." maskType:SVProgressHUDMaskTypeNone];
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager] postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_IdentityApply] andType:All andWith:params success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
            weakSelf.model = [IdentityAuthModel mj_objectWithKeyValues:dic];
            success(weakSelf.model);
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
//        [YKToastView showToastText:error.description];
        err(error);
    }];
}

@end
