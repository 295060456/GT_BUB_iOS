//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModifyAdsModel.h"
@interface PageModel : NSObject
@property (nonatomic, copy) NSString * errcode;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSArray * merchantAdvert;

@end
