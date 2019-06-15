//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "ExchangeModel.h"
@implementation ExchangeApplyItem : NSObject

@end

@implementation ExchangeRateItem : NSObject

@end

@implementation ExchangeSubPageData : NSObject

@end

@implementation ExchangeSubData : NSObject
- (NSString*)getExchangeTitle{
    NSString* title = @"兑换 BTC";
    return title;
}

- (NSString*)getExchangeSubtitle{
    NSString* title = @"";
    if (![NSString isEmpty:self.number]&&![NSString isEmpty:self.btcNumber]) {
        title = [NSString stringWithFormat:@"%@ BUB = %@ BTC",self.number,self.btcNumber];
    }
    return title;
}

- (NSString*)getExchangeStatusName{
    NSString* title = @"";
    ExchangeType type = [self getExchangeStatus];
    switch (type) {
        case ExchangeTypeHandling:
            title = @"处理中";
            break;
        case ExchangeTypePayed:
            title = @"已汇出";
            break;
        case ExchangeTypeRefused:
            title = @"已驳回";
            break;
        case ExchangeTypeBack:
            title = @"已撤销";
            break;
        default:
            break;
    }
    return title;
}
- (ExchangeType)getExchangeStatus{
    ExchangeType type = ExchangeTypeAll;
    NSInteger tag = [self.status integerValue];
    if (tag  == 0)
    {
        type = ExchangeTypeAll;
    }
    else if (tag  == 1)
    {
        type = ExchangeTypeHandling;
    }
    else if (tag == 2)
    {
        type = ExchangeTypePayed;
    }
    else if (tag == 3)
    {
        type = ExchangeTypeRefused;
    }
    else if (tag == 4)
    {
        type = ExchangeTypeBack;
    }
    return type;
}
@end


@implementation ExchangeModel
- (NSString*)getExchangeStatusName{
    NSString* title = @"";
    ExchangeType type = [self getExchangeStatus];
    switch (type) {
        case ExchangeTypeHandling:
            title = @"处理中";
            break;
        case ExchangeTypePayed:
            title = @"已汇出";
            break;
        case ExchangeTypeRefused:
            title = @"已驳回";
            break;
        case ExchangeTypeBack:
            title = @"已撤销";
            break;
        default:
            break;
    }
    return title;
}
- (NSDictionary*)getExchangePayerAndRefusedStatusName{
    NSDictionary* title = @{};
    ExchangeType type = [self getExchangeStatus];
    switch (type) {
            
        case ExchangeTypePayed:
            title = @{![NSString isEmpty:[NSString stringWithFormat:@"%@",self.rejectReason]]? @"驳回原因：":@""
                       :![NSString isEmpty:[NSString stringWithFormat:@"%@",self.rejectReason]]?[NSString stringWithFormat:@"%@",self.rejectReason]:@""};
            break;
        case ExchangeTypeRefused:
            title = @{[NSString stringWithFormat:@"%@",@"Txid："]
                      :[NSString stringWithFormat:@"%@",self.txhash]};
            break;
            
        default:
            
            break;
    }
    return title;
}
- (ExchangeType)getExchangeStatus{
    ExchangeType type = ExchangeTypeAll;
    NSInteger tag = [self.status integerValue];
    if (tag  == 0)
    {
        type = ExchangeTypeAll;
    }
    else if (tag  == 1)
    {
        type = ExchangeTypeHandling;
    }
    else if (tag == 2)
    {
        type = ExchangeTypePayed;
    }
    else if (tag == 3)
    {
        type = ExchangeTypeRefused;
    }
    else if (tag == 4)
    {
        type = ExchangeTypeBack;
    }
    return type;
}

+(NSDictionary *)objectClassInArray
{
    return @{
             @"exchangeBTC" : [ExchangeSubData class]
             };
}
@end
