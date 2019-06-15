//
//  BuyBubDetailModel.m
//  gt
//
//  Created by 鱼饼 on 2019/5/30.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BuyBubDetailModel.h"

@implementation BuyBubDetailModel
-(instancetype)initWithDic:(NSDictionary*)dic appealScheduleType:(NSInteger)ty{
    self = [super init];
    if (self) {
        
        self.scheduleType = 1;
        self.buyType = BuyBubDetail_Base;
        self.orderNo = [NSString stringWithFormat:@"%@",dic[@"orderNo"]];
        NSMutableArray *twAr = [NSMutableArray array]; // 基本数据类型‘
        [twAr addObject:@{@"订单号":dic[@"orderNo"]}];
        NSString *orderType = dic[@"status"];
        self.orderStatus =  orderType;
        self.sellUserId = dic[@"sellUserId"];
        self.sellerName = dic[@"sellerName"];
        self.buyUserId  = dic[@"buyUserId"];
        self.buyerName  = dic[@"buyerName"];
        
        LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
        NSString *userId = userInfoModel.userid ? userInfoModel.userid : userInfoModel.userinfo.userid;
        if ([userId isEqualToString:self.sellUserId]) { // 自己就是卖家
            self.userTpye = UserTypeSeller;
            singLeton.myType = UserTypeSeller;
        }else{
            self.userTpye = UserTypeBuyer;
            singLeton.myType = UserTypeBuyer;
        }
        
        if ([orderType isEqualToString:@"1"]) { // 订单没有付款
            
            [self orderNoPaymentWith:dic andMar:twAr andBuyType:self.userTpye];

        }else if ([orderType isEqualToString:@"2"]){ // 订单已经付款 未放行
            
            [self orderPaymentNotReleaseWith:dic andMar:twAr andBuyType:self.userTpye];
            
        }else if ([orderType isEqualToString:@"3"]){ // 订单已经完成
           
            [self orderCompleteWith:dic andMar:twAr andBuyType:self.userTpye];
            
        }else if ([orderType isEqualToString:@"4"]){ // 订单取消
            
            [self orderCancelWith:dic andMar:twAr andBuyType:self.userTpye];
            
        }else if ([orderType isEqualToString:@"5"]){ // 系统关闭订单
            
            [self orderSystemShutdownWith:dic andMar:twAr andBuyType:self.userTpye];
            
        }else if ([orderType isEqualToString:@"6"]){ // 订单在申诉中
            
            [self orderAppealWith:dic andMar:twAr andBuyType:self.userTpye appealScheduleType:ty];
        }
        self.payCodeS = dic[@"paymentNumber"]; // 付款号
        self.twoCellArr = twAr;
        
    } return self;
}


-(void)orderAppealWith:(NSDictionary*)dic andMar:(NSMutableArray*)twAr andBuyType:(UserType)myType appealScheduleType:(NSInteger)ty{ // 订单在申诉中
    self.scheduleType = ty>0? ty : 3;
    self.titleImage = @"iconAppeal";// 时间图标
    self.noeCellHi = 112*SCALING_RATIO;
    self.titleString = @"申诉中";
    self.detailString  = @"申诉结果将会在7个工作日反馈给您";
    NSDictionary *appealDic = dic[@"appeal"];
    NSString *type = appealDic[@"type"];
    [twAr addObject:@{@"订单金额":[NSString stringWithFormat:@"￥%.2f",[dic[@"orderAmount"] floatValue]]}];
    [twAr addObject:@{@"数量":[NSString stringWithFormat:@"%.0f BUB",[dic[@"number"] floatValue]]}];
    [twAr addObject:@{@"订单时间":dic[@"createdTime"]}];
    [twAr addObject:@{@"申诉时间":appealDic[@"createdTime"]}];
    NSString *reason = [self appealReasonWithSrting:appealDic[@"reason"]];
     [twAr addObject:@{@"申诉理由":reason}];
     [twAr addObject:@{@"处理状态":@"平台介入"}];
    if ([type isEqualToString:@"1"] && myType == UserTypeBuyer) { //我发起的申诉 买家发起的申请
        self.buttomBtnArr = @[LXSell,CloseAppeal];
        // 有可能是第二 或第三
    }else{ // 卖家发起的申诉
        self.buttomBtnArr = @[LXBuy,CloseAppeal];
    }
    self.appealID = appealDic[@"id"];
}


