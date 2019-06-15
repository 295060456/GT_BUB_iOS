//
//  PageViewController.m
//  TestTabTitle
//
//  Created by Aalto on 2018/12/20..
//  Copyright © 2018年 Aalto. All rights reserved.
//

#import "OrdersPageVC.h"

#import "OrdersPageVM.h"

//#import "OrderDetailVC.h"

@interface OrdersPageVC ()<OrdersPageListViewDelegate>

@property (nonatomic, strong) OrdersPageVM *vm;

@property (nonatomic,assign)BOOL isFrist;

@property (nonatomic, copy) TwoDataBlock block;

@end

@implementation OrdersPageVC

-(void)dealloc{
//    NSLog(@"%s",__FUNCTION__);
}

-(void)addNotificationCenter{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenterAddData:) name:@"PAGVCNAME" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    _isFrist = false;
    [self initView];
   
}

- (void)initView {
    //    if (_mainView) {
    //        [_mainView removeFromSuperview];
    //    }
    //    _mainView = [OrdersPageListView new];
    //    _mainView.delegate = self;
    
    [self.view addSubview:self.mainView];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    WS(weakSelf);
    
    [self.mainView actionBlock:^(id data,id data2) {
        
        if (weakSelf.block) {
            
            weakSelf.block(data,data2);
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if(!_isFrist){
        //第一次进入,自动加载数据
        //        NSLog(@"第一次进入--%@",_tag);
        _isFrist = true;
    }else{
        //不是第一次进入,不加载数据
        //        NSLog(@"第二次进入--%@",_tag);
    }
    //    [self initView];
    [self ordersPageListView:self.mainView requestListWithPage:1];
    [self addNotificationCenter];
}

- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

#pragma mark - OrderPageViewDelegate
- (void)ordersPageListView:(OrdersPageListView *)view
       requestListWithPage:(NSInteger)page {
    
    kWeakSelf(self);
    [self.vm network_getOrdersPageListWithPage:page
                             WithRequestParams:self.tag
                                      withRole:self.titleType
                                       success:^(id data) {
                                           kStrongSelf(self);
                                           [self.mainView requestListSuccessWithArray:data
                                                                             WithPage:page
                                                                         WithUserType:self.utype];
                                       } failed:^(id data) {
                                           
                                           kStrongSelf(self);
                                           
                                           [self.mainView requestListFailed];
                                       } error:^(id data) {
                                           
                                           kStrongSelf(self);
                                           
                                           [self.mainView requestListFailed];
                                       }];
}

#pragma mark - getter
- (OrdersPageListView *)mainView {
    if (!_mainView) {
        
        _mainView = [OrdersPageListView new];
        
        _mainView.delegate = self;
    }
    return _mainView;
}

- (OrdersPageVM *)vm {
    if (!_vm) {
        
        _vm = [OrdersPageVM new];
    }
    return _vm;
}

-(void)notificationCenterAddData:(NSNotificationCenter*)not{
    if ([self.tag isEqualToString:@"0"]) {
        [self ordersPageListView:self.mainView requestListWithPage:1];
    }
}

@end
