//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRSubPageData : NSObject
@property (nonatomic, strong) NSString * pageno;
@property (nonatomic, strong) NSString * pagesize;
@property (nonatomic, strong) NSString * sum;
@end

@interface TRPageData : NSObject
@property (nonatomic, copy) NSString*  msg;
@property (nonatomic, copy) NSString*  type;
@property (nonatomic, copy) NSString*  fromAddress;
@property (nonatomic, copy) NSString*  toAddress;

@property (nonatomic, copy) NSString*  transferRecordId;
@property (nonatomic, copy) NSString*  transferTime;
@property (nonatomic, copy) NSString* txhash;
@property (nonatomic, copy) NSString*  number;
@property (nonatomic, copy) NSString*  remark;

@property (nonatomic, copy) NSString*  poundage;
@property (nonatomic, copy) NSString*  actualNumber;
- (UIColor*)getTransferRecordNumColor;
- (NSString*)getTransferRecordNum;
- (NSString*)getTransferRecordImage;
- (NSString*)getTransferRecordAdress;
- (TransferRecordType)getTransferRecordStatus;
@end



@interface TRPageModel : NSObject
@property (nonatomic, strong) TRSubPageData* page;
@property (nonatomic, copy) NSString*  msg;
@property (nonatomic, copy) NSString*  errcode;
@property (nonatomic, strong) NSArray * transferRecord;
+(NSDictionary *)objectClassInArray;
@end
