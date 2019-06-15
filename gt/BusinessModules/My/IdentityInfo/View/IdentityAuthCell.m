//
//  SPCell.m
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "IdentityAuthCell.h"
#import "TransactionModel.h"
@interface IdentityAuthCell ()
@property(nonatomic,strong)UIView* bgView;

@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) UIImageView *decorIv;

@property (nonatomic, strong) UILabel *adIdLab;
@property (nonatomic, strong) UIImageView *userNameIm;
@property (nonatomic, strong) UIImageView *userNameBtn1;
@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, strong) UILabel *typeLab;

@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UILabel *saledLab;

@property (nonatomic, strong) UIImageView *line2;

@property (nonatomic, strong) UILabel *distributeTimeLab;
@property (nonatomic, strong) UILabel *modifyTimeLab;

@property (nonatomic, strong) UILabel *statusLab;

@property (nonatomic, strong) UIView *payMethodView;
@property (nonatomic, strong) UILabel *payMethodLab;
@property (nonatomic, strong) UIImageView* zIV;
@property (nonatomic, strong) UIImageView* wIV;
@property (nonatomic, strong) UIImageView* cIV;
@property (nonatomic, strong) NSMutableArray* payIvs;
@property (nonatomic, strong) NSMutableArray* statusBtns;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) id modle;

@end

@implementation IdentityAuthCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self richEles];
    }
    return self;
}


- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.contentView.backgroundColor = kWhiteColor;
    self.backgroundView = [[UIView alloc] init];
    
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = kWhiteColor;
    _bgView.layer.shadowColor = kGrayColor.CGColor;
    _bgView.layer.shadowOffset = CGSizeMake(0,3);
    _bgView.layer.shadowOpacity = 0.1;
    _bgView.layer.shadowRadius = 6;
    
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(30);
        make.trailing.equalTo(self.contentView).offset(-30);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-0);
    }];
    _decorIv = [[UIImageView alloc] init];
    [_bgView addSubview:_decorIv];
    //    _decorIv.backgroundColor = kRedColor;
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15);
        make.top.equalTo(self.bgView).offset(24);
        make.height.width.equalTo(@24);
    }];
    
    
    _adIdLab = [[UILabel alloc]init];
    [self.bgView addSubview:_adIdLab];
    //    _adIdLab.backgroundColor = kRedColor;
    [_adIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(54);
        make.top.equalTo(self.bgView).offset(21);
        make.height.height.equalTo(@15);
    }];
    
    _userNameIm = [UIImageView new];
    [self.bgView addSubview:_userNameIm];
    _userNameIm.image = kIMG(@"QuRanZXiran");
//    _userNameBtn.layer.masksToBounds = YES;
//    _userNameBtn.layer.cornerRadius = 14;
//    _userNameBtn.backgroundColor = HEXCOLOR(0x4c7fff);
//    _userNameBtn.text = @"去认证 >";
//    _userNameBtn.textAlignment = NSTextAlignmentCenter;
//    _userNameBtn.textColor = kWhiteColor;
//    [_userNameBtn setTitle:@"去认证 >" forState:UIControlStateNormal];
//     [_userNameBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
//    [_userNameBtn setTitleColor:kWhiteColor forState:(UIControlStateNormal)];
    [_userNameIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.centerY.equalTo(self.adIdLab).offset(7);
        make.height.equalTo(@32);
        make.width.equalTo(@74);
    }];
    
    _userNameBtn1 = [UIImageView new];
    [self.bgView addSubview:_userNameBtn1];
    [_userNameBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.centerY.equalTo(self.adIdLab);
        make.height.equalTo(@24);
        make.width.equalTo(@74);
    }];
    
    _typeLab = [[UILabel alloc]init];
    [self.bgView addSubview:_typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adIdLab);
        make.top.equalTo(self.adIdLab.mas_bottom).offset(8);
        make.height.equalTo(@13);
        //        make.width.equalTo(@190);
    }];
    
    UIView *lin = [[UIView alloc] init];
    [self.bgView addSubview:lin];
    lin.backgroundColor = HEXCOLOR(0xeeeeee);
    [lin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.typeLab.mas_bottom).offset(19);
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.height.equalTo(@1);
        //        make.width.equalTo(@190);
    }];
    
    
    _saledLab = [[UILabel alloc]init];
    [self.bgView addSubview:_saledLab];
    _saledLab.textColor = HEXCOLOR(0x9a9a9a);
    _saledLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [_saledLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.decorIv);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
        make.height.equalTo(@13);
    }];
    
}

