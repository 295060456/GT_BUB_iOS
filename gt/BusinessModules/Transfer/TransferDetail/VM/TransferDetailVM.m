//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TransferDetailVM.h"
#import "TRPageModel.h"
@interface TransferDetailVM()
@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) TRPageData* model;
@end

@implementation TransferDetailVM

- (void)network_postTransferDetailWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    self.listData = [NSMutableArray array];
    if (requestParams==nil) {
        [YKToastView showToastText:@"缺失转帐记录ID"];
        return;
    }
    NSDictionary *params = @{
                   @"transferRecordId":requestParams
                             };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    WS(weakSelf);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransferDetail] andType:All andWith:params success:^(NSDictionary *dic) {
        self.model = [TRPageData mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
//            [YKToastView showToastText:weakSelf.model.msg];
//            success(weakSelf.model);
            [weakSelf assembleApiData:self.model];
            success(weakSelf.listData);
            
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

- (void)assembleApiData:(TRPageData*)data{
    NSDictionary* dic1 = [NSDictionary dictionary];
    dic1 = @{kType:@(TransferDetailTypeSuccess),
             kImg:@"iconSucc",
             kTip:@"转账成功",
             kSubTip:[NSString stringWithFormat:@"%@",data.transferTime],
             kIndexSection:
                 @{kTip:[NSString stringWithFormat:@"%@",@"返回首页"],kSubTip:[NSString stringWithFormat:@"%@",@""]},
             kIndexRow:
                 @[
                     @{@"转账地址：":[data getTransferRecordAdress]},
                     @{@"金额：":[NSString stringWithFormat:@"%@",data.number]},
                     @{@"转账手续费：":[NSString stringWithFormat:@"%@ BUB",data.poundage]},
                     @{@"实际到账：":[NSString stringWithFormat:@"%@ BUB",data.actualNumber]},
                     @{@"交易ID：":[NSString stringWithFormat:@"%@",data.txhash]},
                     @{![NSString isEmpty:[NSString stringWithFormat:@"%@",data.remark]]? @"备注：":@""
                        :![NSString isEmpty:[NSString stringWithFormat:@"%@",data.remark]]?[NSString stringWithFormat:@"%@",data.remark]:@""}
                     
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
