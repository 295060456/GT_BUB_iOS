//
//  AdsVC.m
//  gtp
//
//  Created by GT on 2018/12/19.
//  Copyright © 2018 GT. All rights reserved.
//

#import "OrdersVC.h"
#import "TabScrollview.h"
#import "TabContentView.h"

#import "OrdersPageVC.h"

#import "DistributePopUpView.h"
#import "InputPWPopUpView.h"

#import "BuyBubDetailVC.h"
#import "OrderDetailModel.h"
#import "LoginModel.h"
#import "AppealProgressVC.h"
#import "OrderDetailVM.h"
#import "BuyBubDetailVC.h"




@interface OrdersVC ()
@property (nonatomic,strong)TabScrollview *tabScrollView;
@property (nonatomic,strong)TabContentView *tabContent;
@property (nonatomic,strong)NSMutableArray *tabs;
@property (nonatomic,assign)NSInteger locateIndex;
@property (nonatomic,strong)NSMutableArray *contents;
@property (nonatomic,assign)UserType utype;
@property (nonatomic, strong) OrderDetailVM *vm;
@property (nonatomic, strong) NSMutableArray *titleAr;
@property (nonatomic, strong) NSString *myTitleTYpe;
@property (nonatomic, assign) float titleHeight;
@end

@implementation OrdersVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    OrdersVC *vc = [[OrdersVC alloc] init];
    LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    vc.utype = [userInfoModel.userinfo.userType intValue];
    if (vc.utype == UserTypeSeller) {//卖家 没有大分类
        vc.titleHeight = 35;
    }else{                         //买家 才有大分类
        vc.titleHeight = 73;
    }
    vc.locateIndex = 0;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC locateIndex:(NSInteger)locateIndex
{
    OrdersVC *vc = [[OrdersVC alloc] init];
    vc.locateIndex = locateIndex;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

-(void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollToTop{
    OrdersPageVC *con = _contents[_locateIndex];
    [con.mainView scrollToTop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    
    LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    self.myTitleTYpe = @"1";
    if (userInfoModel.userinfo.userType) {
        self.myTitleTYpe = userInfoModel.userinfo.userType;
    }
    self.title=@"我的订单";
    NSArray* titles = @[@{@"全部":@"0"},
                        @{@"未付款":@"1"},
                        @{@"已付款":@"2"},
                        @{@"申诉中":@"6"},
                        @{@"已取消":@"4"},
                        @{@"已完成":@"3"}
                        ];
    
    
    //    _utype = UserTypeBuyer;//test
    _tabs=[[NSMutableArray alloc]initWithCapacity:titles.count];
    _contents=[[NSMutableArray alloc]initWithCapacity:titles.count];
    kWeakSelf(self);
    for(int i=0;i<titles.count;i++){
        NSDictionary *titleDic=titles[i];
        
        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.font = kFontSize(14);
        tab.text=titleDic.allKeys[0];
        tab.textColor=[UIColor blackColor];
        [_tabs addObject:tab];
        OrdersPageVC *con=[OrdersPageVC new];
        con.titleType = self.myTitleTYpe;
        con.view.backgroundColor= RANDOMRGBCOLOR;
        con.tag=titleDic.allValues[0];
        con.utype = self.utype;
        [_contents addObject:con];
        
        __weak __typeof(con)weakCon = con;
        
        [con actionBlock:^(id data,id data2) {
            
            kStrongSelf(self);
            
            OrderDetailModel* orderDetailModel = data2;
            
            OrderType type = [orderDetailModel  getTransactionOrderType];
            
            if ([data boolValue]==YES) {

                switch (type) {
                    case SellerOrderTypeNotYetPay:
                    {
                        //                        [YKToastView showToastText:@"提醒已发送"];
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"订单待确认付款" message:[NSString stringWithFormat:@"您好，您的广告已被拍下，订单号为%@，等待买家确认付款。点击查看订单详情",orderDetailModel.orderNo] preferredStyle:  UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"现在去看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [BuyBubDetailVC pushFromVC:self.navigationController requestParams:orderDetailModel.otcOrderId success:^(id data) {
                                
                            }];

//                            [OrderDetailVC pushViewController:self
//                                                requestParams:orderDetailModel.otcOrderId
//                                                      success:^(id data) {
//
//                                                      }];
                        }]];
                        [self presentViewController:alert animated:true completion:nil];

                    }
                        break;
                    case SellerOrderTypeWaitDistribute:
                    {
                        DistributePopUpView* popupView = [[DistributePopUpView alloc]init];
                        [popupView richElementsInViewWithModel:orderDetailModel];
                        [popupView showInApplicationKeyWindow];
                        
                        kWeakSelf(self);
                        
                        [popupView actionBlock:^(id data) {
                            
                            kStrongSelf(self);
                            
                            InputPWPopUpView* popupVi = [[InputPWPopUpView alloc]init];
                            [popupVi showInApplicationKeyWindow];
                            kWeakSelf(self);
                            
                            [popupVi actionBlock:^(id data) {
                                
                                kStrongSelf(self);
                                
//                                [YKToastView showToastText:@"已放行"];
                                [self distributeOrder:data
                                     WithOrderDetailModel:orderDetailModel
                                         WithOrdersPageVC:weakCon];
                            }];
                        }];
                    }
                        break;
                    case SellerOrderTypeAppealing://联系买家
                    {
                        [self contactEvent:orderDetailModel];
                    }
                        break;
                    default:
                        break;
                }
            }
            else{
                // 申述中的订单跳转 XiRan
                if (orderDetailModel.status && [orderDetailModel.status  isEqualToString:@"6"]) {
                    [AppealProgressVC pushViewController:self
                                           requestParams:orderDetailModel.otcOrderId
                                                 success:^(id data) {
//                                                     NSLog(@"....%@",orderDetailModel);
                                                 }];
                }else{
                    [BuyBubDetailVC pushFromVC:self.navigationController requestParams:orderDetailModel.orderNo?orderDetailModel.orderNo:orderDetailModel.orderId success:^(id data) {}];
                }
            }
        }];
    }
    
    _tabScrollView=[[TabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabScrollView];
    [_tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.titleHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    WS(weakSelf);
    [_tabScrollView configParameter:horizontal viewArr:_tabs tabWidth:[UIScreen mainScreen].bounds.size.width/titles.count tabHeight:self.titleHeight index:self.locateIndex block:^(NSInteger index) {
        [weakSelf.tabContent updateTab:index];
        weakSelf.locateIndex = index;
    }];
    
    
    _tabContent=[[TabContentView alloc]initWithFrame:CGRectZero];
    _tabContent.userInteractionEnabled = YES;
    [self.view addSubview:_tabContent];
    
    [_tabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(weakSelf.tabScrollView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    [_tabContent configParam:_contents Index:self.locateIndex block:^(NSInteger index) {
        [weakSelf.tabScrollView updateTagLine:index];
        weakSelf.locateIndex = index;
    }];
    
    
    if (self.titleHeight > 70) { // 卖家没有 大分类
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, MAINSCREEN_WIDTH -28, 33)];
        [_tabScrollView addSubview:titleView];
        titleView.layer.cornerRadius = 4;
        titleView.layer.borderWidth = 1;
        titleView.clipsToBounds = YES;
        titleView.layer.borderColor  = HEXCOLOR(0x4c7fff).CGColor;
        self.titleAr = [NSMutableArray array];
        NSArray *ar = @[@"买币订单",@"卖币订单"];
        NSInteger cun = ar.count;
        for (int i =0 ; i< cun; i++) {
            UIButton *bu = [UIButton buttonWithType:UIButtonTypeCustom];
            bu.frame = CGRectMake((MAINSCREEN_WIDTH -28)/cun*i, 0, (MAINSCREEN_WIDTH -28)/cun, 33);
            [titleView addSubview:bu];
            [bu setTitle:ar[i] forState:(UIControlStateNormal)];
            bu.tag = 12000 + i ;
            bu.titleLabel.font = kFontSize(15);
            [bu addTarget:self action:@selector(titleAction:) forControlEvents:(UIControlEventTouchUpInside)];
            if (i == 0) {
                [bu setTitleColor:kWhiteColor forState:UIControlStateNormal];
                bu.backgroundColor =HEXCOLOR(0x4c7fff);
            }else{
                [bu setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
                bu.backgroundColor = kWhiteColor;
            }
            [self.titleAr addObject:bu];
        }
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(scrollToTop)];
    tap.numberOfTapsRequired = 2;
    [self.navigationController.navigationBar addGestureRecognizer:tap];
    
    return;
    
    //    [_tabContent actionBlock:^(id data) {
    ////        [UIView  beginAnimations:nil context:NULL];
    ////        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    ////        [UIView setAnimationDuration:0.75];
    ////        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    ////        [UIView commitAnimations];
    ////
    ////        [UIView beginAnimations:nil context:NULL];
    ////        [UIView setAnimationDelay:0.375];
    ////        [self.navigationController popViewControllerAnimated:NO];
    ////        [UIView commitAnimations];
    //
    //        CATransition* transition = [CATransition animation];
    //        transition.duration = .3;
    //        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //        transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //        [self.navigationController.view.layer addAnimation:transition forKey:nil];
    //        [[self navigationController] popViewControllerAnimated:NO];
    //
    ////            [self.navigationController popViewControllerAnimated:YES];
    //
    //    }];
    
}

- (void)contactEvent:(OrderDetailModel*) orderDetailModel{
    if (orderDetailModel !=nil) {
        NSString *sessionId;
        NSString *title;
        
        if (![NSString isEmpty:orderDetailModel.buyUserId]
            &&![NSString isEmpty:orderDetailModel.buyerName]){
            sessionId = orderDetailModel.buyUserId;
            title = orderDetailModel.buyerName;
            
            [RongCloudManager updateNickName:title userId:sessionId];
            [RongCloudManager jumpNewSessionWithSessionId:sessionId title:title navigationVC:self.navigationController];
        }
    }
}
- (void)distributeOrder:(id)data
   WithOrderDetailModel:(OrderDetailModel*)orderDetailModel
       WithOrdersPageVC:(OrdersPageVC*)ordersPageVC{
    //    kWeakSelf(self);
    [self.vm network_transactionOrderSureDistributeWithCodeDic:data
                                             WithRequestParams:orderDetailModel.orderNo
                                                       success:^(id data) {
                                                           //                                                           kStrongSelf(self);
                                                           [ordersPageVC ordersPageListView:ordersPageVC.mainView
                                                                        requestListWithPage:1];
                                                       } failed:^(id data) {
                                                           
                                                       } error:^(id data) {
                                                           
                                                       }];
}

- (OrderDetailVM *)vm {
    if (!_vm) {
        _vm = [OrderDetailVM new];
    }
    return _vm;
}


-(void)titleAction:(UIButton*)bu{
    NSInteger ti = bu.tag - 12000;
    self.myTitleTYpe = [NSString stringWithFormat:@"%ld",ti +1];
    UIButton *bu1 = self.titleAr[0];
    UIButton *bu2 = self.titleAr[1];
    [bu1 setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    bu1.backgroundColor =kWhiteColor;
    [bu2 setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    bu2.backgroundColor = kWhiteColor;
    [bu setTitleColor:kWhiteColor forState:UIControlStateNormal];
    bu.backgroundColor = HEXCOLOR(0x4c7fff);
    NSLog(@"----- %@",self.myTitleTYpe);
//    [_contents addObject:con];
    for (OrdersPageVC *con in _contents) {
        con.titleType = self.myTitleTYpe;
    }
    [_tabScrollView updateTagLine:0];
    [_tabContent updateTab:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PAGVCNAME" object:nil];

}

@end
