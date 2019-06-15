//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TransferVM.h"

@interface TransferVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (nonatomic,strong) TransferModel* model;

@end

@implementation TransferVM
- (void)network_transferBrokeageRateSuccess:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    _listData = [NSMutableArray array];
    
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    WS(weakSelf);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransferBrokeageRate] andType:All andWith:@{} success:^(NSDictionary *dic) {
        self.model = [TransferModel mj_objectWithKeyValues:dic];
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
- (void)network_postMultiTransferWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    _listData = [NSMutableArray array];
    NSArray* requestP = requestParams;
    NSString *pwd = requestP[1];
    if(pwd.length != 32){
        pwd = [NSString MD5WithString:pwd isLowercase:YES];
    }
    NSDictionary *params = @{
                             @"orderNo": requestP[0],
                             @"transactionPassword": pwd,
                             @"googlecode": requestP[2],
                             @"resource": [NSString stringWithFormat:@"%d",[requestP[3] intValue]],
                             };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    WS(weakSelf);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_MultiTransfer] andType:All andWith:params success:^(NSDictionary *dic) {
        self.model = [TransferModel mj_objectWithKeyValues:dic];
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
        [YKToastView showToastText:error.description];
        err(error);
    }];
    [SVProgressHUD dismiss];
}

- (void)network_postTransferWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    _listData = [NSMutableArray array];
    NSArray* requestP = requestParams;
    NSString *pwd = requestP[3];
    if (pwd.length != 32) {
        pwd = [NSString MD5WithString:pwd isLowercase:YES];
    }
    NSDictionary *params = @{
                             @"address": requestP[0],
                             @"number": requestP[1],
                             @"remark": requestP[2],
                             @"transactionPassword": pwd,
                             @"googlecode": requestP[4],
                             @"resource": [NSString stringWithFormat:@"%d",[requestP[5] intValue]],
                             };
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    WS(weakSelf);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Transfer] andType:All andWith:params success:^(NSDictionary *dic) {
        self.model = [TransferModel mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            [YKToastView showToastText:weakSelf.model.msg];
            success(weakSelf.model);
//            [weakSelf assembleApiData:self.model];
//            success(weakSelf.listData);
            
        }
        else{
            [YKToastView showToastText:weakSelf.model.msg];
            failed(weakSelf.model);
            
        }
    } error:^(NSError *error) {
        [YKToastView showToastText:error.description];
        err(error);
    }];
    [SVProgressHUD dismiss];

    
}

- (void)assembleApiData:(TransferModel*)data{
//    [self removeContentWithType:IndexSectionZero];
//
//    NSDictionary* dic = @{kIndexInfo:usModel!=nil?usModel:@"",
//                          kTit:@"UG",
//                          kArr:
//                              @[
//                                 @{kImg:@"banner1",kTit:@"https://www.baidu.com"},
//                                  @{kImg:@"banner2",kTit:@"https://news.baidu.com"},
//                                 @{kImg:@"banner3",kTit:@"http://music.taihe.com"}
//                                  ]
//                          };
//
//    if (page==1) {
//        [self.listData addObject:@{
//                   kIndexSection: @(IndexSectionZero),
//                   kIndexRow: @[dic]}];
//    }
//
//    [self removeContentWithType:IndexSectionOne];
//    NSArray* gridSectionNames = @[@"扫码转账",@"买币",@"我的订单",@"兑换比特币",@"卖币",@"帮助中心"];
//    NSMutableArray* gridParams = [NSMutableArray array];
//    NSArray* gridTypes = @[@(EnumActionTag0),@(EnumActionTag1),@(EnumActionTag2),@(EnumActionTag3),@(EnumActionTag4),@(EnumActionTag5)];//,@(IndexSectionFour)
//    for (int i=0; i<gridSectionNames.count; i++) {
//        NSDictionary * param = @{kArr:gridSectionNames[i],
//                                 kImg:[NSString stringWithFormat:@"chome_grid_%i",i],
//                                 kType:gridTypes[i]
//                                 };
//        [gridParams addObject:param];
//    }
//    if (page==1){
//        [self.listData addObject:@{kIndexSection: @(IndexSectionOne),
//                                   kIndexInfo:@[@"待处理订单",@"icon_bank"],
//                                   kIndexRow: @[gridParams]}];
//    }
//
//    [self removeContentWithType:IndexSectionTwo];
//    if (data.marketList !=nil && data.marketList.count>0) {
//        [self.listData addObject:@{
//
//                kIndexSection: @(IndexSectionTwo),
//                kIndexRow: data.marketList}//data.t.arr
//         ];
//    }
//    [self sortData];
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
