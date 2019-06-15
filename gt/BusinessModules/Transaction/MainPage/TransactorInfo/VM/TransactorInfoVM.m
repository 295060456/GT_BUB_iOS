//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TransactorInfoVM.h"

@interface TransactorInfoVM()
@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) TransactorInfoModel* model;
@end

@implementation TransactorInfoVM

- (void)network_postTransactorInfoWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    _listData = [NSMutableArray array];
    TransactionData* itemData = requestParams;
    
    NSDictionary *params = @{
                   @"userId": itemData.userId
                             };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    WS(weakSelf);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactorInfo] andType:All andWith:params success:^(NSDictionary *dic) {
        self.model = [TransactorInfoModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            
//            [YKToastView showToastText:weakSelf.model.msg];
            success(weakSelf.model);
//            [weakSelf assembleApiData:self.model];
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
- (void)assembleApiData:(TransactorInfoModel*)model{
    NSDictionary* dic1 = [NSDictionary dictionary];
    
    dic1 = @{kType:@(TransferDetailTypeSuccess),
                           kImg:@"iconSucc",
                           kTip:@"转账成功",
                           kSubTip:[NSString stringWithFormat:@"%@",@""],
                           kIndexSection:
                               @{kTip:[NSString stringWithFormat:@"%@",@"返回首页"],kSubTip:[NSString stringWithFormat:@"%@",@""]},
                           kIndexRow:
                               @[
                     
                            @{@"金额：":@""},
                            @{@"交易ID：":@""},
                            @{@"备注：":@""}
                                   ]
             
                           };

    
    
    
    [self.listData addObjectsFromArray:@[dic1]];
}
- (void)sortData {
    [self.listData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *number1 = [NSNumber numberWithInteger:[[obj1 objectForKey:kIndexSection] integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger:[[obj2 objectForKey:kIndexSection] integerValue]];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending;
    }];
}

- (void)removeContentWithType:(IndexSectionType)type {
    [self.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IndexSectionType contentType = [[(NSDictionary *)obj objectForKey:kIndexSection] integerValue];
        if (contentType == type) {
            *stop = YES;
            [self.listData removeObject:obj];
        }
    }];
}
@end
