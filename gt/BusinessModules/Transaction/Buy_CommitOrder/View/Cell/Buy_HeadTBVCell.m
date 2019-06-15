//
//  Buy_HeadTBVCell.m
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_HeadTBVCell.h"
#import "BuyHeaderView.h"

#define lineColor RGBCOLOR(76, 127, 255)

@interface Buy_HeadTBVCell(){
    
}
@property(nonatomic,strong) BuyHeaderView *myView;
@property(nonatomic,strong)NSMutableArray *markLabMutArr;
@property(nonatomic,strong)NSMutableArray *markLabTitleMutArr;
@property(nonatomic,strong)NSMutableArray *progressBarLabLeft_MutArr;
@property(nonatomic,strong)NSMutableArray *progressBarLabRight_MutArr;

@property(nonatomic,strong)NSString *userType;
@property(nonatomic,assign)OrderType orderType;
@property(nonatomic,assign)Schedule schedule;

@end

@implementation Buy_HeadTBVCell

+(instancetype)cellWith:(UITableView *)tabelView
                   With:(NSDictionary*)dic{
    
    Buy_HeadTBVCell *cell = (Buy_HeadTBVCell *)[tabelView dequeueReusableCellWithIdentifier:@"Buy_HeadTBVCell"];
    
    if (!cell) {
        
        cell = [[Buy_HeadTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"Buy_HeadTBVCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *userType = dic[@"userType"];
        
        NSArray *ar = Nil;
        
        if ([userType isEqualToString:@"1"]) {
            
            ar = @[@"提交订单",@"向卖家转账",@"等待放行",@"交易完成"];
            
        }else if ([userType isEqualToString:@"2"]){
            
            ar = @[@"买家下单",@"买家付款",@"放行订单",@"交易完成"];
        }
        
        cell.myView = [[BuyHeaderView alloc] init];
        
        cell.orderType = [dic[@"orderType"] intValue];
        
        [cell.myView chooseItem:[cell setScheduleData] andTitelAR:ar];
        
        [cell.contentView addSubview:cell.myView];
    }
    
    return cell;
}

+(CGFloat)cellHeightWithModel:(NSDictionary *_Nullable)model{
    
    return 65 * SCALING_RATIO;
}

-(void)userType:(NSString *)userType{
    
    if (self.markLabTitleMutArr.count != 0) {
        
        [self.markLabTitleMutArr removeAllObjects];
    }else{
        
        if ([userType isEqualToString:@"1"]) {
            
            [self.markLabTitleMutArr addObject:@"提交订单"];
            [self.markLabTitleMutArr addObject:@"向卖家转账"];
            [self.markLabTitleMutArr addObject:@"等待放行"];
            [self.markLabTitleMutArr addObject:@"交易完成"];
            
        }else if ([userType isEqualToString:@"2"]){
            
            [self.markLabTitleMutArr addObject:@"买家下单"];
            [self.markLabTitleMutArr addObject:@"买家付款"];
            [self.markLabTitleMutArr addObject:@"放行订单"];
            [self.markLabTitleMutArr addObject:@"交易完成"];
        }
    }
}

-(NSInteger)setScheduleData{
    
    NSInteger i = 0;
    
    switch (self.orderType) {
            
        case BuyerOrderTypeAllPay://1
            
            i = Schedule_1st;
            
            break;
        case BuyerOrderTypeClosed://2
        case BuyerOrderTypeCancel://2
        case BuyerOrderTypeNotYetPay:
        case BuyerOrderTypeAppealing://2 3???
            
        case SellerOrderTypeNotYetPay://2
        case SellerOrderTypeTimeOut://2
        case SellerOrderTypeCancel://2
            
            i = Schedule_2nd;
            
            break;
        case BuyerOrderTypeHadPaidNotDistribute://3
        case BuyerOrderTypeHadPaidWaitDistribute://3
//        case BuyerOrderTypeAppealing://2 3????
        case SellerOrderTypeWaitDistribute:
        case SellerOrderTypeAppealing:
            
            i = Schedule_3rd;
            
            break;
        case BuyerOrderTypeFinished:
        case SellerOrderTypeFinished:
            
            i = Schedule_4th;
            
            break;
        default:
            break;
    }
    
    return i;
}

#pragma mark —— set
-(void)setOrderDetailModel:(OrderDetailModel *)orderDetailModel{
    
    _orderDetailModel = orderDetailModel;
}

#pragma mark —— lazyload
-(NSMutableArray *)markLabMutArr{
    
    if (!_markLabMutArr) {
        
        _markLabMutArr = [NSMutableArray array];
    }
    
    return _markLabMutArr;
}

-(NSMutableArray *)markLabTitleMutArr{
    
    if (!_markLabTitleMutArr) {
        
        _markLabTitleMutArr = [NSMutableArray array];

    }
    
    return _markLabTitleMutArr;
}

-(NSMutableArray *)progressBarLabLeft_MutArr{
    
    if (!_progressBarLabLeft_MutArr) {
        
        _progressBarLabLeft_MutArr = NSMutableArray.array;
    }
    
    return _progressBarLabLeft_MutArr;
}

-(NSMutableArray *)progressBarLabRight_MutArr{
    
    if (!_progressBarLabRight_MutArr) {
        
        _progressBarLabRight_MutArr = NSMutableArray.array;
    }
    
    return _progressBarLabRight_MutArr;
}




@end