-(void)orderSystemShutdownWith:(NSDictionary*)dic andMar:(NSMutableArray*)twAr andBuyType:(UserType)myType{ // 系统关闭订单
    self.scheduleType = 2;
    self.titleImage = @"iconClosed";// XX 图标
    self.noeCellHi = 80*SCALING_RATIO;
    if ( myType == UserTypeBuyer) {
        self.buyType = BuyBubDetail_Base;
        self.titleString = @"付款已超时";
        self.buttomBtnArr = @[LXSell,ToAppeal];
    }else{
        self.buyType = BuyBubdetail_BulText;
        self.titleString = @"订单已超时"; // 卖家 显示 订单已超时 下面有一行蓝色小字
        self.fooderString = @"对方未在15 分钟内支付，订单已关闭";
        self.buttomBtnArr = @[LXBuy,ToAppeal];
    }
    [twAr addObject:@{@"订单金额":[NSString stringWithFormat:@"￥%.2f",[dic[@"orderAmount"] floatValue]]}];
    [twAr addObject:@{@"数量":[NSString stringWithFormat:@"%.0f BUB",[dic[@"number"] floatValue]]}];
    [twAr addObject:@{@"订单时间":dic[@"createdTime"]}];
}

-(void)orderCancelWith:(NSDictionary*)dic andMar:(NSMutableArray*)twAr andBuyType:(UserType)myType{ // 订单取消
    self.scheduleType = 2;
    self.titleImage = @"iconConceled";// -- 图标
    self.noeCellHi = 80*SCALING_RATIO;
    if ( myType == UserTypeBuyer) {
        self.buttomBtnArr = @[LXSell];
        self.titleString = @"已取消";
    }else{
        self.buttomBtnArr = @[LXBuy];
        self.titleString = @"买方已取消";
    }
    [twAr addObject:@{@"订单金额":[NSString stringWithFormat:@"￥%.2f",[dic[@"orderAmount"] floatValue]]}];
    [twAr addObject:@{@"数量":[NSString stringWithFormat:@"%.0f BUB",[dic[@"number"] floatValue]]}];
    [twAr addObject:@{@"订单时间":dic[@"createdTime"]}];
}

-(void)orderCompleteWith:(NSDictionary*)dic andMar:(NSMutableArray*)twAr andBuyType:(UserType)myType{ // 订单已经完成
     NSDictionary *payDic = dic[@"paymentWay"]; // 付款相关数据
    self.scheduleType = 4;
    self.noeCellHi = 80*SCALING_RATIO;
    self.titleImage = @"iconSuccXiRanU";
    self.titleString = @"已完成";
    [twAr addObject:@{@"订单金额":[NSString stringWithFormat:@"￥%.2f",[dic[@"orderAmount"] floatValue]]}];
    [twAr addObject:@{@"数量":[NSString stringWithFormat:@"%.0f BUB",[dic[@"number"] floatValue]]}];
    [twAr addObject:@{@"订单时间":dic[@"createdTime"]}];
    NSString *s = [self payTypeWith:payDic[@"paymentWay"]];
    [twAr addObject:@{@"支付方式":s}];
    if ( myType == UserTypeBuyer) {
        [twAr addObject:@{@"付款参考号":dic[@"paymentNumber"]}];
        self.buttomBtnArr = @[LXSell,SeeMyaSsets,ToConsumption];
    }else{
        self.buyType = BuyBubdetail_SellFinish;
        [twAr addObject:@{@"真实姓名":payDic[@"paymentWay"]}];
        self.buttomBtnArr = @[LXBuy];
        self.sellFinishDic = @{
//                               @"交易号:":@"测试x测试0ui4rg4",
//                               @"区  块:":@"测试开发测试234567890876",
                               };
    }
}

