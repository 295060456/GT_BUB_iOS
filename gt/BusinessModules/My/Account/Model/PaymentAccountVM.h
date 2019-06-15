//
//  PaymentAccountVM.h
//  gt
//
//  Created by Aalto on 2019/2/1.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentAccountVM : NSObject
- (void)network_addAccountRequestParams:(NSString *)paymentWay name:(NSString *)name account:(NSString *)account remark:(NSString *)remark tradePwd:(NSString *)tradePwd QRCode:(NSString *)QRCode upperLimit:(NSString*)upperLimit accountOpenBank:(NSString *)accountOpenBank accountOpenBranch:(NSString *)accountOpenBranch accountBankCard:(NSString *)accountBankCard accountBankCardRepeat:(NSString *)accountBankCardRepeat  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

- (void)network_switchAccountRequestParams:(id)requestParams withOpenStatus:(id)status  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

- (void)network_deleteAccountRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

- (void)network_accountListRequestParams:(id)requestParams  success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
