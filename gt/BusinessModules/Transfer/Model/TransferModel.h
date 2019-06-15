//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferModel : NSObject
@property (nonatomic, copy) NSString * errcode;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSString *poundage;
@property (nonatomic, strong) NSString * accountTransferId;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * number;
@property (nonatomic, strong) NSString * remark;
@property (nonatomic, strong) NSString * transferTime;
@property (nonatomic, strong) NSString * txhash;
@end