-(void)orderPaymentNotReleaseWith:(NSDictionary*)dic andMar:(NSMutableArray*)twAr andBuyType:(UserType)myType{ // 订单已经付款 未放行
     NSDictionary *payDic = dic[@"paymentWay"]; // 付款相关数据
    self.scheduleType = 3;
    self.titleImage = @"iconSuccXiRanU";
    [twAr addObject:@{@"订单金额":[NSString stringWithFormat:@"￥%.2f",[dic[@"orderAmount"] floatValue]]}];
    [twAr addObject:@{@"数量":[NSString stringWithFormat:@"%.0f BUB",[dic[@"number"] floatValue]]}];
    [twAr addObject:@{@"订单时间":dic[@"createdTime"]}];
    NSString *s = [self payTypeWith:payDic[@"paymentWay"]];
    [twAr addObject:@{@"支付方式":s}];
    if ( myType == UserTypeBuyer) { // 买家
        self.buyType = BuyBubdetail_Text;
        self.noeCellHi = 80*SCALING_RATIO;
        self.titleString = @"已付款, 等待对方放行";
        self.buttomBtnArr = @[LXSell,CancleOrder,ToAppeal];
    }else{
        self.buyType = BuyBubdetail_TimeText;
        self.noeCellHi = 112*SCALING_RATIO;
        self.titleString = @"对方已确认付款";
        self.detailString = [NSString stringWithFormat:@"对方(%@)将通过 %@ 付款,请务必确认收到款项后再放行",dic[@"buyerName"],s];
        [twAr addObject:@{@"真实姓名":payDic[@"paymentWay"]}];
        self.fooderString = @"如确定收到款项，请在倒计时结束前放行，以避免不必要的申诉纠纷。";
        self.buttomBtnArr = @[LXBuy,ToAppeal,SellRelease];
    }
    NSString *time = dic[@"restTime"];
    self.myTime = time;
}


