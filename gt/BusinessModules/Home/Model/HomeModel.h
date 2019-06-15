//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserAssertModel : NSObject

@property (nonatomic, copy) NSString * errcode;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSString * usableFund;
@property (nonatomic, copy) NSString * frozenFund;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * convertRmb;
@end

@interface HomeBannerData : NSObject
@property (nonatomic, copy) NSString * bannerId;
@property (nonatomic, copy) NSString * sort;
@property (nonatomic, copy) NSString * clickUrl;
@property (nonatomic, copy) NSString * imageUrl;
@end

@interface HomeData : NSObject
@property (nonatomic, copy) NSString * tradeId;
@property (nonatomic, copy) NSString * coinId;
@property (nonatomic, copy) NSString *coinImageUrl;
@property (nonatomic, copy) NSString * rmbPrice;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * upAndDown;
@property (nonatomic, copy) NSString * sort;
@end

@interface HomeModel : NSObject
@property (nonatomic, copy) NSString * errcode;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSArray * marketList;
@property (nonatomic, copy) NSArray *banner;
+(NSDictionary *)objectClassInArray;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * optionPrice;

@end

@interface AccountPaymentWayModel: NSObject

@property(nonatomic,copy) NSString *paymentWayId;//付款方式ID
@property(nonatomic,copy) NSString *paymentWay;//1、微信; 2、支付宝 ;3、银行卡
@property(nonatomic,copy) NSString *name;//收款人
@property(nonatomic,copy) NSString *account;//收款账号
@property(nonatomic,copy) NSString *QRCode;//收款二维码
@property(nonatomic,copy) NSString *accountOpenBank;//开户银行
@property(nonatomic,copy) NSString *accountOpenBranch;//开户支行
@property(nonatomic,copy) NSString *accountBankCard;//银行账号kk
@property(nonatomic,copy) NSString *status;//收款方式状态
@property(nonatomic,copy) NSString *remark;//备注
@property(nonatomic,copy) NSString *onedaylimit;//单日限额
@property(nonatomic,copy) NSString *limitstatus;//单日限额状态 : 0没满、1满了
//@property(nonatomic,assign) BOOL isSelected;
@end

@interface AccountListModel: NSObject

@property(nonatomic,copy) NSString *errcode;//返回码: 1、成功；2、失败
@property(nonatomic,copy) NSString *    msg;//返回信息
@property(nonatomic,strong) NSMutableArray *paymentWay;

@end

@interface AccountPaymentWaySuperModel: NSObject

@property (nonatomic, strong) NSMutableArray *maxDataArr;

- (void) maxDataArr:(NSArray *)maxDataArr  cardID:(NSString *) input type:(NSInteger)type;
@end
