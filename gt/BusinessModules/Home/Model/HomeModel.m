//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "HomeModel.h"
@implementation UserAssertModel

@end

@implementation HomeBannerData

@end
@implementation HomeData

@end



@implementation HomeModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"marketList" : [HomeData class],
             @"banner": [HomeBannerData class]
             };
}
@end

@implementation AccountPaymentWayModel

@end

@implementation AccountListModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"paymentWay" : @"AccountPaymentWayModel"
             };
}

@end

@implementation AccountPaymentWaySuperModel

- (void) maxDataArr:(NSArray *)maxDataArr  cardID:(NSString *) input type:(NSInteger)type{
    NSMutableArray*dataArrs = [NSMutableArray array];
    if (maxDataArr && maxDataArr.count>0) {
        NSMutableArray *ar1 = [NSMutableArray array];  // 支付
        NSMutableArray *ar2 = [NSMutableArray array]; // 微信
        NSMutableArray *ar3 = [NSMutableArray array];  // 银行
        NSArray *carIdAr = nil;
        if (input.length>0) { // 回填
            carIdAr =  [input componentsSeparatedByString:@","];
        }
        
        for (AccountPaymentWayModel *miniModel in maxDataArr) {
            NSInteger ty = [miniModel.paymentWay integerValue];
            if (ty == PaywayTypeWX) {
                [ar2 addObject:miniModel];
            }else if (ty == PaywayTypeZFB){
                [ar1 addObject:miniModel];
            }else if (ty == PaywayTypeCard){
                [ar3 addObject:miniModel];
            }
            if (carIdAr && carIdAr.count>0) { // 数据回填
                if (type == 1) { // 限额
                        if ([carIdAr containsObject:miniModel.paymentWayId]) {
                            [singLeton.chooseModelAr1 addObject:miniModel];
                        }
                }else if (type == 2) { // 固额
                        if ([carIdAr containsObject:miniModel.paymentWayId]) {
                            [singLeton.chooseModelAr2 addObject:miniModel];
                        }
                }
            }
        }
        
        if (ar1.count > 0) {
            [dataArrs addObject:@{@"title":@"支付宝",@"data" : ar1,@"iconImage":@"ZHIFUBAOXIRan",@"type":@"2",@"btnTitle":@"支付宝"}];
            AccountPaymentWayModel *model = ar1[0];
            if (singLeton.chooseModelAr1.count == 0) {
                [singLeton.chooseModelAr1 addObject:model];
            }
            if (singLeton.chooseModelAr2.count == 0) {
                [singLeton.chooseModelAr2 addObject:model];
            }
        }
        if (ar2.count>0) {
            [dataArrs addObject:@{@"title":@"微信账户",@"data" : ar2,@"iconImage":@"WEIXIXIRan",@"type":@"1",@"btnTitle":@"微信支付"}];
            //                                                         [self.paymentWayStyleArr addObject:@"2"];
            AccountPaymentWayModel *model = ar2[0];
            if (singLeton.chooseModelAr1.count == 0) {
                [singLeton.chooseModelAr1 addObject:model];
            }
            if (singLeton.chooseModelAr2.count == 0) {
                [singLeton.chooseModelAr2 addObject:model];
            }
            
        }
        if (ar3.count > 0) {
            [dataArrs addObject:@{@"title":@"银行卡账户",@"data" : ar3,@"iconImage":@"YINGHANGKAXIR",@"type":@"3",@"btnTitle":@"银行卡"}];
            //                                                         [self.paymentWayStyleArr addObject:@"3"];
            AccountPaymentWayModel *model = ar3[0];
            if (singLeton.chooseModelAr1.count == 0) {
                [singLeton.chooseModelAr1 addObject:model];
            }
            if (singLeton.chooseModelAr2.count == 0) {
                [singLeton.chooseModelAr2 addObject:model];
            }
        }
        self.maxDataArr = dataArrs;
    }
}

@end
