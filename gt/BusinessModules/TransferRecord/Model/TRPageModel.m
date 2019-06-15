//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "TRPageModel.h"

@implementation TRSubPageData

@end

@implementation TRPageData
- (UIColor*)getTransferRecordNumColor{
    UIColor* color = kBlackColor;
    TransferRecordType type = [self getTransferRecordStatus];
    switch (type) {
        case TransferRecordTypeIn:
            color = HEXCOLOR(0x006151);
            break;
        case TransferRecordTypeOut:
            color = HEXCOLOR(0xd02a2a);
            break;
        default:
            color = HEXCOLOR(0xd02a2a);
            break;
    }
    return color;
}
- (NSString*)getTransferRecordNum{
    NSString* title = @"";
    TransferRecordType type = [self getTransferRecordStatus];
    switch (type) {
        case TransferRecordTypeIn:
            title = [NSString stringWithFormat:@"+%.2f",[self.number floatValue]];
            break;
        case TransferRecordTypeOut:
            title = [NSString stringWithFormat:@"-%.2f",[self.number floatValue]];
            break;
        default:
            title = [NSString stringWithFormat:@"-%.2f",[self.number floatValue]];
            break;
    }
    return title;
}
- (NSString*)getTransferRecordImage{
    NSString* title = @"";
    TransferRecordType type = [self getTransferRecordStatus];
    switch (type) {
        case TransferRecordTypeIn:
            title = @"iconIncome";
            break;
        case TransferRecordTypeOut:
            title = @"iconOutcome";
            break;
        default:
            title = @"iconOutcome";
            break;
    }
    return title;
}
- (NSString*)getTransferRecordAdress{
    NSString* title = @"";
    TransferRecordType type = [self getTransferRecordStatus];
    switch (type) {
        case TransferRecordTypeIn:
            title = self.fromAddress;
            break;
        case TransferRecordTypeOut:
            title = self.toAddress;
            break;
        default:
            title = self.toAddress;
            break;
    }
    return title;
}
- (TransferRecordType)getTransferRecordStatus{
    TransferRecordType type =TransferRecordTypeAll;
    NSInteger tag = [self.type integerValue];
    if (tag  == 0)
    {
        type = TransferRecordTypeAll;
    }
    else if (tag  == 1)
    {
        type = TransferRecordTypeIn;
    }
    else if (tag == 2)
    {
        type = TransferRecordTypeOut;
    }
    
    return type;
}
@end

@implementation TRPageModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"transferRecord" : [TRPageData class]
             };
}
@end
