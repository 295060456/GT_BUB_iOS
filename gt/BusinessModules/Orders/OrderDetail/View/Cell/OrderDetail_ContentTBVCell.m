//
//  OrderDetail_StyleOne_ContentTBVCell.m
//  gt
//
//  Created by Administrator on 08/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "OrderDetail_ContentTBVCell.h"

#import "OrderDetailModel.h"

@interface OrderDetail_ContentTBVCell (){
    
    UIButton *titleBtn;
    
    UILabel *tipsLab;
}

@property(nonatomic,strong)NSString *paymentWay;

@property(nonatomic,strong)OrderDetailModel *orderDetailModel;

@property(nonatomic,assign)OrderType orderType;

@property(nonatomic,strong)NSMutableArray *titleMutArr;

@property(nonatomic,strong)NSMutableArray *titleValueMutArr;

@end

@implementation OrderDetail_ContentTBVCell

+(instancetype)cellWith:(UITableView *)tabelView{
    
    OrderDetail_ContentTBVCell *cell = (OrderDetail_ContentTBVCell *)[tabelView dequeueReusableCellWithIdentifier:@"OrderDetail_ContentTBVCell"];
    
    if (!cell) {
        
        cell = [[OrderDetail_ContentTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"OrderDetail_ContentTBVCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

+(CGFloat)cellHeightWithModel:(NSDictionary *_Nullable)model{
    
    return 10;//??
}

- (void)richElementsInCellWithModel:(id _Nullable)dataDic{
    
    self.orderDetailModel = dataDic[@"orderDetailModel"];
    
    [self data:self.orderDetailModel];
    
    [self initView];
}

-(void)data:(OrderDetailModel *)orderDetailModel{
    
    self.orderType = [orderDetailModel getTransactionOrderType];
    
    //订单号、订单金额、数量、订单时间、支付方式、真实姓名
    
    //订单号、订单金额、数量、订单时间、申诉时间、申诉理由、处理状态
    if (self.titleMutArr.count != 0) {
        
        [self.titleMutArr removeAllObjects];
    }
    
    if (self.titleValueMutArr != 0) {
        
        [self.titleValueMutArr removeAllObjects];
    }

    switch (self.orderType) {
            
        case BuyerOrderTypeHadPaidWaitDistribute:{
            
            [self EEE];
        }
            break;
//        case BuyerOrderTypeClosed://买方_订单关闭
        case SellerOrderTypeAppealing:{//卖家_申诉
            
            [self BBB];
        }
            break;
        case SellerOrderTypeFinished://卖家已完成
        case BuyerOrderTypeHadPaidNotDistribute://买方_订单已经支付不放行
        case SellerOrderTypeWaitDistribute:{//卖家_买家已付款等待放行
            
            [self AAA];
        }
            break;
            
        case BuyerOrderTypeFinished:{//买方_订单结束
            
            [self CCC];
        }
            break;
            
        case BuyerOrderTypeCancel://买方_订单取消
        case BuyerOrderTypeClosed:{//买方_订单关闭 (付款已超时 / 已取消)(向卖家转账)  已超时 // 已超时页面
            
            [self DDD];
        }
            break;
        default:
            break;
    }
}

-(void)EEE{
    
    [self.titleMutArr addObject:@"订单号"];
    
    [self.titleMutArr addObject:@"订单金额"];
    
    [self.titleMutArr addObject:@"单价"];
    
    [self.titleMutArr addObject:@"数量"];
    
    [self.titleMutArr addObject:@"订单时间"];
    
    [self.titleValueMutArr addObject:self.orderDetailModel.orderNo];//订单号
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@CNY",self.orderDetailModel.orderAmount]];//订单金额
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@CNY",self.orderDetailModel.price]];//单价
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@BUB",self.orderDetailModel.number]];//数量
    
    [self.titleValueMutArr addObject:self.orderDetailModel.createdTime];//订单时间
}

-(void)DDD{
    
    [self.titleMutArr addObject:@"订单号"];
    
    [self.titleMutArr addObject:@"订单金额"];
    
    [self.titleMutArr addObject:@"数量"];
    
    [self.titleMutArr addObject:@"订单时间"];
    
    [self.titleValueMutArr addObject:self.orderDetailModel.orderNo];//订单号
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@CNY",self.orderDetailModel.orderAmount]];//订单金额
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@BUB",self.orderDetailModel.number]];//数量
    
    [self.titleValueMutArr addObject:self.orderDetailModel.createdTime];//订单时间
}

-(void)CCC{
    
    [self.titleMutArr addObject:@"订单号"];
    
    [self.titleMutArr addObject:@"订单金额"];
    
    [self.titleMutArr addObject:@"数量"];
    
    [self.titleMutArr addObject:@"订单时间"];
    
    [self.titleMutArr addObject:@"支付方式"];
    
    [self.titleMutArr addObject:@"付款参考号"];
    
    [self.titleValueMutArr addObject:self.orderDetailModel.orderNo];//订单号
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@CNY",self.orderDetailModel.orderAmount]];//订单金额
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@BUB",self.orderDetailModel.number]];//数量
    
    [self.titleValueMutArr addObject:self.orderDetailModel.createdTime];//订单时间
    
    //支付方式
    if ([self.orderDetailModel.paymentWay.paymentWay isEqualToString:@"1"]) {
        
        [self.titleValueMutArr addObject:@"微信"];
    }else if ([self.orderDetailModel.paymentWay.paymentWay isEqualToString:@"2"]) {
        
        [self.titleValueMutArr addObject:@"支付宝"];
    }else if ([self.orderDetailModel.paymentWay.paymentWay isEqualToString:@"3"]) {
        
        [self.titleValueMutArr addObject:@"银行卡"];
    }
    
    [self.titleValueMutArr addObject:self.orderDetailModel.paymentNumber];//付款参考号
}

-(void)AAA{
    
    [self.titleMutArr addObject:@"订单号"];
    
    [self.titleMutArr addObject:@"订单金额"];
    
    [self.titleMutArr addObject:@"数量"];
    
    [self.titleMutArr addObject:@"订单时间"];
    
    [self.titleMutArr addObject:@"支付方式"];
    
    [self.titleMutArr addObject:@"真实姓名"];
    
    [self.titleValueMutArr addObject:self.orderDetailModel.orderNo];//订单号
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@CNY",self.orderDetailModel.orderAmount]];//订单金额
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@BUB",self.orderDetailModel.number]];//数量
    
    [self.titleValueMutArr addObject:self.orderDetailModel.createdTime];//订单时间
    
    //支付方式
    if ([self.orderDetailModel.paymentWay.paymentWay isEqualToString:@"1"]) {
        
        [self.titleValueMutArr addObject:@"微信"];
    }else if ([self.orderDetailModel.paymentWay.paymentWay isEqualToString:@"2"]) {
        
        [self.titleValueMutArr addObject:@"支付宝"];
    }else if ([self.orderDetailModel.paymentWay.paymentWay isEqualToString:@"3"]) {
        
        [self.titleValueMutArr addObject:@"银行卡"];
    }

    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@",self.orderDetailModel.buyerName]];//真实姓名 
}

-(void)BBB{
    
    [self.titleMutArr addObject:@"订单号"];
    
    [self.titleMutArr addObject:@"订单金额"];
    
    [self.titleMutArr addObject:@"数量"];
    
    [self.titleMutArr addObject:@"订单时间"];
    
    [self.titleMutArr addObject:@"申诉时间"];
    
    [self.titleMutArr addObject:@"申诉理由"];
    
    [self.titleMutArr addObject:@"处理状态"];
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@",self.orderDetailModel.orderNo]];//订单号
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@",self.orderDetailModel.orderAmount]];//订单金额
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@",self.orderDetailModel.number]];//数量
    
    [self.titleValueMutArr addObject:[NSString stringWithFormat:@"%@",self.orderDetailModel.createdTime]];//订单时间
    
    [self.titleValueMutArr addObject:@"申诉时间"];//申诉时间
    
    [self.titleValueMutArr addObject:@"申诉理由"];//申诉理由
    
    [self.titleValueMutArr addObject:@"处理状态"];//处理状态
}

-(void)initView{
    
    //按钮正好左图右字
    titleBtn = UIButton.new;
    
    titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                               size:24];
    
    [titleBtn setTitleColor:RGBCOLOR(51, 51, 51)
                   forState:UIControlStateNormal];
    
    [titleBtn setTitle:[self.orderDetailModel getTransactionOrderTypeTitle]
              forState:UIControlStateNormal];
    
    [titleBtn setImage:kIMG([self.orderDetailModel getTransactionOrderTypeImageName])
              forState:UIControlStateNormal];
    
    [self.contentView addSubview:titleBtn];
    
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(20);
        
        make.left.equalTo(self.contentView);
        
        make.right.equalTo(self.contentView);
    }];
    
    //某些情况下会出现的
    switch (self.orderType) {///////////////////////
        
        case BuyerOrderTypeAppealing:
        case SellerOrderTypeNotYetPay:
        case SellerOrderTypeWaitDistribute:
        case SellerOrderTypeAppealing:{
            
            tipsLab = UILabel.new;
            
//            tipsLab.text = @"temp";
            
            [self.contentView addSubview:tipsLab];
            
            [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.equalTo(self->titleBtn);
                
                make.top.equalTo(self->titleBtn.mas_bottom);
                
                make.height.mas_equalTo(@20);
            }];
        }
            break;
        default:
            break;
    }
    
    UILabel *line = UILabel.new;
    
    line.backgroundColor = RGBCOLOR(240, 241, 243);
    
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(15);
        
        make.right.equalTo(self.contentView).offset(-15);
        
        self->tipsLab?make.top.equalTo(self->tipsLab.mas_bottom).offset(20):make.top.equalTo(self->titleBtn.mas_bottom).offset(20);
        
        make.height.mas_equalTo(@1);
    }];
    
    for (int s = 0; s < self.titleMutArr.count; s++) {
        
        UILabel *menuTitleLab = UILabel.new;
        
        menuTitleLab.text = self.titleMutArr[s];
        
        menuTitleLab.textColor = RGBCOLOR(154, 154, 154);
        
        menuTitleLab.font = kFontSize(13);
        
        [self.contentView addSubview:menuTitleLab];
        
        [menuTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(line);
            
            make.size.mas_equalTo(CGSizeMake(39, 13));
            
            make.top.equalTo(line.mas_bottom).offset(12 + (13 + 15) * s);
        }];
        
        UILabel *menuTitleValueLab = UILabel.new;
        
        menuTitleValueLab.text = self.titleValueMutArr[s];
        
