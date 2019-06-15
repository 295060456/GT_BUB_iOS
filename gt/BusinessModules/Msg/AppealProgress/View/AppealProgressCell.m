//
//  AppealProgressCell.m
//  gt
//
//  Created by 鱼饼 on 2019/4/27.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AppealProgressCell.h"
#import "AppealProgressModel.h"

@interface AppealProgressCell ()
@property (nonatomic, strong) UILabel *orderIDLable;
@property (nonatomic ,strong) UILabel *orderMoneyLable;
@property (nonatomic, strong) UILabel *muberLable;
@property (nonatomic, strong) UILabel *orderCreaTimeLable;
@property (nonatomic, strong) UILabel *appealTimeLable;
@property (nonatomic, strong) UILabel *reasonLable;
@property (nonatomic, strong) UILabel *appealTypeLable;
@end

@implementation AppealProgressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIView *linV = [[UIView alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 0, MAINSCREEN_WIDTH-30*SCALING_RATIO, 1)];
        linV.backgroundColor = kTableViewBackgroundColor;
        [self.contentView addSubview:linV];
        
        UILabel *order = [[UILabel alloc] init];
        [self.contentView addSubview:order];
        order.font = [UIFont systemFontOfSize:13];
        order.textColor =  HEXCOLOR(0x9a9a9a);
        order.text = @"订单号";
        [order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(self.contentView.mas_top).offset(11);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(15);
        }];
        
        UIButton *copyBu = [self creatButtonWithTitle:nil setTitleColor:nil setImage:kIMG(@"copy_blue_rightup") backgroundColor:nil cornerRadius:0 borderWidth:0 borderColor:nil action:@selector(copyAction)];
        [self.contentView addSubview:copyBu];
//        copyBu.backgroundColor = kRedColor;
        [copyBu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(11);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.width.mas_equalTo(13);
            make.height.mas_equalTo(15);
        }];
        
        self.orderIDLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.orderIDLable];
        self.orderIDLable.font = [UIFont systemFontOfSize:13];
        self.orderIDLable.textColor =  HEXCOLOR(0x333333);
//        self.orderIDLable.backgroundColor = kRedColor;
        self.orderIDLable.textAlignment = NSTextAlignmentRight;
        [self.orderIDLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(11);
            make.left.equalTo(order.mas_right).with.offset(3);
            make.right.mas_equalTo(copyBu.mas_left).offset(-8);
            make.height.mas_equalTo(15);
        }];
        
        
        UILabel *orderMoney = [[UILabel alloc] init];
        [self.contentView addSubview:orderMoney];
        orderMoney.font = [UIFont systemFontOfSize:13];
        orderMoney.textColor =  HEXCOLOR(0x9a9a9a);
        orderMoney.text = @"订单金额";
        [orderMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(order.mas_bottom).offset(15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(15);
        }];
        
        
        self.orderMoneyLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.orderMoneyLable];
        self.orderMoneyLable.font = [UIFont systemFontOfSize:13];
        self.orderMoneyLable.textColor =  HEXCOLOR(0x333333);
//        self.orderMoneyLable.backgroundColor = kRedColor;
        self.orderMoneyLable.textAlignment = NSTextAlignmentRight;
        [self.orderMoneyLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(orderMoney);
            make.left.equalTo(orderMoney.mas_right).with.offset(3);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(15);
        }];
        
        
        
        UILabel *muberLable = [[UILabel alloc] init];
        [self.contentView addSubview:muberLable];
        muberLable.font = [UIFont systemFontOfSize:13];
        muberLable.textColor =  HEXCOLOR(0x9a9a9a);
        muberLable.text = @"数量";
        [muberLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(orderMoney.mas_bottom).offset(15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(15);
        }];
        
        
        self.muberLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.muberLable];
        self.muberLable.font = [UIFont systemFontOfSize:13];
        self.muberLable.textColor =  HEXCOLOR(0x333333);
//        self.muberLable.backgroundColor = kRedColor;
        self.muberLable.textAlignment = NSTextAlignmentRight;
        [self.muberLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(muberLable);
            make.left.equalTo(muberLable.mas_right).with.offset(3);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(15);
        }];
        
        
        UILabel *orderCreaTimeLable = [[UILabel alloc] init];
        [self.contentView addSubview:orderCreaTimeLable];
        orderCreaTimeLable.font = [UIFont systemFontOfSize:13];
        orderCreaTimeLable.textColor =  HEXCOLOR(0x9a9a9a);
        orderCreaTimeLable.text = @"订单时间";
        [orderCreaTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(muberLable.mas_bottom).offset(15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(15);
        }];
        
        
        self.orderCreaTimeLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.orderCreaTimeLable];
        self.orderCreaTimeLable.font = [UIFont systemFontOfSize:13];
        self.orderCreaTimeLable.textColor =  HEXCOLOR(0x333333);
