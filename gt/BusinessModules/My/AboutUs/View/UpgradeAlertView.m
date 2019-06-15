//
//  UpgradeAlertView.m
//  gt
//
//  Created by bub chain on 16/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "UpgradeAlertView.h"
#import "AboutTableViewCell.h"
#import "AboutUsVCViewModel.h"

@interface UpgradeAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UITableView *uTableView;
@property (nonatomic, strong) NSArray *listData;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, strong) UIWindow *nWindow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tablviewH;

@property (nonatomic, assign) CGFloat  tv_height;
@property (nonatomic, strong) NSMutableArray *tableHeights;
@end

@implementation UpgradeAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setModel:(AboutUsModel *)model{
    _model = model;
    if ([AboutUsVCViewModel compareVersion2:XcodeAppVersion to:model.version]==-1) {
        self.listData       = model.changelogList;
        self.version.text   = [@"V " stringByAppendingString:model.version];
        self.closeBtn.hidden= ![model.type isEqualToString:@"0"];
        [[RACScheduler mainThreadScheduler]afterDelay:.5 schedule:^{
            self.nWindow = ShowInWindowView(self);
        }];
        self.tablviewH.constant = self.tv_height;
    }
}

- (instancetype) initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    self = [super initWithFrame:frame];
    if (self) {
        self = GetXibObject(@"UpgradeAlertView", 0);
        self.mj_h = frame.size.height;
        self.mj_w = frame.size.width;
        self.mj_x = frame.origin.x;
        self.mj_y = frame.origin.y;
        self.uTableView.mj_h = 300;
        self.uTableView.delegate = self;
        self.uTableView.dataSource = self;
    }
    return self;
}

- (NSMutableArray *) tableHeights{
    if (!_tableHeights) {
        _tableHeights = [NSMutableArray array];
        for (NSString*content in self.listData) {
            CGFloat h = calculateStringHeightWithStr(content, kFontSize(13), self.uTableView.mj_w)+5;
            [_tableHeights addObject:[NSNumber numberWithFloat:h]];
        }
    }
    return _tableHeights;
}

- (CGFloat) tv_height{
    CGFloat hh=0;
    for (NSNumber*h in self.tableHeights) {
        hh += h.floatValue;
    }
    return hh;
}

/**
 关闭升级提示

 @param sender <#sender description#>
 */
- (IBAction)clickClose:(UIButton *)sender {
    HideInWindowView(self);
}



/**
 立即更新

 @param sender <#sender description#>
 */
- (IBAction)clickUpdate:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.model.url]
                                       options:@{}
                             completionHandler:^(BOOL success) {
                                 
                             }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *num = self.tableHeights[indexPath.row];
    return num.floatValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"AboutTableViewCell2";
    AboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = GetXibObject(@"AboutTableViewCell", 2);
    }

    cell.indexPath = indexPath;
    cell.versionContent = self.listData[indexPath.row];
    return cell;
}

- (void) setListData:(NSArray *)listData{
    _listData = listData;
    [self.uTableView reloadData];
}

@end
