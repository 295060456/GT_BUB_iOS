//
//  OtherFogetGetPwView.m
//  gt
//
//  Created by 鱼饼 on 2019/5/11.
//  Copyright © 2019 GT. All rights reserved.
//

#import "OtherFogetGetPwView.h"
#import "OtherFogetGetPwCell.h"


@interface OtherFogetGetPwView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) DataTypeBlock block;
@property (nonatomic, strong) NSArray *dataAr;
@end



@implementation OtherFogetGetPwView

-(instancetype)initOtherFogetTitle:(NSString*)title andDataAr:(NSArray*)dataAr viewWithBolck:(DataTypeBlock)block{
    self = [super init];
    if (self) {
        self.block = block;
        self.frame = CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH,MAINSCREEN_HEIGHT);
        self.backgroundColor = COLOR_HEX(0x000000, 0.5);
        self.dataAr = dataAr;
        float hi = [YBSystemTool isIphoneX]? 20 : 0;
        hi = hi + 226* SCALING_RATIO;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - hi, MAINSCREEN_WIDTH, hi) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = kWhiteColor;
        [tableView registerClass:[OtherFogetGetPwCell class] forCellReuseIdentifier:@"OtherFogetGetPwCell"];
        [self addSubview:tableView];
        
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 45*SCALING_RATIO)];
        headerView.backgroundColor = kWhiteColor;
        tableView.tableHeaderView = headerView;
        UILabel *headerLa = [[UILabel alloc] initWithFrame:CGRectMake(20*SCALING_RATIO, 0, 200*SCALING_RATIO, 44*SCALING_RATIO)];
        headerLa.userInteractionEnabled = YES;
        headerLa.backgroundColor = kWhiteColor;
        headerLa.textColor = HEXCOLOR(0x333333);
//        headerLa.font = kFontSize(15);
        headerLa.text = title;
        [headerLa setFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:15*SCALING_RATIO]];
        [headerView addSubview:headerLa];
        
        UILabel *qx = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH -50*SCALING_RATIO , 0, 50*SCALING_RATIO, 44*SCALING_RATIO)];
        qx.userInteractionEnabled = YES;
        qx.backgroundColor = kWhiteColor;
        qx.textColor = HEXCOLOR(0x9a9a9a);
        qx.font = kFontSize(15*SCALING_RATIO);
        qx.text = @"取消";
        [headerView addSubview:qx];
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removSelf)];
        [qx addGestureRecognizer:ta];
        
        UIView *lin = [[UIView alloc] initWithFrame:CGRectMake(20*SCALING_RATIO, 44*SCALING_RATIO, MAINSCREEN_WIDTH - 40*SCALING_RATIO, 1)];
        lin.backgroundColor = HEXCOLOR(0xdddddd);
        [headerView addSubview:lin];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH,MAINSCREEN_HEIGHT);
        }];
        
    } return self;
}


#pragma mark tableView DataSource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 59*SCALING_RATIO;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherFogetGetPwCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherFogetGetPwCell" forIndexPath:indexPath];
    cell.dateLabel.text = self.dataAr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) {
        self.block(indexPath.row, nil);
    }
    [self removSelf];
}

-(void)removSelf{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH,MAINSCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
