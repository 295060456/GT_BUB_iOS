//
//  ModifyAdsVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "ModifyAdsVC.h"
#import "ModifyAdsView.h"
#import "ModifyAdsVM.h"
#import "XcPostAdsVC.h"
#import "PageVM.h"
#import "InputPWPopUpView.h"
@interface ModifyAdsVC () <ModifyAdsViewDelegate>
@property (nonatomic, strong) ModifyAdsView *mainView;
@property (nonatomic, strong) ModifyAdsVM *vm;
@property (nonatomic, strong) PageVM *pagevm;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) NSString* adId;
@property (nonatomic, copy) DataBlock successBlock;
@property (nonatomic, strong) ModifyAdsModel* modifyAdsModel;
@end

@implementation ModifyAdsVC
#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC withAdId:(NSString*)adId success:(DataBlock)block{
    ModifyAdsVC *vc = [[ModifyAdsVC alloc] init];
    vc.successBlock = block;
    vc.adId = adId;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"广告详情";
    [self initView];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    WS(weakSelf);
    [self.mainView actionBlock: ^(id data) {
        EnumActionTag btnType  = [data integerValue];
        switch (btnType) {
            case EnumActionTag2:
            {
                [XcPostAdsVC pushFromVC:self requestParams:self.modifyAdsModel success:^(id data) {
                    
                }];
            }
                break;
            case EnumActionTag3:
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认要下架吗？" message:nil preferredStyle:  UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
                    [popupView showInApplicationKeyWindow];
                    [popupView actionBlock:^(id data) {
                        
                        [self.pagevm network_outlineAdRequestParams:data withAdID:self.adId success:^(id data) {
                            [self modifyAdsView:self.mainView requestListWithPage:1];
                            //                                [YKToastView showToastText:@"下架成功"];
                            
                        } failed:^(id data) {
                            
                        } error:^(id data) {
                            
                        }];
                        
                        
                        
                    }];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:true completion:nil];
            }
                break;
                
            default:
                
                break;
        }
    }];
}

#pragma mark - modifyAdsViewDelegate
- (void)modifyAdsView:(ModifyAdsView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getModifyAdsListWithPage:page WithRequestParams:self.adId success:^(id data,id data2) {
        kStrongSelf(self);
        self.modifyAdsModel = data2;
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

- (ModifyAdsView *)mainView {
    if (!_mainView) {
        _mainView = [ModifyAdsView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (ModifyAdsVM *)vm {
    if (!_vm) {
        _vm = [ModifyAdsVM new];
    }
    return _vm;
}

- (PageVM *)pagevm {
    if (!_pagevm) {
        _pagevm = [PageVM new];
    }
    return _pagevm;
}
@end
