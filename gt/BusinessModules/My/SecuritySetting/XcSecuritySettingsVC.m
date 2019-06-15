//
//  XcSecuritySettingsVC.m
//  gt
//
//  Created by bub chain on 20/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcSecuritySettingsVC.h"
#import "XcSSCellTableViewCell.h"
#import "XcSecuritySettingsVM.h"

@interface XcSecuritySettingsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) XcSecuritySettingsVM *viewModel;
@property (nonatomic, strong) UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *ssTableView;
@property (nonatomic, copy) DataBlock block;
@end

@implementation XcSecuritySettingsVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    XcSecuritySettingsVC *vc = [[XcSecuritySettingsVC alloc] init];
    vc.block = block;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"安全设置";
    self.ssTableView.tableHeaderView = self.headerView;
}

- (XcSecuritySettingsVM *) viewModel{
    if (!_viewModel) {_viewModel = [XcSecuritySettingsVM new];}
    return _viewModel;
}

- (void) bindViewModelRequest{
    @weakify(self)
    
    //订阅提交信息信号
    [self.viewModel.submitRequest.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.viewModel.getUserInfoRequest execute:nil];
    }];
    
    //订阅获取个人信息信号
    [self.viewModel.getUserInfoRequest.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.block) {
            self.block(@(1));
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    

    RAC(self.submitBtn, enabled) = self.viewModel.submitBtnEnabled;
}

- (UIView *) headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 80.0f)];
        UILabel *title = CreateLabelWith(CGRectZero,
                                         @"为了您的资金安全，请设置",
                                         kFontSize(20),
                                         RGBCOLOR(57, 67, 104),
                                         kClearColor,
                                         NSTextAlignmentLeft,
                                         _headerView);
        @weakify(self)
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.left.equalTo(self.headerView.mas_left).offset(26);
            make.centerY.equalTo(self.headerView.mas_centerY).offset(0);
        }];
    }
    return _headerView;
}

- (IBAction)submitSet:(UIButton *)sender {
    if (self.viewModel.pwIsEqual) {
        [self.viewModel.submitRequest execute:nil];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"XcSSCellTableViewCell0";
    XcSSCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = GetXibObject(@"XcSSCellTableViewCell", 0);
    }
    
    if (indexPath.row==0) {
        RAC(self.viewModel, pw) = cell.textField.rac_textSignal;
    }else if (indexPath.row==1) {
        RAC(self.viewModel, nPw) = cell.textField.rac_textSignal;
    }
    
    cell.data = self.viewModel.listData[indexPath.row];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