//        [self.titleValueMutArr addObject:menuTitleValueLab];
        
        menuTitleValueLab.textColor = RGBCOLOR(51, 51, 51);
        
        menuTitleValueLab.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                                 size:13];
        
        [self.contentView addSubview:menuTitleValueLab];
        
        switch (s) {
            case 0:{
                
                UIButton *copyBtn = UIButton.new;
                
                [copyBtn setBackgroundImage:kIMG(@"copy_blue_rightup")
                                   forState:UIControlStateNormal];
                
                [copyBtn addTarget:self
                            action:@selector(copyBtnClick)
                  forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView addSubview:copyBtn];
                
                [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.bottom.equalTo(menuTitleLab);
                    
                    make.right.equalTo(self.contentView).offset(-15);
                    
                    make.size.mas_equalTo(CGSizeMake(13, 15));
                }];
                
                [menuTitleValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(copyBtn.mas_left).offset(-4);
                    
                    make.top.bottom.equalTo(menuTitleLab);
                }];
            }
                break;
                
            default:{
                
                [menuTitleValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(self.contentView).offset(-15);
                    
                    make.top.bottom.equalTo(menuTitleLab);
                }];
            }
                break;
        }
    }
}

#pragma mark —— 复制到剪贴板
-(void)copyBtnClick{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.titleValueMutArr[0];
    
    if (pasteboard.string.length > 0) {
        
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }
}

#pragma mark —— lazyLoad

-(NSMutableArray *)titleMutArr{
    
    if (!_titleMutArr) {
        
        _titleMutArr = NSMutableArray.array;
    }
    
    return _titleMutArr;
}

-(NSMutableArray *)titleValueMutArr{
    
    if (!_titleValueMutArr) {
        
        _titleValueMutArr = NSMutableArray.array;
    }
    
    return _titleValueMutArr;
}

@end
