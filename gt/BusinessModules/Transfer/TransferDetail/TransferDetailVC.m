//
//  TransferDetailVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "TransferDetailVC.h"
#import "TransferDetailView.h"
#import "TransferDetailVM.h"

@interface TransferDetailVC () <TransferDetailViewDelegate>
@property (nonatomic, strong) TransferDetailView *mainView;
@property (nonatomic, strong) TransferDetailVM *vm;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation TransferDetailVC

#pragma mark - life cycle
+ (instancetype)pushViewController:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block{
    TransferDetailVC *vc = [[TransferDetailVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:YES];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"订单详情";
    [self initView];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    WS(weakSelf);
    [self.mainView actionBlock:^(id data,id data2) {
        
        EnumActionTag btnType  = [data integerValue];
        switch (btnType) {
            case EnumActionTag0://backHome
            {
                if (self.navigationController.tabBarController.selectedIndex == 0) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    self.navigationController.tabBarController.hidesBottomBarWhenPushed=NO;
                    self.navigationController.tabBarController.selectedIndex=0;
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
                break;
                
            default:
                break;
        }
        
        
    }] ;
}

#pragma mark - HomeViewDelegate

- (void)transferDetailView:(TransferDetailView *)view requestListWithPage:(NSInteger)page{
    kWeakSelf(self);
    [self.vm network_postTransferDetailWithPage:1 WithRequestParams:self.requestParams success:^(id data) {
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

#pragma mark - getter

- (TransferDetailView *)mainView {
    if (!_mainView) {
        _mainView = [TransferDetailView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (TransferDetailVM *)vm {
    if (!_vm) {
        _vm = [TransferDetailVM new];
    }
    return _vm;
}

@end
