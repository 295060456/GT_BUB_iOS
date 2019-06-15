
//  Created by Aalto on 2019/2/1.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PaymentAccountData : NSObject

@property (nonatomic, copy) NSString *paymentWayId;
@property (nonatomic, copy) NSString *paymentWay;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *onedaylimit;
@property (nonatomic, copy) NSString *QRCode;
@property (nonatomic, copy) NSString *accountOpenBank;
@property (nonatomic, copy) NSString *accountOpenBranch;
@property (nonatomic, copy) NSString *accountBankCard;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) BOOL showChooseCell;
@property (nonatomic, assign) BOOL editChooseCell;
- (NSDictionary*)getPaymentAccountTypeName;
- (PaywayType )getPaymentAccountType;
@end


@interface PaymentSectionMo : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *data;
+(NSDictionary *)objectClassInArray;
@end




@interface PaymentAccountModel : NSObject
@property (nonatomic, strong) NSString *err_code;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSArray *paymentWay;
@property (nonatomic, strong) NSArray *datas;

+(NSDictionary *)objectClassInArray;
@end

NS_ASSUME_NONNULL_END
