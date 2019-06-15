//
//  AboutVersionUpdateVC.m
//  gt
//
//  Created by bub chain on 16/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AboutVersionUpdateVC.h"
#import "AboutTableViewCell.h"

@interface AboutVersionUpdateVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *versionNum;

@end

@implementation AboutVersionUpdateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.versionNum.text = [NSString stringWithFormat:@"Version %@",self.model.version];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatusBarBackgroundColor:HEXCOLOR(0xF5F5F5)];
    self.navigationController.navigationBar.barTintColor = HEXCOLOR(0xF5F5F5);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.changelogList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *content = self.model.changelogList[indexPath.row];
    CGFloat width = MAINSCREEN_WIDTH - 20*2;// - 13;
    return calculateStringHeightWithStr(content, kFontSize(13), width)+8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"AboutTableViewCell1";
    AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = GetXibObject(@"AboutTableViewCell", 1);
    }
    cell.indexPath = indexPath;
    cell.versionContent = self.model.changelogList[indexPath.row];
    return cell;
}
- (IBAction)clickUpdate:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.url]
                                       options:@{}
                             completionHandler:^(BOOL success) {
                                 
                             }];
}

@end
