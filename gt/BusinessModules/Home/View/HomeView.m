
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "HomeView.h"
#import "HomeInfoTableViewCell.h"
#import "BaseCell.h"
#import "HomeSectionHeaderView.h"
#import "HomeVM.h"
#import "HomeHeaderView.h"

@interface HomeView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView * networkErrorView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, assign) CFAbsoluteTime start;  //刷新数据时的时间
@property (nonatomic, copy) TwoDataBlock block;
@property (nonatomic, strong) UIImageView *headerBackIm;
@property (nonatomic, strong) HomeHeaderView *headerV;

//@property (nonatomic, strong) UILabel *accLab;
//@property (nonatomic, strong) UIButton *msgBtn;
//@property (nonatomic, strong) UIButton *scanBtn;



@end

@implementation HomeView

#pragma mark - life cycle
-(UIImageView*)headerBackIm{
    if (_headerBackIm == nil) {
        _headerBackIm = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 210*SCALING_RATIO +nabarHit)];
        _headerBackIm.image = kIMG(@"home_top_img");
        [_headerBackIm setContentMode:UIViewContentModeScaleAspectFill];
        _headerBackIm.userInteractionEnabled = YES;
        _headerBackIm.clipsToBounds = YES;
    } return _headerBackIm;
}

- (void)clickBtn:(UIButton*)sender{
    if (self.block) {
        self.block(@(sender.tag),sender);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headerBackIm];
        self.backgroundColor = HEXCOLOR(0xf5f5f5);
        [self initViews];
        //监听程序进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    //    [_tableView reloadData];
}

- (void)initViews {
    
    
    UILabel *_accLab = [[UILabel alloc]init];
    _accLab.text = @"BUB钱包";
    _accLab.textAlignment = NSTextAlignmentCenter;
    _accLab.font = kFontSize(20);
    _accLab.textColor = HEXCOLOR(0xffffff);
    [self addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        //       make.top.equalTo(self.decorIv).offset(33);
        make.top.equalTo(self).offset([YBSystemTool isIphoneX]?(24+33)*SCALING_RATIO:31*SCALING_RATIO);
        //        make.height.equalTo(@20);
    }];
    
    UIButton *_msgBtn = [[UIButton alloc]init];
    [self addSubview:_msgBtn];
    [_msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_accLab.mas_centerY);
        make.leading.offset(20);
        make.width.mas_equalTo(100);
    }];
    
    
    
    _msgBtn.tag = EnumActionTag6;
    _msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _msgBtn.adjustsImageWhenHighlighted = NO;
    [_msgBtn setImage:[UIImage imageNamed:@"icon_remind"] forState:UIControlStateNormal];
    [_msgBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *_scanBtn = [[UIButton alloc]init];
    [self addSubview:_scanBtn];
    [_scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_accLab.mas_centerY);
        make.trailing.offset(-20);
        make.width.mas_equalTo(100);
    }];
    _scanBtn.tag = EnumActionTag7;
    _scanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _scanBtn.adjustsImageWhenHighlighted = NO;
    [_scanBtn setImage:[UIImage imageNamed:@"icon_scan"] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.tableView];
    kWeakSelf(self);
    self.networkErrorView = [self setNetworkErrorViewInSuperView:self leftButtonEvent:^(id data) {
        kStrongSelf(self);
        if (self.block) {
            self.block(@(EnumActionTag11), @"");
        }
    }];
    self.headerV = [[HomeHeaderView alloc] initViewBlock:^(id data, id data2) {
        if (self.block) {
            self.block(data, data2);
        }
    }];
    self.headerV.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, headHit);
    self.tableView.tableHeaderView = self.headerV;
}


-(NSDictionary*)findDataWithType:(IndexSectionType)typ{
    NSDictionary *rDic = nil;
    for (NSDictionary*dic in _sections) {
        NSInteger ti = [dic[kIndexSection] integerValue];
        if (ti == typ) {
            rDic = dic;
            break;
        }
    }
    return rDic;
}

-(void)relaodTableHearderData{
    NSDictionary *dic = [self findDataWithType:IndexSectionZero];
    if (dic) {
        [self.headerV richElementsInCellWithModel:dic[kIndexRow][0]];
    }
}

#pragma mark - public
- (void)requestHomeListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page{
    self.networkErrorView.hidden = YES;
    self.currentPage = page;
    if (self.currentPage == 1) {
        [self.sections removeAllObjects];
        [self.tableView reloadData];
        [self relaodTableHearderData];
    }
    if (array.count > 0) {
        [self.sections addObjectsFromArray:array];
        [self.tableView reloadData];
        [self relaodTableHearderData];
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)requestHomeListFailed {
    self.currentPage = 0;
    [self.sections removeAllObjects];
    [self.tableView reloadData];
    [self relaodTableHearderData];
    self.networkErrorView.hidden = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = [self findDataWithType:IndexSectionTwo];
    if (dic) {
        return  [dic[kIndexRow] count];
    }
    return 0;
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45*SCALING_RATIO;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 45*SCALING_RATIO)];
    v.backgroundColor = kWhiteColor;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5*SCALING_RATIO, 150, 45*SCALING_RATIO)];
    titleLab.textColor = HEXCOLOR(0x333333);
    titleLab.text = @"行情列表";
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                    size:15];
    [v addSubview:titleLab];
    return v;
}


#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    WS(weakSelf);
    NSDictionary *dic = [self findDataWithType:IndexSectionTwo];
    HomeInfoTableViewCell *cell = [HomeInfoTableViewCell cellWith:tableView];
    HomeData* data = dic[kIndexRow][indexPath.row];
    [cell richElementsInCellWithModel:data];
    return cell;
}
-(void)actionBlock:(TwoDataBlock)block{
    self.block = block;
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self findDataWithType:IndexSectionTwo];
    return  [HomeInfoTableViewCell cellHeightWithModel:dic[kIndexRow][indexPath.row]];
}
// XiRan 去掉cell击事件
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSDictionary *dic = [self findDataWithType:IndexSectionTwo];    if (self.block) {
//        self.block(@(EnumActionTag4),dic[kIndexRow][indexPath.row]);
//    }
//}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        float barHi = [UIApplication sharedApplication].statusBarFrame.size.height;
        barHi = YBSystemTool.isIphoneX? barHi + 40: barHi+ 30;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, nabarHit, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-nabarHit-barHi) style:UITableViewStyleGrouped];
        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        
        [HomeSectionHeaderView sectionHeaderViewWith:_tableView];
        kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 1;
            [self.delegate homeView:self requestHomeListWithPage:self.currentPage];
        }];
    }
    return _tableView;
}

- (NSUInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset  = scrollView.contentOffset.y;
//    NSLog(@"--- %f",yOffset);
    if (yOffset<0) {
        self.headerBackIm.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 210*SCALING_RATIO +nabarHit - yOffset);
    }else{
        if (yOffset> 210*SCALING_RATIO) {
            yOffset = 210*SCALING_RATIO;
        }
        self.headerBackIm.frame = CGRectMake(0, -yOffset, MAINSCREEN_WIDTH, 210*SCALING_RATIO +nabarHit);
    }
}
@end

