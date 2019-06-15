//
//  PageVM.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TRPageVM.h"
@interface TRPageVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (strong,nonatomic)NSArray* gridSectionNames;
@property (nonatomic,strong) TRPageModel* model;
@end

@implementation TRPageVM
- (void)postTRPageListWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    _listData = [NSMutableArray array];
    
    NSString* p =  [NSString stringWithFormat:@"%ld",page];
    NSString* pagesize =  @"10";
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    
    NSDictionary *params = @{
                            @"type":requestParams,
                             @"pageno": p,
                             @"pagesize":pagesize
                             };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    WS(weakSelf);
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransferRecord] andType:All andWith:params success:^(NSDictionary *dic) {
        self.model = [TRPageModel mj_objectWithKeyValues:dic];
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

- (void)assembleApiData:(TRPageModel*)data{
    if (data.transferRecord !=nil && data.transferRecord.count>0) {
        [data.transferRecord enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TRPageData* item = obj;
            [self.listData addObject:@[item]];
        }];
//        [self.listData addObjectsFromArray:data.b];
    }
}
@end
