//
//  ContactCustomerServiceViewController.m
//  gt
//
//  Created by cookie on 2018/12/26.
//  Copyright © 2018 GT. All rights reserved.
//联系客服

#import "ContactCustomerServiceViewController.h"
#import "MsgListTableViewCell.h"

@interface ContactCustomerServiceViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation ContactCustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系客服";
    [self YBGeneral_baseConfig];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
    // Do any additional setup after loading the view.
}
-(void)initView{
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
    lineView.backgroundColor = COLOR_RGB(246, 245, 250, 1);
    [self.view addSubview:lineView];
    
    float h = MAINSCREEN_HEIGHT - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight] - 5;
//    if ([YBFrameTool statusBarHeight] > 21) {
//        h = h - 49 - 34;
//    }else{
//        h = h - 49;
//    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, MAINSCREEN_WIDTH, h)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80 * SCALING_RATIO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"msgListCell";
    MsgListTableViewCell *cell = (MsgListTableViewCell*)[_tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MsgListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
