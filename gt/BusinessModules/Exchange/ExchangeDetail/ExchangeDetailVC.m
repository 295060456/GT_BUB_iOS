//
//  ExchangeDetailVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "ExchangeDetailVC.h"
#import "ExchangeDetailView.h"
#import "ExchangeDetailVM.h"

@interface ExchangeDetailVC () <ExchangeDetailViewDelegate>
@property (nonatomic, strong) ExchangeDetailView *mainView;
@property (nonatomic, strong) ExchangeDetailVM *vm;

@property (nonatomic, strong) ExchangeSubData* requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation ExchangeDetailVC

+ (instancetype)pushViewController:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block{
    ExchangeDetailVC *vc = [[ExchangeDetailVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:YES];
    return vc;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"兑换详情";
    [self initView];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WS(weakSelf);
    [self.mainView actionBlock:^(id data, id data2) {
        EnumActionTag tag  = [data intValue];
        switch (tag) {
            case EnumActionTag0:
            {
                
            }
                break;
            case EnumActionTag1:
            {
                [weakSelf exchangeDetailBackStatusView:weakSelf.mainView requestListWithPage:1];
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - HomeViewDelegate
- (void)exchangeDetailView:(ExchangeDetailView *)view requestListWithPage:(NSInteger)page {
    kWeakSelf(self);
    [self.vm network_getExchangeDetailWithPage:page WithRequestParams:self.requestParams.btcApplyId successuccess:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:data];
    } failed:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListFailed];
    } error:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

- (void)exchangeDetailBackStatusView:(ExchangeDetailView *)view requestListWithPage:(NSInteger)page {
    kWeakSelf(self);
    [self.vm network_getExchangeDetailBackWithPage:page WithRequestParams:self.requestParams.btcApplyId successuccess:^(id data) {
        kStrongSelf(self);
//        [self.mainView requestListSuccessWithArray:data];
        [self exchangeDetailView:view requestListWithPage:page];
    } failed:^(id data) {
//        kStrongSelf(self);
//        [self.mainView requestListFailed];
    } error:^(id data) {
//        kStrongSelf(self);
//        [self.mainView requestListFailed];
    }];
}
#pragma mark - getter

- (ExchangeDetailView *)mainView {
    if (!_mainView) {
        _mainView = [ExchangeDetailView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (ExchangeDetailVM *)vm {
    if (!_vm) {
        _vm = [ExchangeDetailVM new];
    }
    return _vm;
}

@end
