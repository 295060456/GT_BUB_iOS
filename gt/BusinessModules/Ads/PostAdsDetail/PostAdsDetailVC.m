//
//  PostAdsDetailVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PostAdsDetailVC.h"
#import "PostAdsDetailView.h"
#import "PostAdsDetailVM.h"

#import "ModifyAdsVC.h"

@interface PostAdsDetailVC () <PostAdsDetailViewDelegate>
@property (nonatomic, strong) PostAdsDetailView *mainView;
@property (nonatomic, strong) PostAdsDetailVM *vm;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) NSString* adId;
@property (nonatomic, copy) DataBlock successBlock;
@end

@implementation PostAdsDetailVC

#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams withAdId:(NSString*)adId success:(DataBlock)block{
    PostAdsDetailVC *vc = [[PostAdsDetailVC alloc] init];
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.adId = adId;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"发布广告";
    [self initView];
}

- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WS(weakSelf);
    
    [self assembleApiData:self.requestParams];
    
    [self.mainView actionBlock : ^(id data) {
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
            case EnumActionTag1:
            {
                [ModifyAdsVC pushFromVC:self
                               withAdId:self.adId success:^(id data) {
                    
                }];

            }
                break;
                
            default:
                
                break;
        }
    }];
}

- (void)assembleApiData:(id)requestParams{
//    [self.listData addObjectsFromArray:@[dic1]];
    [self.mainView requestListSuccessWithArray:@[requestParams]];
}

#pragma mark - postAdsDetailViewDelegate No

- (void)postAdsDetailView:(PostAdsDetailView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getPostAdsDetailListWithPage:page success:^(NSArray * _Nonnull dataArray) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:dataArray];
    } failed:^{
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter

- (PostAdsDetailView *)mainView {
    if (!_mainView) {
        _mainView = [PostAdsDetailView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (PostAdsDetailVM *)vm {
    if (!_vm) {
        _vm = [PostAdsDetailVM new];
    }
    return _vm;
}

@end
