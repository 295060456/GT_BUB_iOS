//
//  AboutUsVC.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.
//  关于我们

#import "AboutUsVC.h"
#import "AboutTableViewCell.h"
#import "AboutVersionUpdateVC.h"
#import "UpgradeAlertView.h"
#import "AboutUsVCViewModel.h"
#import "WebViewController.h"

@interface AboutUsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *aTableView;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (nonatomic, strong) AboutUsVCViewModel *viewModel;
@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewModel.versionUpdateRequest execute:nil];
    self.version.text = [@"Version " stringByAppendingString:XcodeAppVersion];
}

- (AboutUsVCViewModel *) viewModel{
    if (!_viewModel) {_viewModel = [AboutUsVCViewModel new];}
    return _viewModel;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatusBarBackgroundColor:kWhiteColor];
    self.navigationController.navigationBar.barTintColor = kWhiteColor;
}

/**
 消息订阅
 */
- (void) bindViewModelRequest{
    @weakify(self)
    
    //订阅检查版本号
    [self.viewModel.versionUpdateRequest.executionSignals.switchToLatest subscribeNext:^(AboutUsModel* x) {
        @strongify(self)
        [self.aTableView reloadData];
        XcUpgradeAlertViewObj.model = x;
        self.version.text = [@"Version " stringByAppendingString:x.version];
    }];
    
    [self.viewModel.versionUpdateRequest.errors subscribeNext:^(NSError * _Nullable x) {
        
    }];
    
    //订阅退出登录
    [self.viewModel.outLoginRequest.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self locateTabBar:0];
    }];
    
    [self.viewModel.outLoginRequest.errors subscribeNext:^(NSError * _Nullable x) {
        
    }];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"AboutTableViewCell0";
    AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = GetXibObject(@"AboutTableViewCell", 0);
    }
    
    cell.data = self.viewModel.listData[indexPath.row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        AboutTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (!cell.arrow.hidden) {
            AboutVersionUpdateVC *vc = [[AboutVersionUpdateVC alloc] init];
            vc.model = self.viewModel.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.row==1){
        [WebViewController pushFromVC:self requestUrl:@"http://xieyi.bubchain.com" withProgressStyle:DKProgressStyle_Noraml success:^(id data) {
            
        }];
        
    } else if (indexPath.row==2){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
#pragma clang diagnostic pop
        [alertView show];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
            if ([x isEqual:@(1)]) {
                [self.viewModel.outLoginRequest execute:nil];
            }
        }];
    }
}

@end
