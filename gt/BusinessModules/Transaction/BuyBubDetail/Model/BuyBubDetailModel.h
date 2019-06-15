//
//  BuyBubDetailModel.h
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString * const  _Nonnull LXBuy = @"联系买家";
static NSString * const  _Nonnull LXSell = @"联系卖家";
static NSString * const  _Nonnull ToAppeal = @"我要申诉";
static NSString * const  _Nonnull CancleOrder = @"取消订单";
static NSString * const  _Nonnull MeRedPay = @"我已付款";
static NSString * const  _Nonnull SellRelease = @"确认已收款，放行";
static NSString * const  _Nonnull SeeMyaSsets = @"查看我的资产";
static NSString * const  _Nonnull ToConsumption = @"现在去消费";
static NSString * const  _Nonnull CloseAppeal = @"取消申诉";



typedef NS_ENUM(NSUInteger,BuyBubDetailType){
    BuyBubDetail_Base = 0 , // 最基本 进度， 大标题 订单cell 
    BuyBubDetail_BuyTime  , // 买家买币有限制时间  没有富矿的信息 底部有付款二维码
    BuyBubDetail_BuyTimeAndBankInfor,   // 买家买币有限制时间且有付款账号信息
    BuyBubdetail_Text, // 两列文本纯文字类型 有时间
    BuyBubdetail_BulText, // 一列蓝色字样式
    BuyBubdetail_TimeText, // 有倒计时 下面还有一行文字
    BuyBubdetail_SellFinish, // 卖家完成 就两行 La
};

NS_ASSUME_NONNULL_BEGIN

@interface BuyBubDetailModel : NSObject

-(instancetype)initWithDic:(NSDictionary*)dic appealScheduleType:(NSInteger)ty;

// 基本数据类型
@property(nonatomic, strong) NSString *orderNo; // 订单id 
@property(nonatomic, assign) UserType userTpye; // 我在该订单中的角色
@property(nonatomic, strong) NSString *sellUserId;
@property(nonatomic, strong) NSString *sellerName; // 订单id
@property(nonatomic, strong) NSString *buyUserId; // 订单id
@property(nonatomic, strong) NSString *buyerName; // 订单id
@property(nonatomic, strong) NSString *orderStatus; // 订单状态
@property(nonatomic, assign) NSInteger scheduleType; // 订单进度
@property(nonatomic, strong) NSString *appealStatus; // 订单状态  // 仅用于申诉
@property(nonatomic, strong) NSString *appealID; //  // 仅用于申诉ID

//  只有标题 没有图片 没有小标题  58    只有标题 有图片 80   三个有(加小标题) // 112
@property(nonatomic, assign) float noeCellHi ; // 第一个cell 高度
@property(nonatomic, strong) NSString *titleString; // cell 的标题
@property(nonatomic, strong) NSString *titleImage;  // 标题对应的图标
@property(nonatomic, strong) NSString *detailString; // 小标题

@property(nonatomic, strong) NSArray  *twoCellArr;   // 第二个cell 数据

@property(nonatomic ,assign) BuyBubDetailType buyType; // 布局 类型
// 是否有 倒计时cell  BuyBubDetail_BuyTime 和
@property(nonatomic ,strong) NSString *myTime; // 必有 s 为单位

// 银行卡信息数据 、、在 BuyBubDetail_BuyTimeAndBankInfor 才有
//@property(nonatomic ,strong) NSString *timeS; // 必有
@property(nonatomic ,strong) NSArray *bankCarInfor;

// 底部fooder 数据
//  显示二维码 fooder  buyType == BuyBubDetail_BuyTime 时候
@property (nonatomic ,strong) NSString *payCardString;
@property (nonatomic ,strong) NSString *payCodeS;
@property (nonatomic ,strong) NSString *payQrUrls;

//   buyType == BuyBubdetail_Text 两列文本类型
//@property(nonatomic ,strong) NSString *timeS; // 必有 

//   buyType == BuyBubdetail_BulText, // 一列蓝色字样式
@property (nonatomic ,strong) NSString *fooderString;

//  buyType == BuyBubdetail_TimeText, // 有倒计时 下面还有一行文字
//@property(nonatomic ,strong) NSString *timeS;
//@property (nonatomic ,strong) NSString *fooderString; // 必有

// 最底部按钮文案
@property(nonatomic ,strong) NSArray *buttomBtnArr;

//BuyBubdetail_SellFinish 卖家完成的
@property(nonatomic ,strong) NSDictionary *sellFinishDic;

@end

NS_ASSUME_NONNULL_END
