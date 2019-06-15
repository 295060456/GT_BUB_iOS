//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "AssetsModel.h"
// 经过和产品确认有8种类型
//1-转入 2-转出 3-买入 4-卖出 5-兑换BTC 6-充值 7-代付 8-提现
#define kUserAssetsTypeAll          @"0"  //wu
#define kUserAssetsTypeTransferIn   @"1"
#define kUserAssetsTypeTransferOut  @"2"
#define kUserAssetsTypeBuyIn        @"3"
#define kUserAssetsTypeSellOut      @"4"
#define kUserAssetsTypeBTC          @"5"
#define kUserAssetsTypeRecharge     @"6"
#define kUserAssetsTypePay          @"7"
#define kUserAssetsTypeTX           @"8"


@implementation AssetsSubPageData

@end

@implementation AssetsData
- (UIColor*)getUserAssetsNumColor{
    UIColor* color = kBlackColor;
    UserAssetsType type = [self getUserAssetsType];
    switch (type) {
        case UserAssetsTypeTransferIn:
        case UserAssetsTypeBuyIn:
        case UserAssetsTypeRecharge:
            color = HEXCOLOR(0x006151);
            break;
        case UserAssetsTypeTransferOut:
        case UserAssetsTypeSellOut:
        case UserAssetsTypeBTC:
        case UserAssetsTypePay:
        case UserAssetsTypeTX:
            color = HEXCOLOR(0xd02a2a);
            break;
        default:
            break;
    }
    return color;
}
- (NSString*)getUserAssetsNum{
    NSString* title = @"";
    UserAssetsType type = [self getUserAssetsType];
    switch (type) {
        case UserAssetsTypeTransferIn:
        case UserAssetsTypeBuyIn:
        case UserAssetsTypeRecharge:
            title = [NSString stringWithFormat:@"+%.2f",[self.number floatValue]];
            break;
        case UserAssetsTypeTransferOut:
        case UserAssetsTypeSellOut:
        case UserAssetsTypeBTC:
        case UserAssetsTypePay:
        case UserAssetsTypeTX:
            title = [NSString stringWithFormat:@"-%.2f",[self.number floatValue]];
            break;
        default:
            break;
    }
    return title;
}
- (NSString*)getUserAssetsTypeName{
    NSString* title = @"";
    UserAssetsType type = [self getUserAssetsType];
    switch (type) {
        case UserAssetsTypeAll:
            title = @"";
            break;
        case UserAssetsTypeTransferIn:
            title = @"转入";
            break;
        case UserAssetsTypeTransferOut:
            title = @"转出";
            break;
        case UserAssetsTypeBuyIn:
            title = @"买入";
            break;
        case UserAssetsTypeSellOut:
            title = @"卖出";
            break;
        case UserAssetsTypeBTC:
            title = @"兑换比特币";
            break;
        case UserAssetsTypeRecharge:
            title = @"充值";
            break;
        case UserAssetsTypePay:
            title = @"代付";
            break;
        case UserAssetsTypeTX:
            title = @"提现";
            break;
        default:
            title = @"";
            break;
    }
    return title;
}

- (UserAssetsType)getUserAssetsType{
    UserAssetsType type = UserAssetsTypeAll;
    NSString* tag = self.resource ;
    if ([tag isEqualToString:kUserAssetsTypeAll])
    {
        type = UserAssetsTypeAll;
    }
    else if ([tag isEqualToString:kUserAssetsTypeTransferIn])
    {
        type = UserAssetsTypeTransferIn;
    }
    else if ([tag isEqualToString: kUserAssetsTypeTransferOut])
    {
        type = UserAssetsTypeTransferOut;
    }
    else if ([tag isEqualToString:kUserAssetsTypeBuyIn])
    {
        type = UserAssetsTypeBuyIn;
    }
    else if ([tag isEqualToString: kUserAssetsTypeSellOut])
    {
        type = UserAssetsTypeSellOut;
    }
    else if ([tag isEqualToString: kUserAssetsTypeBTC])
    {
        type = UserAssetsTypeBTC;
    }
    else if ([tag isEqualToString: kUserAssetsTypeRecharge])
    {
        type = UserAssetsTypeRecharge;
    }
    else if ([tag isEqualToString: kUserAssetsTypePay])
    {
        type = UserAssetsTypePay;
    }
    else if ([tag isEqualToString: kUserAssetsTypeTX])
    {
        type = UserAssetsTypeTX;
    }
    return type;
}
@end

@implementation AssetsModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"accountChange" : [AssetsData class]
             
             };
}
@end
