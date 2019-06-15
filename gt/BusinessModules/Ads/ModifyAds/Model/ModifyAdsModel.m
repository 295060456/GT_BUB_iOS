//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import "ModifyAdsModel.h"

#define kOccurAdsTypeTypeAll @"0"
#define kOccurAdsTypeTypeOnline @"1"
#define kOccurAdsTypeTypeOutline @"2"
#define kOccurAdsTypeTypeSellOut @"3"


@implementation ModifyAdsModel
- (NSString *) getOccurAdsTypeName
{
    NSString* title = @"";
    OccurAdsType useType = [self getOccurAdsType];
    
    switch (useType) {
        case OccurAdsTypeTypeOnline:
            title = @"上架中";
            self.statusLabColor = RGBCOLOR(57, 67, 104);
            break;
        case OccurAdsTypeTypeSellOut:
            title = @"售罄";
            self.statusLabColor = RGBCOLOR(140, 150, 165);
            break;
        case OccurAdsTypeTypeOutline:
            title = @"已下架";
            self.statusLabColor = RGBCOLOR(140, 150, 165);
            break;
        default:
            break;
    }
    
    return title;
}

- (OccurAdsType) getOccurAdsType
{
    OccurAdsType type = OccurAdsTypeTypeAll;
    NSString *tag = self.status;
    if ([tag isEqualToString:kOccurAdsTypeTypeAll])
    {
        type = OccurAdsTypeTypeAll;
    }
    else if ([tag isEqualToString:kOccurAdsTypeTypeOnline]){
        type = OccurAdsTypeTypeOnline;
    }
    else if ([tag isEqualToString:kOccurAdsTypeTypeSellOut]){
        type = OccurAdsTypeTypeSellOut;
    }
    else if ([tag isEqualToString:kOccurAdsTypeTypeOutline]){
        type = OccurAdsTypeTypeOutline;
    }
    
    return type;
}

- (void) setLimitMinAmount:(NSString *)limitMinAmount{
    if (HandleStringIsNull(limitMinAmount)) _limitMinAmount = [NSString stringWithFormat:@"%d",limitMinAmount.intValue];
}

- (void) setLimitMaxAmount:(NSString *)limitMaxAmount{
    if (HandleStringIsNull(limitMaxAmount)) _limitMaxAmount = [NSString stringWithFormat:@"%d",limitMaxAmount.intValue];
}

- (void) setNumber:(NSString *)number{
    if (HandleStringIsNull(number)) _number = [NSString stringWithFormat:@"%d",number.intValue];
}

- (void) setPrompt:(NSString *)prompt{
    if (HandleStringIsNull(prompt)) _prompt = [NSString stringWithFormat:@"%d",prompt.intValue];
}

- (void) setFixedAmount:(NSString *)fixedAmount{
    if (HandleStringIsNull(fixedAmount)) _fixedAmount = [NSString stringWithFormat:@"%d",fixedAmount.intValue];
}

- (void) setBalance:(NSString *)balance{
    if (HandleStringIsNull(balance)) _balance = [NSString stringWithFormat:@"%d",balance.intValue];
}

- (void) setVolume:(NSString *)volume{
    if (HandleStringIsNull(volume)) _volume = [NSString stringWithFormat:@"%d",volume.intValue];
}

- (void) setUsableFund:(NSString *)usableFund{
    if (HandleStringIsNull(usableFund)) _usableFund = [NSString stringWithFormat:@"%d",usableFund.intValue];
}

- (void) setModifyTime:(NSString *)modifyTime{
    if (HandleStringIsNull(modifyTime)) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
//        NSDate *birthdayDate = [dateFormatter dateFromString:modifyTime];
//         NSString *strDate = [dateFormatter stringFromDate:birthdayDate];
//        _modifyTime = strDate;
//
//        //时间字符串
//        NSString *str = modifyTime;//@"20150806070733";
//        //规定时间格式
//        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"yyyyMMddHHmmss"];
//        //设置时区  全球标准时间CUT 必须设置 我们要设置中国的时区
//        NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"CUT"];
//                            [formatter setTimeZone:zone];
//        //变回日期格式
//        NSDate *stringDate = [formatter dateFromString:str];
//        NSLog(@"stringDate = %@",stringDate);
    
        _modifyTime = [modifyTime substringToIndex:modifyTime.length-3];
    }
}

- (void) setCreatedtime:(NSString *)createdtime{
    if (HandleStringIsNull(createdtime)) {
        _createdtime = [createdtime substringToIndex:createdtime.length-3];
    }
}
@end
