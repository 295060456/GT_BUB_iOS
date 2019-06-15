//
//  TransferVC.m
//  OTC
//
//  Created by mac30389 on 2018/11/29.
//  Copyright © 2018 yang peng. All rights reserved.
//

#import "TransferVC.h"
#import "InputPWPopUpView.h"
#import "TransferVM.h"
#import "TransferDetailVC.h"
@interface TransferVC ()<UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong) UITextView * addFiled;
@property(nonatomic,strong) UILabel * countLab;

@property(nonatomic,strong) UITextField * numberFiled;
@property(nonatomic,strong) UITextView * remarkTv;
@property(nonatomic,strong) UIView * transline;

@property(nonatomic,strong) UILabel * brokeageLab;
@property(nonatomic,strong) UITextField * brokeageFiled;

@property(nonatomic,strong) UILabel * realAmoLab;
@property(nonatomic,strong) UITextField * realAmoFiled;


@property (nonatomic, strong) TransferVM *vm;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, copy) NSString* brokeageRate;
@end

@implementation TransferVC

#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    TransferVC *vc = [[TransferVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    self.title = @"转账BUB";
//    self.view.backgroundColor = HEXCOLOR(0xf6f5fa);
    [self YBGeneral_baseConfig];
    [self initView];
    
    kWeakSelf(self);
    [self.vm network_transferBrokeageRateSuccess:^(id data) {
        kStrongSelf(self);
        TransferModel* model = data;
        self.brokeageRate = model.poundage;
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}

#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件 
- (void)YBGeneral_clickBackItem:(UIBarButtonItem *)item {//noscan
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) initView
{
    UIView * backView= [[UIView alloc]init];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    backView.backgroundColor = [UIColor whiteColor];

    UILabel * adddLab = [[UILabel alloc]init];
    adddLab.text =  @"转账地址";
    [backView addSubview:adddLab];
    adddLab.frame = CGRectMake(20, 25, MAINSCREEN_WIDTH - 40, 24);
    adddLab.textColor = HEXCOLOR(0x232630) ;

    self.addFiled = [UITextView new];
    self.addFiled.textColor = HEXCOLOR(0x333333);
    self.addFiled.font = [UIFont systemFontOfSize:13.0];
    self.addFiled.text = self.requestParams;
    self.addFiled.delegate = self;
    self.addFiled.showsHorizontalScrollIndicator = NO;
    self.addFiled.showsVerticalScrollIndicator = NO;
    self.addFiled.frame = CGRectMake(18, CGRectGetMaxY(adddLab.frame), MAINSCREEN_WIDTH - 2*18, 39);
    [backView addSubview:self.addFiled];

    self.transline = [[UIView alloc]init];
    [backView addSubview:self.transline];
    self.transline.backgroundColor = HEXCOLOR(0xe8e9ed);
    [self.transline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(backView);
        make.top.mas_equalTo(self.addFiled.mas_bottom);
    }];

    self.countLab = [[UILabel alloc]init];
    [backView addSubview:self.countLab];
    self.countLab.text = @"数量";
    self.countLab.textColor = HEXCOLOR(0x232630);
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.transline.mas_bottom).mas_offset(17);
    }];
    self.numberFiled = [UITextField new];
    self.numberFiled.textColor = HEXCOLOR(0x333333);
    self.numberFiled.font = [UIFont systemFontOfSize:13.0];
    self.numberFiled.keyboardType = UIKeyboardTypeDecimalPad;
    self.numberFiled.delegate = self;
    [self.numberFiled addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    self.numberFiled.placeholder = @"点击输入数量";
    [backView addSubview:self.numberFiled];
    [self.numberFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
       make.height.mas_equalTo(21); make.top.mas_equalTo(self.countLab.mas_bottom).mas_offset(8);
    }];
    UIView * line2 = [[UIView alloc]init];
    [backView addSubview:line2];
    line2.backgroundColor = HEXCOLOR(0xe8e9ed);
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(backView);
        make.top.mas_equalTo(self.numberFiled.mas_bottom).mas_offset(8);
    }];

    self.brokeageLab = [[UILabel alloc]init];
    [backView addSubview:self.brokeageLab];
    self.brokeageLab.text = @"转账手续费";
    self.brokeageLab.textColor = HEXCOLOR(0x232630);
    [self.brokeageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(line2.mas_bottom).mas_offset(17);
    }];
    self.brokeageFiled = [UITextField new];
    self.brokeageFiled.textColor = HEXCOLOR(0x333333);
    self.brokeageFiled.font = [UIFont systemFontOfSize:13.0];
    self.brokeageFiled.keyboardType = UIKeyboardTypeDecimalPad;
