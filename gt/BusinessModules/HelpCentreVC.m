//
//  LoginVC.m
//  gtp
//
//  Created by GT on 2019/1/2.
//  Copyright © 2019 GT. All rights reserved.
//

#import "HelpCentreVC.h"
#import "LoginVM.h"
#import "AboutUsModel.h"
#import "WebViewController.h"
@interface HelpCentreVC ()
@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) NSMutableArray* leftLabs;

@property (nonatomic, strong) NSMutableArray* downBtns;
@property (nonatomic, strong) UIButton *forgetPWBtn;

@property (nonatomic, strong) UIButton *registerBtn;

@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) LoginVM* vm;
@property (nonatomic, strong) AboutUsModel* model;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;
@end

@implementation HelpCentreVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    HelpCentreVC *vc = [[HelpCentreVC alloc] init];
    vc.successBlock = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"帮助支持";
    [self initView];
}


- (void)initView {
    UIImageView* iconIv = [[UIImageView alloc]init];
    [self.view addSubview:iconIv];
    iconIv.layer.masksToBounds = YES;
    iconIv.layer.cornerRadius = 5;
    [iconIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
       make.top.equalTo(self.view).offset(21); make.size.mas_equalTo(CGSizeMake(86, 86));
    }];
    iconIv.image = kIMG(@"icon-in-app");
    
    _postAdsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _postAdsButton.adjustsImageWhenHighlighted = NO;
    _postAdsButton.titleLabel.font = kFontSize(13);
    [_postAdsButton setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
    _postAdsButton.titleLabel.numberOfLines = 0;
    _postAdsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _postAdsButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_postAdsButton];
    [_postAdsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconIv.mas_bottom).offset(24);//别用scrollView
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.height.mas_equalTo(@36);
    }];
    
    [self layoutAccountPublic];
    
    UIImage* decorImage = kIMG(@"reverse_login_top");
    _decorIv = [[UIImageView alloc]init];
    [self.view addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX); make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(decorImage.size.width, 242));
    }];
    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    
    _accLab = [[UILabel alloc]init];
    [_decorIv addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
        make.top.equalTo(self.decorIv).offset(110);
        make.left.equalTo(self.decorIv);
        make.height.equalTo(@26);
    }];
    
    [self layoutDownUI];
}

-(void)layoutAccountPublic{
    _leftLabs = [NSMutableArray array];
    
    _downBtns = [NSMutableArray array];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(225, 38, 255, 38));
    }];
    
    UIView *containView = [UIView new];
    containView.backgroundColor = kWhiteColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *lastView = nil;
    for (int i = 0; i < 2; i++) {
        UIView *sub_view = [UIView new];
        sub_view.userInteractionEnabled = YES;
        UIButton* leftBtn = [[UIButton alloc]init];
        leftBtn.tag = i;
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
        leftBtn.titleLabel.font = kFontSize(17);
        [leftBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [sub_view addSubview:leftBtn];
        [_leftLabs addObject:leftBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
            make.centerY.equalTo(sub_view);
            make.width.equalTo(sub_view);
        }];
        
        UIImageView* arrowIv = [[UIImageView alloc] init];
        arrowIv.image = [UIImage imageNamed:@"btnRight"];
        arrowIv.tag = i;
        [sub_view addSubview:arrowIv];
        
        [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(sub_view).offset(0);
            make.centerY.equalTo(sub_view);
            make.width.height.equalTo(@(18));
        }];
        
        UIImageView* line1 = [[UIImageView alloc]init];
        [sub_view addSubview:line1];
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.bottom.equalTo(sub_view.mas_bottom).offset(-2);
            make.height.equalTo(@.5);
        }];
        
        [containView addSubview:sub_view];
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(50));//*i
            
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).offset(6);//下个顶对上个底的间距=上个顶对整个视图顶的间距
            }else
            {
                make.top.mas_equalTo(containView.mas_top);//-15多出来scr
            }
        }];
        //最后一个
        lastView = sub_view;
    }
    // 最后更新containView
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(0);
    }];
}

