//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "PayModel.h"


@implementation PayData : NSObject

@end


@implementation PayModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"paymentWay" : [PayData class]
             };
}
-(NSArray*)getPayways{
    NSMutableArray *pays = [NSMutableArray arrayWithCapacity:3];
    
    for (PayData * data in self.paymentWay) {
        PaywayType type = [data.paymentWay intValue];
        switch (type) {
            case PaywayTypeWX:
                {
                    NSDictionary* dicWX = @{kImg:@"icon_weixin",kTip:@"微信支付",kType:@(PaywayTypeWX),kIsOn:@"1",
                                            kSubTip:@{[NSString stringWithFormat:@"请在 %@ 分钟内向以上收款信息支付 %@ 元，超时将自动取消订单",self.prompt,self.orderAmount]:@"\n点击打开微信App付款"}
                                            ,
                                            kUrl:data.QRCode,
                                            kData:@[
                                                    
                                                    @"付款参考号：",self.paymentNumber
                                                    ]
                                            
                                            };
                    [pays addObject:dicWX];
                }
                break;
            
            case PaywayTypeZFB:
            {
                NSDictionary* dicZFB = @{kImg:@"icon_zhifubao",kTip:@"支付宝",kType:@(PaywayTypeZFB),kIsOn:@"1",
                                        kSubTip:@{[NSString stringWithFormat:@"请在 %@ 分钟内向以上收款信息支付 %@ 元，超时将自动取消订单",self.prompt,self.orderAmount]:@"\n点击打开支付宝App付款"}
                                        ,
                                        kUrl:data.QRCode,
                                        kData:@[
                                                
                                                @"付款参考号：",self.paymentNumber
                                                ]
                                        
                                        };
                [pays addObject:dicZFB];
            }
                break;
                
            case PaywayTypeCard:
            {
                NSDictionary* dicCard = @{kImg:@"icon_bank",kTip:@"银行卡",kType:@(PaywayTypeCard),kIsOn:@"1",
                                          kSubTip:@{[NSString stringWithFormat:@"请在 %@ 分钟内向以上收款信息支付 %@ 元，超时将自动取消订单",self.prompt,self.orderAmount]:@""},
                                          kData:@[
                                                  @{@"开户行：":data.accountOpenBank},
                                                  @{@"银行账号：":data.accountBankCard},
                                                  @{@"收款人姓名：":data.name},
                                                  @{@"付款参考号：":self.paymentNumber}
                                                  ]
                                          
                                          };
                [pays addObject:dicCard];
            }
                break;
            default:
                break;
        }
        
        
    }
    
    return [pays mutableCopy];
    
}

-(NSArray*)getPaywayAppendingDicArr{
    NSMutableArray *pays = [NSMutableArray arrayWithCapacity:3];
    
    for (PayData * data in self.paymentWay) {
        PaywayType type = [data.paymentWay intValue];
        switch (type) {
            case PaywayTypeWX:
            {
                [pays addObject:@{@"微信支付":@(PaywayTypeWX)}];
            }
                break;
                
            case PaywayTypeZFB:
            {
                [pays addObject:@{@"支付宝":@(PaywayTypeZFB)}];
            }
                break;
                
            case PaywayTypeCard:
            {
                [pays addObject:@{@"银行卡":@(PaywayTypeCard)}];
            }
                break;
            default:
                break;
        }
        
        
    }
    return [pays mutableCopy];
}
-(NSString*)getPaywayAppendingString{
    NSMutableArray *pays = [NSMutableArray arrayWithCapacity:3];
    
    for (PayData * data in self.paymentWay) {
        PaywayType type = [data.paymentWay intValue];
        switch (type) {
            case PaywayTypeWX:
            {
                [pays addObject:@"微信"];
            }
                break;
                
            case PaywayTypeZFB:
            {
                [pays addObject:@"支付宝"];
            }
                break;
                
            case PaywayTypeCard:
            {
                [pays addObject:@"银行卡"];
            }
                break;
            default:
                break;
        }
        
        
    }
    NSString *string = [[pays mutableCopy] componentsJoinedByString:@"、"];
    return string;
}
@end