//    self.brokeageFiled.delegate = self;
    self.brokeageFiled.userInteractionEnabled = NO;
    
    self.brokeageFiled.placeholder = @"0 BUB";
    [backView addSubview:self.brokeageFiled];
    [self.brokeageFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(21); make.top.mas_equalTo(self.brokeageLab.mas_bottom).mas_offset(8);
    }];
    UIView * line3 = [[UIView alloc]init];
    [backView addSubview:line3];
    line3.backgroundColor = HEXCOLOR(0xe8e9ed);
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(backView);
        make.top.mas_equalTo(self.brokeageFiled.mas_bottom).mas_offset(8);
    }];
    
    self.realAmoLab = [[UILabel alloc]init];
    [backView addSubview:self.realAmoLab];
    self.realAmoLab.text = @"实际到账";
    self.realAmoLab.textColor = HEXCOLOR(0x232630);
    [self.realAmoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(line3.mas_bottom).mas_offset(17);
    }];
    self.realAmoFiled = [UITextField new];
    self.realAmoFiled.textColor = HEXCOLOR(0x333333);
    self.realAmoFiled.font = [UIFont systemFontOfSize:13.0];
    self.realAmoFiled.keyboardType = UIKeyboardTypeDecimalPad;
    //    self.brokeageFiled.delegate = self;
    self.realAmoFiled.userInteractionEnabled = NO;
    
    self.realAmoFiled.placeholder = @"0 BUB";
    [backView addSubview:self.realAmoFiled];
    [self.realAmoFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(21); make.top.mas_equalTo(self.realAmoLab.mas_bottom).mas_offset(8);
    }];
    UIView * line4 = [[UIView alloc]init];
    [backView addSubview:line4];
    line4.backgroundColor = HEXCOLOR(0xe8e9ed);
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(backView);
        make.top.mas_equalTo(self.realAmoFiled.mas_bottom).mas_offset(8);
    }];
    
    UILabel * adddLab3 = [[UILabel alloc]init];
    adddLab3.text = @"备注";
    [backView addSubview:adddLab3];
    adddLab3.textColor =  HEXCOLOR(0x232630);
    [adddLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(line4.mas_bottom).mas_offset(15);
    }];

    self.remarkTv = [UITextView new];
    self.remarkTv.textColor = HEXCOLOR(0x333333);
    self.remarkTv.zw_limitCount = 140;
    self.remarkTv.layer.masksToBounds = YES;
    self.remarkTv.layer.borderWidth = 1;
    self.remarkTv.font = [UIFont systemFontOfSize:14];
    self.remarkTv.layer.borderColor = HEXCOLOR(0xf9fafb).CGColor;
    self.remarkTv.backgroundColor = HEXCOLOR(0xf9fafb);
    //文字设置居右、placeHolder会跟随设置
    self.remarkTv.textAlignment = NSTextAlignmentLeft;
    self.remarkTv.scrollEnabled = NO;
    
    [backView addSubview:self.remarkTv];
    [self.remarkTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(adddLab3.mas_bottom).mas_offset(14);
        make.height.mas_equalTo(160);
    }];
    WS(weakSelf);
    [backView bottomDoubleButtonInSuperView:backView leftButtonEvent:^(id data) {
        [weakSelf clickCancel];
    } rightButtonEvent:^(id data) {
        [weakSelf clickConfirm];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.addFiled) {
        CGRect frame = textView.frame;
        
        CGFloat height = [NSString getContentHeightWithParagraphStyleLineSpacing:0 fontWithString:textView.text fontOfSize:13 boundingRectWithWidth:MAINSCREEN_WIDTH - 2*18]+20;
        frame.size.height = height;
        [UIView animateWithDuration:0.5 animations:^{
            
            textView.frame = frame;
            
        } completion:nil];
    }
    self.transline.frame = CGRectMake(20, CGRectGetMaxY(textView.frame), MAINSCREEN_WIDTH - 20, 1);
    return YES;
}

- (void)clickCancel
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)textField1TextChange:(UITextField *)textField{
    
    if ([textField isEqual:self.numberFiled]) {
        self.brokeageFiled.text = [NSString stringWithFormat:@"%.2f BUB",[textField.text floatValue] * [self.brokeageRate floatValue]];
        
        self.realAmoFiled.text = [NSString stringWithFormat:@"%.2f BUB",[textField.text floatValue] * (1-[self.brokeageRate floatValue])];
    }
}
- (void)clickConfirm
{
    WS(weakSelf);
    InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
    [popupView showInApplicationKeyWindow];
    [popupView actionBlock:^(id data) {
        [weakSelf postTransEvent:data];
    }];
}

- (void)postTransEvent:(NSDictionary*)data{
    WS(weakSelf);
    [self.vm network_postTransferWithPage:1 WithRequestParams:@[self.addFiled.text,self.numberFiled.text,self.remarkTv.text,data.allKeys[0],data.allValues[0],@(TransferWayTypeScan)] success:^(id data) {
        TransferModel* model = data;
        [TransferDetailVC  pushViewController:weakSelf requestParams:model.accountTransferId success:^(id data) {
            
        }];
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
    
}
- (TransferVM *)vm {
    if (!_vm) {
        _vm = [TransferVM new];
    }
    return _vm;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.numberFiled) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 13)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}
@end
