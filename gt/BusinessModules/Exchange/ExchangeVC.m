//
//  PostAdsVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "ExchangeVC.h"
#import "ExchangeView.h"
#import "ExchangeVM.h"
#import "ExchangeDetailVC.h"

@interface ExchangeVC () <ExchangeViewDelegate>
@property (nonatomic, strong) ExchangeView *mainView;
@property (nonatomic, strong) ExchangeVM *vm;

@end

@implementation ExchangeVC

#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    ExchangeVC *vc = [[ExchangeVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"兑换比特币";
    [self initView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backExchangeSuccessBlockMethod) name:kNotify_IsBackExchangeRefresh object:nil];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    kWeakSelf(self);
    [self.mainView actionBlock:^(id data) {
         kStrongSelf(self);
        if ([data isKindOfClass:[NSArray class]]) {
            [self.vm network_getExchangeApplyWithResquestParams:data Success:^(id data) {
                [self exchangeView:self.mainView requestListWithPage:1];
            } failed:^(id data) {
                
            } error:^(id data) {
                
            }];
        }
        else{
            [ExchangeDetailVC pushViewController:self requestParams:data success:^(id data) {}];
        }
    }];
    
}
-(void)backExchangeSuccessBlockMethod{
    [self exchangeView:self.mainView requestListWithPage:1];
}
#pragma mark - HomeViewDelegate

- (void)exchangeView:(ExchangeView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getExchangeListWithPage:page WithExchangeType:ExchangeTypeAll success:^(id data) {
        NSArray * dataArray = data;
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:dataArray WithPage:page];
    } failed:^(id data){
        kStrongSelf(self);
        [self.mainView requestListFailed];
    } error:^(id data){
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter

- (ExchangeView *)mainView {
    if (!_mainView) {
        _mainView = [ExchangeView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (ExchangeVM *)vm {
    if (!_vm) {
        _vm = [ExchangeVM new];
    }
    return _vm;
}

@end
