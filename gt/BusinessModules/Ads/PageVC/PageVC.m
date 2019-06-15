//
//  PageViewController.m
//  TestTabTitle
//
//  Created by Aalto on 2018/12/20..
//  Copyright © 2018年 Aalto. All rights reserved.
//

#import "PageVC.h"
#import "PageListView.h"
#import "PageVM.h"
#import "InputPWPopUpView.h"

@interface PageVC ()<PageListViewDelegate>
@property (nonatomic, strong) PageListView *mainView;
@property (nonatomic, strong) PageVM *vm;
@property (nonatomic,assign)BOOL isFrist;
@property (nonatomic, copy) TableViewDataBlock block;
@end

@implementation PageVC

-(void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    
    _isFrist=false;
    [self initView];
}
- (void)actionBlock:(TableViewDataBlock)block
{
    self.block = block;
}
- (void)initView {
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    kWeakSelf(self);
    [self.mainView actionBlock: ^(id data,id data2,UIView* view,UITableView* tableView,NSMutableArray *dataSource,NSIndexPath* indexPath) {
        kStrongSelf(self);
        if (self.block) {
            self.block(data, data2,view,tableView,dataSource,indexPath);
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!_isFrist){
        //第一次进入,自动加载数据
//        NSLog(@"第一次进入--%@",_tag);
        _isFrist=true;
    }else{
        //不是第一次进入,不加载数据
//        NSLog(@"第二次进入--%@",_tag);
    }
//    [self initView];
    [self pageListView:self.mainView requestListWithPage:1];
}
#pragma mark - adsPageViewDelegate
- (void)pageListView:(PageListView *)view requestListWithPage:(NSInteger)page {
    kWeakSelf(self);
    [self.vm network_getAdsPageListWithPage:page WithRequestParams:self.tag success:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:data WithPage:page];
    } failed:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListFailed];
    } error:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter
- (PageListView *)mainView {
    if (!_mainView) {
        _mainView = [PageListView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (PageVM *)vm {
    if (!_vm) {
        _vm = [PageVM new];
    }
    return _vm;
}

@end
