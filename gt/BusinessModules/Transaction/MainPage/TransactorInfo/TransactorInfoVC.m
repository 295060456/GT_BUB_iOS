//
//  TransactorInfoVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TransactorInfoVC.h"

#import "TransactorInfoVM.h"

@interface TransactorInfoVC ()

@property (nonatomic, strong) TransactorInfoVM *vm;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic,strong) TransactorInfoModel * model;
@end

@implementation TransactorInfoVC
- (void)postTransEvent{
//    WS(weakSelf);
    [self.vm network_postTransactorInfoWithPage:1 WithRequestParams:self.requestParams success:^(id data) {
        TransactorInfoModel * d = data;
        self.model = d;
        [self topViewInfo];
        [self bottomViewInfo];
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
    
}
- (TransactorInfoVM *)vm {
    if (!_vm) {
        _vm = [TransactorInfoVM new];
    }
    return _vm;
}
#pragma mark - life cycle
+ (instancetype)pushViewController:(UIViewController *)rootVC
                     requestParams:(id)requestParams
                           success:(DataBlock)block{
    
    TransactorInfoVC *vc = [[TransactorInfoVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:YES];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"商户信息";
    
    self.view.backgroundColor = HEXCOLOR(0xf6f5fa);
    [self postTransEvent];
}

- (void)topViewInfo
{
    UIView * top = [[UIView alloc]initWithFrame:CGRectMake(0,5, MAINSCREEN_WIDTH,223)];
    
    top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top];
    
    UIButton * nameLab = [[UIButton alloc]init];
    nameLab.titleLabel.numberOfLines = 1;
    NSString* userName =
    _model.merchantInfo.nickname!=nil?_model.merchantInfo.nickname:_model.merchantInfo.username!=nil?_model.merchantInfo.username:@"";
    [nameLab setTitle:userName forState:UIControlStateNormal] ;//[NSString getAnonymousString:userName] ;
    [nameLab setTitleColor:HEXCOLOR(0x040404) forState:UIControlStateNormal];
    [nameLab setImage:[UIImage imageNamed:[_model.merchantInfo getPriorityImageName]] forState:UIControlStateNormal];
    nameLab.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [top addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.top.mas_equalTo(top).mas_offset(13);
//        make.left.mas_equalTo(top).mas_offset(20);
        make.centerX.mas_equalTo(top);
    }];
    [nameLab layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:8];
    
//    UIView * line = [[UIView alloc]init];
//    [top addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(47);
//        make.height.mas_equalTo(2);
//    }];
//    line.layer.masksToBounds = YES;
//    line.layer.cornerRadius = .5;
//    line.backgroundColor = HEXCOLOR(0xe6e6e6);
    
    
    UILabel * message = [UILabel new];
    message.text = @"商户已缴保证金，平台担保交易";
    message.font = [UIFont systemFontOfSize:14.0];
    message.textColor = HEXCOLOR(0x999999);
    [top addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(20);
        make.centerX.mas_equalTo(top);
        make.top.mas_equalTo(nameLab.mas_bottom).offset(6);
        make.height.mas_equalTo(20);
    }];
    [self crateInfoViewTo:top];
}

- (void)crateInfoViewTo:(UIView *)parent
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor =HEXCOLOR(0xf6f5fa);
    [parent addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(89);
        make.height.mas_equalTo(95);
        make.right.mas_equalTo(-13);
    }];
    
    UIView * line = [[UIView alloc]init];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(37);
        make.height.mas_equalTo(1);
    }];
    line.layer.masksToBounds = YES;
    line.layer.cornerRadius = .5;
    line.backgroundColor = HEXCOLOR(0xe6e6e6);
    
    
    UILabel * count  =[[UILabel alloc]init];
    count.text  = @"交易次数";
    count.textAlignment = NSTextAlignmentCenter;
    [view addSubview:count];
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.left.mas_equalTo(20);
        make.height.mas_offset(21);
    }];
    
    UILabel * countNum  =[[UILabel alloc]init];
    countNum.text  = _model.merchantInfo.orderTotle;
    countNum.textAlignment = NSTextAlignmentCenter;
    [view addSubview:countNum];
    [countNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56);
        make.left.mas_equalTo(20);
        make.height.mas_offset(25);
        make.centerX.mas_equalTo(count.mas_centerX);
    }];
    
    UILabel * success  =[[UILabel alloc]init];
    success.text  = @"成功率";
    success.textAlignment = NSTextAlignmentCenter;
    [view addSubview:success];
    [success mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.height.mas_offset(21);
        make.centerX.mas_equalTo(parent.mas_centerX);
    }];
    
    UILabel * successNum  =[[UILabel alloc]init];
    successNum.text  = _model.merchantInfo.successRate;
    successNum.textAlignment = NSTextAlignmentCenter;
    [view addSubview:successNum];
    [successNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56);
        make.height.mas_offset(25);
        make.centerX.mas_equalTo(parent.mas_centerX);
    }];
    
    UILabel * time  =[[UILabel alloc]init];
    time.text  = @"平均放行时间";
    time.textAlignment = NSTextAlignmentCenter;
    [view addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.right.mas_equalTo(-20);
        make.height.mas_offset(21);
    }];
    
    UILabel * timeNum  =[[UILabel alloc]init];
    timeNum.text  =[NSString stringWithFormat:@"%@ 分钟",_model.merchantInfo.releaseTimeAverage];
    timeNum.textAlignment = NSTextAlignmentCenter;
    [view addSubview:timeNum];
    [timeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56);
        make.height.mas_offset(25);
        make.centerX.mas_equalTo(time.mas_centerX);
    }];
    
}