//        self.orderCreaTimeLable.backgroundColor = kRedColor;
         self.orderCreaTimeLable.textAlignment = NSTextAlignmentRight;
        [self.orderCreaTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(orderCreaTimeLable);
            make.left.equalTo(orderCreaTimeLable.mas_right).with.offset(3);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(15);
        }];
        
        UILabel *appealTimeLable = [[UILabel alloc] init];
        [self.contentView addSubview:appealTimeLable];
        appealTimeLable.font = [UIFont systemFontOfSize:13];
        appealTimeLable.textColor =  HEXCOLOR(0x9a9a9a);
        appealTimeLable.text = @"申诉时间";
        [appealTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(orderCreaTimeLable.mas_bottom).offset(15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(15);
        }];
        
        
        self.appealTimeLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.appealTimeLable];
        self.appealTimeLable.font = [UIFont systemFontOfSize:13];
        self.appealTimeLable.textColor =  HEXCOLOR(0x333333);
//        self.appealTimeLable.backgroundColor = kRedColor;
        self.appealTimeLable.textAlignment = NSTextAlignmentRight;
        [self.appealTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(appealTimeLable);
            make.left.equalTo(appealTimeLable.mas_right).with.offset(3);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(15);
        }];
        
        
        UILabel *reasonTimeLable = [[UILabel alloc] init];
        [self.contentView addSubview:reasonTimeLable];
        reasonTimeLable.font = [UIFont systemFontOfSize:13];
        reasonTimeLable.textColor =  HEXCOLOR(0x9a9a9a);
        reasonTimeLable.text = @"申诉理由";
        [reasonTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(appealTimeLable.mas_bottom).offset(15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(15);
        }];


        self.reasonLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.reasonLable];
        self.reasonLable.font = [UIFont systemFontOfSize:13];
        self.reasonLable.textColor =  HEXCOLOR(0x333333);
//        self.reasonTimeLable.backgroundColor = kRedColor;
         self.reasonLable.textAlignment = NSTextAlignmentRight;
        [self.reasonLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(reasonTimeLable);
            make.left.equalTo(reasonTimeLable.mas_right).with.offset(3);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(15);
        }];



        UILabel *appealTypeLable = [[UILabel alloc] init];
        [self.contentView addSubview:appealTypeLable];
        appealTypeLable.font = [UIFont systemFontOfSize:13];
        appealTypeLable.textColor =  HEXCOLOR(0x9a9a9a);
        appealTypeLable.text = @"处理状态";
        [appealTypeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(reasonTimeLable.mas_bottom).offset(15);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(15);
        }];


        self.appealTypeLable = [[UILabel alloc] init];
        [self.contentView addSubview:self.appealTypeLable];
        self.appealTypeLable.font = [UIFont systemFontOfSize:13];
        self.appealTypeLable.textColor =  HEXCOLOR(0x333333);
//        self.appealTypeLable.backgroundColor = kRedColor;
         self.appealTypeLable.textAlignment = NSTextAlignmentRight;
        [self.appealTypeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(appealTypeLable);
            make.left.equalTo(appealTypeLable.mas_right).with.offset(3);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}
-(void)realData:(id)data{
    AppealProgressModel *mo = data;
    NSString *orderS = mo.orderId;
    if (orderS && orderS.length > 1) {}else{
        orderS = mo.orderNo;
    }
    self.orderIDLable.text = [NSString stringWithFormat:@"%@",orderS];
    self.orderMoneyLable.text = [NSString stringWithFormat:@"%@",mo.orderAmount];
    self.muberLable.text = [NSString stringWithFormat:@"%@",mo.number];
    self.orderCreaTimeLable.text = [NSString stringWithFormat:@"%@",mo.createdTime];
    NSString *appealCreatTime = mo.appeal[@"createdTime"];
    self.appealTimeLable.text = [NSString stringWithFormat:@"%@",appealCreatTime];
    self.reasonLable.text = [NSString stringWithFormat:@"%@",mo.appealReason];
    self.appealTypeLable.text = [NSString stringWithFormat:@"%@",mo.appealType];
}

-(void)copyAction{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.orderIDLable.text;
        if (pasteboard.string.length > 0) {
            [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        }
}

@end
