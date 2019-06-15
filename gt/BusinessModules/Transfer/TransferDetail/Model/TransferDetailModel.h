//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TransferDetailModel : NSObject
@property (nonatomic, strong) NSString * errcode;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic, strong) NSString * orderNo;
@property (nonatomic, strong) NSString * orderAmount;
@property (nonatomic, strong) NSString * orderPrice;
@property (nonatomic, strong) NSString * orderNumber;
@property (nonatomic, strong) NSString * confirmTime;
@property (nonatomic, strong) NSString * finishTime;

@property (nonatomic, strong) NSString * txhash;
@property (nonatomic, strong) NSString * paymentNumber;

@end
