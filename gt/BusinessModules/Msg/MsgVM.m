//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "MsgVM.h"
#import "MsgModel.h"
#import "EventListModel.h"

@interface MsgVM()

@property (strong,nonatomic)NSMutableArray   *listData;

@property (nonatomic,strong) MsgModel* model;

@property (nonatomic,strong) EventListModel* eventListModel;

@property (nonatomic, strong) NSDictionary* requestParams;

@end

@implementation MsgVM
- (void)network_notReadMessageWithPageno:(NSString *)pageno//页号
                                pagesize:(NSString *)pagesize//每页多少
                                 success:(DataBlock)success
                                  failed:(DataBlock)failed
                                   error:(DataBlock)err {
    
    self.listData = [NSMutableArray array];
    
    NSDictionary* proDic =@{
                            @"pageno": pageno,
                            @"pagesize": pagesize,
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_NoReadMsgList]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
        self.model = [MsgModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
//            success(weakSelf.model);
            [self assembleApiData:weakSelf.model];
            success(weakSelf.listData);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
}

- (void)assembleApiData:(MsgModel*)data{
    if (data.messageList !=nil && data.messageList.count>0) {
        [self.listData addObjectsFromArray:data.messageList];
    }
}

- (void)network_eventMsgListWithPageno:(NSString *)pageno
                              pagesize:(NSString *)pagesize
                         eventListType:(NSString *)type
                               success:(DataBlock)success
                                failed:(DataBlock)failed
                                 error:(DataBlock)err {
    self.listData = [NSMutableArray array];
    NSDictionary* proDic =@{
                            @"type": type,
                            @"pageno": pageno,
                            @"pagesize": pagesize,
                            };
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_EventMsgList]
                                                     andType:All
                                                     andWith:proDic
                                                     success:^(NSDictionary *dic) {
                                                         
        self.eventListModel = [EventListModel mj_objectWithKeyValues:dic];
        [SVProgressHUD dismiss];
        
        if ([NSString getDataSuccessed:dic]) {
            //            success(weakSelf.model);
            [self assembleEventMsgListApiData:weakSelf.eventListModel];
            success(weakSelf.listData);
        }
        else{
            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        err(error);
        [YKToastView showToastText:error.description];
    }];
}

- (void)assembleEventMsgListApiData:(EventListModel*)data{
    if (data.allMessage !=nil && data.allMessage.count>0) {
        [self.listData addObjectsFromArray:data.allMessage];
    }
}

@end