-(void)orderNoPaymentWith:(NSDictionary*)dic andMar:(NSMutableArray*)twAr andBuyType:(UserType)myType{ // 订单没有付款
    NSDictionary *payDic = dic[@"paymentWay"]; // 付款相关数据
    NSString *qrS = payDic[@"QRCode"];
    NSString *time = dic[@"restTime"];
    if ([time integerValue] < 0.1) { // 已超时
        self.scheduleType = 2;
        self.titleImage = @"iconClosed";// XX 图标
        self.noeCellHi = 80*SCALING_RATIO;
        if ( myType == UserTypeBuyer) {
            self.buyType = BuyBubDetail_Base;
            self.titleString = @"付款已超时";
            self.buttomBtnArr = @[LXSell,ToAppeal];
        }else{
            self.buyType = BuyBubdetail_BulText;
            self.titleString = @"订单已超时"; // 卖家 显示 订单已超时 下面有一行蓝色小字
            self.fooderString = @"对方未在15 分钟内支付，订单已关闭";
            self.buttomBtnArr = @[LXBuy,ToAppeal];
        }
        [twAr addObject:@{@"订单金额":[NSString stringWithFormat:@"￥%.2f",[dic[@"orderAmount"] floatValue]]}];
        [twAr addObject:@{@"数量":[NSString stringWithFormat:@"%.0f BUB",[dic[@"number"] floatValue]]}];
        [twAr addObject:@{@"订单时间":dic[@"createdTime"]}];
    } else{ // 未超时
        if ( myType == UserTypeBuyer) { // 买家已下单但还没没付款  显示二维码的界面
            NSString *paymentWay = payDic[@"paymentWay"];
            if ([paymentWay isEqualToString:@"3"]) { // 银行卡
                self.buyType = BuyBubDetail_BuyTimeAndBankInfor;
                //                    payDic
                self.bankCarInfor = @[
                                      @{@"付款参考号":dic[@"paymentNumber"]},
                                      @{@"收款人":payDic[@"name"]},
                                      @{@"开户银行":payDic[@"accountOpenBank"]},
                                      @{@"支行信息":payDic[@"accountOpenBranch"]},
                                      @{@"银行卡号":payDic[@"accountBankCard"]},
                                      ];
            }else{
                self.buyType = BuyBubDetail_BuyTime;
                if ([paymentWay isEqualToString:@"1"]) {
                    self.payCardString = @"微信";
                }else if ([paymentWay isEqualToString:@"2"]){
                    self.payCardString = @"支付宝";
                }
            }
            self.noeCellHi = 58*SCALING_RATIO;
            self.titleString = [NSString stringWithFormat:@"您正在向 %@ 购买%@个BUB",payDic[@"name"],dic[@"number"]];
            [twAr addObject:@{@"单价":[NSString stringWithFormat:@"￥%@",dic[@"price"]]}];
            [twAr addObject:@{@"总价":[NSString stringWithFormat:@"%@CNY(人民币)",dic[@"orderAmount"]]}];
            self.buttomBtnArr = @[LXSell,CancleOrder,MeRedPay];
            
        }else{ // 对应的卖家 应该是  等待对方付款 有大倒计时
            self.buyType = BuyBubdetail_TimeText;
            self.noeCellHi = 112*SCALING_RATIO;
            self.titleImage = @"iconAppeal"; // 时间图标
            self.titleString = @"等待对方付款";
            self.payCardString = [self payTypeWith:payDic[@"paymentWay"]];
            self.detailString = [NSString stringWithFormat:@"对方(%@)将通过 %@ 付款",dic[@"buyerName"],self.payCardString];
            [twAr addObject:@{@"订单金额":[NSString stringWithFormat:@"￥%.0f",[dic[@"orderAmount"] floatValue]]}];
            [twAr addObject:@{@"数量":[NSString stringWithFormat:@"%.0f BUB",[dic[@"number"] floatValue]]}];
            [twAr addObject:@{@"订单时间":dic[@"createdTime"]}];
            self.fooderString = @"15分钟对方未付款，订单已关闭";
            self.buttomBtnArr = @[@"LXBuy"];
        }
        self.myTime = time;
        self.scheduleType = 2;
    }
    self.myTime = @"0";
    if (HandleStringIsNull(time)) {
        self.myTime = time;
    }
    self.payQrUrls = qrS;
}

-(NSString*)payTypeWith:(NSString*)type{
    NSString *s;
    if ([type isEqualToString:@"1"]) {
        s = @"微信";
    }else if ([type isEqualToString:@"2"]){
        s = @"支付宝";
    }else{
        s = @"银行卡";
    }
    return s;
}

-(NSString*)appealReasonWithSrting:(NSString*)string{
    NSString *typeS = @"";
    if ([string isEqualToString:@"0_B_1_5"]) {
        typeS = @"其他原因";
    }else if ([string isEqualToString:@"1_B_1_5"]){
        typeS = @"卖家提供错误付款信息";
    }else if ([string isEqualToString:@"2_B_1_5"]){
        typeS = @"已付款，但未在时间内点击确认付款";
    }else if ([string isEqualToString:@"0_B_1_2"]){
        typeS = @"";
    }else if ([string isEqualToString:@"1_B_1_2"]){
        typeS = @"付款后卖方不放行BUB";
    }else if ([string isEqualToString:@"0_S_1_2"]){
        typeS = @"其他原因";
    }else if ([string isEqualToString:@"1_S_1_2"]){
        typeS = @"买方未付款却标记已付款";
    }
    return typeS;
}
@end