-(void)layoutDownUI{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    [self.decorIv addSubview:scrollView];
    self.decorIv.userInteractionEnabled = YES;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.decorIv).with.insets(UIEdgeInsetsMake(142, 38, 26, 38));
    }];
    
    UIView *containView = [UIView new];
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *lastView = nil;
    for (int i = 0; i < 3; i++) {
        UIView *sub_view = [UIView new];
        UIButton* leftBtn = [[UIButton alloc]init];
        leftBtn.tag = i+2;
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        leftBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [leftBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        leftBtn.titleLabel.font = kFontSize(13);
        [leftBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setImage:[UIImage imageNamed:@"white_copy"] forState:UIControlStateNormal];
        [sub_view addSubview:leftBtn];
        [_downBtns addObject:leftBtn];
        
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
            //            make.top.equalTo(sub_view).offset(19);
            //            make.bottom.equalTo(sub_view).offset(-4);
            make.centerY.equalTo(sub_view);
            make.width.equalTo(sub_view);
        }];
        [leftBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10.5];
        
        [containView addSubview:sub_view];
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(18));//*i
            
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).offset(10);//下个顶对上个底的间距=上个顶对整个视图顶的间距
            }else
            {
                make.top.mas_equalTo(containView.mas_top);//-15多出来scr
            }
            
        }];
        //最后一个
        lastView = sub_view;
    }
    // 最后更新containView
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(0);
    }];
    
    [self richElementsInViewWithModel];
}

- (void)richElementsInViewWithModel{
    
    [_postAdsButton setTitle:@"我们希望帮助您充分利用所有功能，并解决遇到的问题" forState:UIControlStateNormal];
    
    UIButton* lab0 = _leftLabs[0];
    [lab0 setTitle:@"帮助支持" forState:UIControlStateNormal];
    UIButton* lab1 = _leftLabs[1];
    [lab1 setTitle:@"在线客服" forState:UIControlStateNormal];
    
    _accLab.text = @"其他联系方式";
    _accLab.textAlignment = NSTextAlignmentCenter;
    _accLab.textColor = HEXCOLOR(0xffffff);
    _accLab.font = kFontSize(15);
    
    kWeakSelf(self);
    [self.vm network_helpCentreWithRequestParams:@1 success:^(id data) {
        self.model = data;
        kStrongSelf(self);
        UIButton* clab0 = self.downBtns[0];
        [clab0 setTitle:[NSString stringWithFormat:@"QQ：%@",self.model.qq] forState:UIControlStateNormal];
        UIButton* clab1 = self.downBtns[1];
        [clab1 setTitle:[NSString stringWithFormat:@"微信：%@",self.model.qq] forState:UIControlStateNormal];
        UIButton* clab2 = self.downBtns[2];
        [clab2 setTitle:[NSString stringWithFormat:@"邮箱：%@",self.model.qq] forState:UIControlStateNormal];
        for (UIButton* btn in self.downBtns) {
            [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10.5];
        }
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}

- (void)clickItem:(UIButton*)sender{
    EnumActionTag type = sender.tag;
    switch (type) {
        case EnumActionTag0:
//            [self helpEvent];
            break;
        case EnumActionTag1:
            [self contactEvent];
            break;
        default:
        {
            if (![NSString isEmpty:sender.titleLabel.text]) {
                [YKToastView showToastText:@"复制成功!"];
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = sender.titleLabel.text;
            }
        }
            break;
    }
}

- (void)helpEvent{
    
    [WebViewController pushFromVC:self requestUrl:@"http://baidu.com/"  withProgressStyle:DKProgressStyle_Gradual success:^(id data) {}];
}

- (void)contactEvent{
    if (self.model!=nil) {
        NSString *sessionId = [NSString stringWithFormat:@"%@",self.model.rongCloudId];
        NSString *title = [NSString stringWithFormat:@"%@",self.model.rongCloudName];
        
        [RongCloudManager updateNickName:title userId:sessionId];
        [RongCloudManager jumpNewSessionWithSessionId:sessionId title:title navigationVC:self.navigationController];
    }
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (LoginVM *)vm {
    
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}

@end


