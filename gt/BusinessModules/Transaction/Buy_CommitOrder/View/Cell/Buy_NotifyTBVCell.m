//
//  Buy_NotifyTBVCell.m
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_NotifyTBVCell.h"

@interface Buy_NotifyTBVCell(){
    
    NSMutableArray *notifyLabMutArr;
}

@property(nonatomic,strong)NSMutableArray *notifyMutArr;
@property(nonatomic,copy)ActionBlock block;

@end

@implementation Buy_NotifyTBVCell

+(instancetype)cellWith:(UITableView *)tabelView{
    
    Buy_NotifyTBVCell *cell = (Buy_NotifyTBVCell *)[tabelView dequeueReusableCellWithIdentifier:@"Buy_NotifyTBVCell"];
    
    if (!cell) {
        
        cell = [[Buy_NotifyTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:@"Buy_NotifyTBVCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

+(CGFloat)cellHeightWithModel:(NSDictionary *_Nullable)model{
    
    return 290 * SCALING_RATIO;
}

- (void)actionBlock:(ActionBlock)block{
    
    self.block = block;
}

- (void)richElementsInCellWithModel:(id _Nullable)dataDic{
    
    [self initView];
}

-(void)initView{
    
    //购买流程 标题
    UILabel *titleLab = UILabel.new;
    
    titleLab.text = @"购买流程";
    
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                    size:15];
    
    titleLab.textColor = RGBCOLOR(51, 51, 51);
    
    [self.contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(10);
        
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    //分割线
    UILabel *segmentationLab = UILabel.new;
    
    segmentationLab.backgroundColor = RGBCOLOR(240, 241, 243);
    
    [self.contentView addSubview:segmentationLab];
    
    [segmentationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        
        make.left.equalTo(titleLab);
        
        make.right.equalTo(self.contentView).offset(-10);
        
        make.height.mas_equalTo(@1);
    }];
    
    if (!notifyLabMutArr) {
        
        notifyLabMutArr = NSMutableArray.array;
    }
    
    //Notify:
    for (int u = 0; u < self.notifyMutArr.count; u++) {

        //内容
        UILabel *notifyLab = UILabel.new;
        
        [notifyLabMutArr addObject:notifyLab];
        
        notifyLab.text = self.notifyMutArr[u];
        
        notifyLab.numberOfLines = 0;
        
        notifyLab.textColor = RGBCOLOR(51, 51, 51);
        
        notifyLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];

        [self.contentView addSubview:notifyLab];

        [notifyLab mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(segmentationLab);
            
            make.right.equalTo(segmentationLab.mas_right);
            
            make.top.equalTo(segmentationLab.mas_bottom).offset(7 + (36 + 12) * u);
        }];
        
        //前面的数字
        UILabel *numLab = UILabel.new;
        numLab.font = kFontSize(13);
        numLab.textAlignment = NSTextAlignmentCenter;
        
         numLab.backgroundColor = [UIColor colorWithRed:0.30 green:0.50 blue:1.00 alpha:1.00];
        numLab.text = [NSString stringWithFormat:@"%d",u + 1];
        
        numLab.textColor = kWhiteColor;
        
        [notifyLab addSubview:numLab];
        
        [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(segmentationLab);
            
            make.size.mas_equalTo(CGSizeMake(18, 18));
            
            make.top.equalTo(notifyLab);
        }];
        [numLab layoutIfNeeded];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:numLab.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        numLab.frame = numLab.bounds;
        maskLayer.path = maskPath.CGPath;
        numLab.layer.mask = maskLayer;
    }
    
    //提交按钮
    UIButton *submitBtn = UIButton.new;
    
    [submitBtn setBackgroundColor:RGBCOLOR(76, 127, 255)];
    
    [NSObject cornerCutToCircleWithView:submitBtn
                        AndCornerRadius:6];
    
    [submitBtn setTitle:@"提交订单"
               forState:UIControlStateNormal];
    
    [submitBtn addTarget:self action:@selector(submitBtnClickEvent:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:submitBtn];
    
    UILabel *lab = (UILabel *)[notifyLabMutArr lastObject];

    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView);
        
        make.top.equalTo(lab.mas_bottom).offset(68);
        
        make.size.mas_equalTo(CGSizeMake(315 * MAINSCREEN_WIDTH / 375 , 40 * MAINSCREEN_WIDTH / 375));
    }];
}

-(NSMutableArray *)notifyMutArr{
    
    if (!_notifyMutArr) {
        
        _notifyMutArr = NSMutableArray.array;
        
        [_notifyMutArr addObject:@"      提交订单、填写购买金额，选择对应的支付方式(微信、支付宝或银行卡)"];
        
        [_notifyMutArr addObject:@"     向商家提供的收款账号上，转账对应的金额"];
        
        [_notifyMutArr addObject:@"     商家收到转账后，确定放行，对应数量的BUB会划转到买方的账户上"];
    }
    
    return _notifyMutArr;
}

#pragma mark - "提交订单"按钮点击事件
-(void)submitBtnClickEvent:(UIButton *)sender{
    
    NSLog(@"提交订单");
    
    self.block(@"");
}


@end
