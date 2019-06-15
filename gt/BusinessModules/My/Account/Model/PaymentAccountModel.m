//  Created by Aalto on 2019/2/1.
//  Copyright © 2019 GT. All rights reserved.
//
#import "PaymentAccountModel.h"
#define kPaywayTypeWX   @"1"
#define kPaywayTypeZFB  @"2"
#define kPaywayTypeCard @"3"
@implementation PaymentAccountData
- (NSDictionary*)getPaymentAccountTypeName{
    NSDictionary* dic = @{@"":@""};
    
    
    PaywayType type = [self getPaymentAccountType];
    switch (type) {
        case PaywayTypeWX:
            dic = @{@"微信":@"icon_weixin"};
            break;
        case PaywayTypeZFB:
            dic = @{@"支付宝":@"icon_zhifubao"};
            break;
        case PaywayTypeCard:
            dic = @{@"银行卡":@"icon_bank"};
            break;
        default:
            
            break;
    }
    return dic;
}

- (PaywayType )getPaymentAccountType{
    PaywayType type = PaywayTypeNone;
    NSString* tag = self.paymentWay ;
    if ([tag isEqualToString:kPaywayTypeWX])
    {
        type = PaywayTypeWX;
    }
    else if ([tag isEqualToString:kPaywayTypeZFB])
    {
        type = PaywayTypeZFB;
    }
    else if ([tag isEqualToString: kPaywayTypeCard])
    {
        type = PaywayTypeCard;
    }
    
    return type;
}
@end


@implementation PaymentSectionMo

+(NSDictionary *)objectClassInArray
{
    return @{
             @"data" : [PaymentAccountData class]
             };
}

@end





@implementation PaymentAccountModel
+(NSDictionary *)objectClassInArray
{
    return @{
//             @"paymentWay" : [PaymentAccountData class],
              @"datas" : [PaymentSectionMo class]
             };
}
@end

