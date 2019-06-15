//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import "TransactorInfoModel.h"
@implementation TransactorInfoData
- (NSString*) getPriorityImageName{
    NSString * titleTxt = @"";
    if (![self.isSellerIdNumber isEqualToString:@"3"]){
        titleTxt = @"";
    }else{
        if ([self.isSellerSeniorAuth isEqualToString:@"1"]) {
            titleTxt = @"isSeniorAuth_icon";
        }else if (![self.isSellerSeniorAuth isEqualToString:@"1"]) {
            titleTxt = @"isRealNameAuth_icon";
        }
    }
    return titleTxt;
}

@end

@implementation TransactorInfoModel

@end
