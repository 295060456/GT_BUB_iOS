//
//  YBHomeDataCenter.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsgVM : NSObject
- (void)network_notReadMessageWithPageno:(NSString *)pageno pagesize:(NSString *)pagesize success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
- (void)network_eventMsgListWithPageno:(NSString *)pageno pagesize:(NSString *)pagesize eventListType:(NSString *)type success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
