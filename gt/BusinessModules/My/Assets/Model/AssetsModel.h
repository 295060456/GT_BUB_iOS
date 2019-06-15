//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AssetsSubPageData : NSObject
@property (nonatomic, strong) NSString * pageno;
@property (nonatomic, strong) NSString * pagesize;
@property (nonatomic, strong) NSString * sum;
@end

@interface AssetsData : NSObject
@property (nonatomic, strong) NSString * resource;
@property (nonatomic, strong) NSString * createdTime;
@property (nonatomic, strong) NSString * number;
- (UIColor*)getUserAssetsNumColor;
- (NSString*)getUserAssetsNum;
- (NSString*)getUserAssetsTypeName;
- (UserAssetsType)getUserAssetsType;
@end

@interface AssetsModel : NSObject
@property (nonatomic, copy) NSString * errcode;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, strong) NSArray * accountChange;
@property (nonatomic, strong) AssetsSubPageData* page;
+(NSDictionary *)objectClassInArray;
@end