- (void)bottomViewInfo
{
    UIView * bottom = [[UIView alloc]initWithFrame:CGRectMake(0,223 + 5+5, MAINSCREEN_WIDTH,MAINSCREEN_HEIGHT - 223-10)];
    bottom.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottom];
    
    UILabel * checkInfo = [UILabel new];
    checkInfo.text = @"认证信息：";
    [bottom addSubview:checkInfo];
    [checkInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(18);
    }];
    
    NSArray* infoArr = @[];
    if ([_model.merchantInfo.isAuthentication intValue] == 1){
        infoArr = @[@{@"实名认证":@"cTransAction_id"},
                    @{@"高级认证":@"cTransAction_name"},
                    @{@"赔付担保":@"cTransAction_claim"}];
    }else{
        infoArr = @[@{@"实名认证":@"cTransAction_id"},
                    @{@"赔付担保":@"cTransAction_claim"}];
    }
    
    if (infoArr.count==3) {
        
    for (int i = 0; i<3; i++) {
        NSDictionary* dic = infoArr[i];
        UIImageView * leftImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:dic.allValues[0]]];
        [bottom addSubview:leftImage];
        
        UILabel * infoLab = [UILabel new];
        infoLab.text  = dic.allKeys[0];
        [bottom addSubview:infoLab];
        
        UIImageView * rightImage = [[UIImageView alloc]init];
        if (i == 0) {
            if ([_model.merchantInfo.isSellerIdNumber intValue] == 3) {
                rightImage.image = [UIImage imageNamed:@"icon_check"];
            }else{
                rightImage.image = [UIImage imageNamed:@"icon_uncheck"];
            }
        }
        else if (i == 1)
        {
            if ([_model.merchantInfo.isAuthentication intValue] == 1) {
                rightImage.image = [UIImage imageNamed:@"icon_check"];
            }else{
                rightImage.image = [UIImage imageNamed:@"icon_uncheck"];
            }
        }
        else{
            if ([_model.merchantInfo.isGuarantee intValue] == 1) {
                rightImage.image = [UIImage imageNamed:@"icon_check"];
            }else{
                rightImage.image = [UIImage imageNamed:@"icon_uncheck"];
            }
        }
        [bottom addSubview:rightImage];
        
        float topY = (46 + i * 41);
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(26);
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(topY);
        }];
        
        [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.centerY.mas_equalTo(leftImage.mas_centerY);
            make.left.mas_equalTo(leftImage.mas_right).mas_offset(6);
        }];
        
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(20);
            make.centerY.mas_equalTo(leftImage.mas_centerY);
            make.right.mas_equalTo(-24);
        }];
    }
    
        
    }else{
        
        for (int i = 0; i<2; i++) {
            NSDictionary* dic = infoArr[i];
            UIImageView * leftImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:dic.allValues[0]]];
            [bottom addSubview:leftImage];
            
            UILabel * infoLab = [UILabel new];
            infoLab.text  = dic.allKeys[0];
            [bottom addSubview:infoLab];
            
            UIImageView * rightImage = [[UIImageView alloc]init];
            if (i == 0) {
                if ([_model.merchantInfo.isSellerIdNumber intValue] == 3) {
                    rightImage.image = [UIImage imageNamed:@"icon_check"];
                }else{
                    rightImage.image = [UIImage imageNamed:@"icon_uncheck"];
                }
            }
            
            else{
                if ([_model.merchantInfo.isGuarantee intValue] == 1) {
                    rightImage.image = [UIImage imageNamed:@"icon_check"];
                }else{
                    rightImage.image = [UIImage imageNamed:@"icon_uncheck"];
                }
            }
            [bottom addSubview:rightImage];
            
            float topY = (46 + i * 41);
            [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(26);
                make.left.mas_equalTo(18);
                make.top.mas_equalTo(topY);
            }];
            
            [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(20);
                make.centerY.mas_equalTo(leftImage.mas_centerY);
                make.left.mas_equalTo(leftImage.mas_right).mas_offset(6);
            }];
            
            [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.mas_equalTo(20);
                make.centerY.mas_equalTo(leftImage.mas_centerY);
                make.right.mas_equalTo(-24);
            }];
            
        }
        
        
    }
    
}
@end
