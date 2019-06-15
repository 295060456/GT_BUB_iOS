//
//  PageVM.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TransactionVM.h"
#import "TransactionModel.h"
@interface TransactionVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (strong,nonatomic)NSArray* gridSectionNames;
@property (nonatomic,strong) TransactionModel* model;
@end

@implementation TransactionVM


- (void)postTransactionPageListWithPage:(NSInteger)page
                      WithRequestParams:(id)requestParams
                                success:(TwoDataBlock)success
                                 failed:(DataBlock)failed
                                  error:(DataBlock)err {
    _listData = [NSMutableArray array];
    
    NSString* p =  [NSString stringWithFormat:@"%ld",page];
    NSString* pagesize =  @"10";
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    
    NSArray* requestP = requestParams;
    NSDictionary *params = [NSDictionary dictionary];
    
    if(requestP ==nil||requestP.count == 0){
        params = @{
                   @"pageNum": p,
                   @"pageSize": pagesize,
                   
                   @"payWay": @"",
//                   @"type": @"",
                   
                   @"price": @"",
                   
                   @"limitMinPrice": @"",
                   @"limitMaxPrice": @""
                   };
    }
    else{
    TransactionAmountType type= [requestP[1] intValue];
    if (type == TransactionAmountTypeFixed) {
        params = @{
                   @"pageNum": p,
                   @"pageSize": pagesize,
                   
                   @"payWay": requestP[0],
//                   @"type": [NSString stringWithFormat:@"%ld",type],
                   
                   @"price": requestP[2]
                   };
    }else{
        params = @{
                   @"pageNum": p,
                   @"pageSize": pagesize,
                   
                   @"payWay": requestP[0],
                   @"type": [NSString stringWithFormat:@"%ld",type],
                   
                   @"limitMinPrice": requestP[2],
                   @"limitMaxPrice": requestP[3]
                   };
    }
    }
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    WS(weakSelf);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Transaction] andType:All andWith:params success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        self.model = [TransactionModel mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            //            [YKToastView showToastText:weakSelf.model.msg];
            [self assembleApiData:weakSelf.model];
            success(weakSelf.model.page.sum,weakSelf.listData);
        }
        else{
            
//            [YKToastView showToastText:weakSelf.model.msg];
            failed(weakSelf.model);
            
        }
        
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
//        [YKToastView showToastText:@"系统错误"];
//        [YKToastView showToastText:error.description];
        err(error);
    }];
    
}

- (void)assembleApiData:(TransactionModel*)data{
    if (data.advert !=nil && data.advert.count>0) {
        [data.advert enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TransactionData* item = obj;
            [self.listData addObject:@[item]];
        }];
//        [self.listData addObjectsFromArray:data.b];
    }
    
    
}
@end