- (void)clickItem:(UIButton*)button{
    if (self.block) {
        self.block(_modle);
    }
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _adIdLab.textAlignment = NSTextAlignmentCenter;
    _adIdLab.font = [UIFont boldSystemFontOfSize:15];
    _adIdLab.textColor = HEXCOLOR(0x333333);

//    _userNameBtn.font = kFontSize(12);
//    [_userNameBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _typeLab.textAlignment = NSTextAlignmentLeft;
    _typeLab.textColor = HEXCOLOR(0x8c8c8c);
    _saledLab.textAlignment = NSTextAlignmentLeft;
    
}


+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"IdentityAuthCell";
    IdentityAuthCell *cell = (IdentityAuthCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[IdentityAuthCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 138;
}

- (void)richElementsInCellWithModel:(id)data andModel:(LoginModel*)dataModel{
    NSLog(@"-- %@   %@",data,dataModel);
    NSDictionary* model = data;
    _typeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    if ([model[kIndexSection] intValue]== IndexSectionZero) { // 实名
        _decorIv.hidden = YES;
        IdentityAuthType type = [model[kType] intValue];
        if (type  == IdentityAuthTypeNone) { // 未认证
            _adIdLab.text = model[kTip];
            _typeLab.text = model[kSubTip];
            _decorIv.image = kIMG(@"SenfenZXiRIcon");
            _decorIv.hidden = NO;
            _userNameBtn1.hidden = YES;
            _userNameIm.hidden = NO;
            _adIdLab.textAlignment = NSTextAlignmentCenter;
            [_adIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView).offset(54);
                make.top.equalTo(self.bgView).offset(21);
                make.height.height.equalTo(@15);
            }];
            
            _typeLab.text = model[kSubTip];
            _typeLab.textAlignment = NSTextAlignmentLeft;
            _typeLab.font = kFontSize(12);
            [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.adIdLab);
                make.top.equalTo(self.adIdLab.mas_bottom).offset(8);
                make.height.equalTo(@13);
                //        make.width.equalTo(@190);
            }];
        }else { // 通过审核 // 和审核中
            _decorIv.hidden = YES;
            _userNameIm.hidden = YES;
            _userNameBtn1.hidden = NO;
            
            _adIdLab.textAlignment = NSTextAlignmentLeft;
            [_adIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15);
                make.top.equalTo(self.bgView).offset(21);
                make.height.equalTo(@15);
            }];
            [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.adIdLab);
                make.top.equalTo(self.adIdLab.mas_bottom).offset(8);
                make.height.equalTo(@13);
            }];
            _adIdLab.text = dataModel.userinfo.realname;
            _typeLab.text = dataModel.userinfo.idnumber;
            if (type  == IdentityAuthTypeHandling) { // 审核中 barHSZxiRan
                 _userNameBtn1.image = kIMG(@"barHSZxiRan");
            }else if(type  == IdentityAuthTypeFinished){ // 审核完成
                 _userNameBtn1.image = kIMG(@"barOKXiran");
            }else{ // 失败
                _userNameBtn1.image = kIMG(@"iran");
            }
            _typeLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        }
    }else{  // 高级
        SeniorAuthType type = [model[kType] intValue];
        _adIdLab.text = model[kTip];
        _typeLab.text = model[kSubTip];
        if (type == SeniorAuthTypeUndone) { // 未认证
            _userNameIm.hidden = NO;
            _userNameBtn1.hidden = YES;
            _decorIv.hidden = NO;
            _decorIv.image = kIMG(@"GaoJiIconXi");
            _adIdLab.textAlignment = NSTextAlignmentCenter;
            [_adIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView).offset(54);
                make.top.equalTo(self.bgView).offset(21);
                make.height.height.equalTo(@15);
            }];
            
            _typeLab.text = model[kSubTip];
            _typeLab.textAlignment = NSTextAlignmentLeft;
            [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.adIdLab);
                make.top.equalTo(self.adIdLab.mas_bottom).offset(8);
                make.height.equalTo(@13);
                //        make.width.equalTo(@190);
            }];
        }else{ // 已认证
            _decorIv.hidden = YES;
            _userNameIm.hidden = YES;
            _userNameBtn1.hidden = NO;
            _userNameBtn1.image = kIMG(@"barOKXiran");
            _adIdLab.textAlignment = NSTextAlignmentLeft;
            [_adIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15);
                make.top.equalTo(self.bgView).offset(21);
                make.height.height.equalTo(@15);
            }];
            [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.adIdLab);
                make.top.equalTo(self.adIdLab.mas_bottom).offset(8);
                make.height.equalTo(@13);
            }];
        }
    }
    NSString* st = (NSString*)model[kData];
    _saledLab.text = st;
}

@end
