//
//  PageViewController.m
//  TestTabTitle
//
//  Created by Aalto on 2018/12/20..
//  Copyright © 2018年 Aalto. All rights reserved.
//

#import "TRPageVC.h"
#import "TRPageListView.h"
#import "TRPageVM.h"

@interface TRPageVC ()<TRPageListViewDelegate>
@property (nonatomic, strong) TRPageListView *mainView;
@property (nonatomic, strong) TRPageVM *vm;
@property (nonatomic,assign)BOOL isFrist;
@property (nonatomic, copy) ActionBlock block;
@end

@implementation TRPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    
    _isFrist=false;
    [self initView];
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (void)initView {
    
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    kWeakSelf(self);
    [self.mainView actionBlock: ^(id data) {
        kStrongSelf(self);
        if (self.block) {
            self.block(data);
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    
    if(!_isFrist){
        //第一次进入,自动加载数据
//        NSLog(@"第一次进入--%@",_tag);
        _isFrist=true;
    }else{
        //不是第一次进入,不加载数据
//        NSLog(@"第二次进入--%@",_tag);
    }
//    [self initView];
    
}
#pragma mark - TRPageViewDelegate
- (void)trpageListView:(TRPageListView *)view requestListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm postTRPageListWithPage:page WithRequestParams:self.tag success:^(id data) {
        [weakself.mainView requestListSuccessWithArray:data WithPage:page];
    } failed:^(id data) {
        [weakself.mainView requestListFailed];
    } error:^(id data) {
        [weakself.mainView requestListFailed];
    }];
}

#pragma mark - getter
- (TRPageListView *)mainView {
    if (!_mainView) {
        _mainView = [TRPageListView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (TRPageVM *)vm {
    if (!_vm) {
        _vm = [TRPageVM new];
    }
    return _vm;
}

-(void)dealloc{
    
}
@end
