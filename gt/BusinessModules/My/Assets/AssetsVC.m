//
//  AssetsVC.m


#import "AssetsVC.h"
#import "AssetsVM.h"
#import "AssetsCell.h"
@interface AssetsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIView * headerView;
@property (nonatomic, strong) UILabel *assetsLb;
@property (nonatomic, strong) UILabel *converLab;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AssetsVM* vm;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;
@end

@implementation AssetsVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id )requestParams
                   success:(DataBlock)block
{
    AssetsVC *vc = [[AssetsVC alloc] init];
    vc.successBlock = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:YES];
//    [rootVC presentViewController:vc animated:YES completion:^{
//    }];
    return vc;
}

#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件 
-(void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
//    [self locateTabBar:3];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//-(void)goBack{
//    [self dismissViewControllerAnimated:false completion:^{
//    }];
//    if (self.successBlock) {
//        self.successBlock(@1);
//    }
//}
-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资产";
    [self YBGeneral_baseConfig];
    [self initTableView];
    [self.tableView.mj_header beginRefreshing];
//    kWeakSelf(self);
//    [self.view goBackButtonInSuperView:self.view leftButtonEvent:^(id data) {
//        kStrongSelf(self);
//        [self goBack];
//    }];
}

- (void)requestListWithPage:(NSInteger)page{
    kWeakSelf(self);
    [self.vm network_getAssetsListWithPage:page WithExchangeType:ExchangeTypeAll success:^(id data, id data2) {
        kStrongSelf(self);
        [self requestListSuccessWithArray:data2 WithPage:page WithHeaderAssetsModel:data];
    } failed:^(id data) {
        kStrongSelf(self);
        [self requestListFailed];
    } error:^(id data) {
        [self requestListFailed];
    }];
}
#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page WithHeaderAssetsModel:(UserAssertModel*)model{
    self.currentPage = page;
    if (self.currentPage == 1) {
        [self.dataSources removeAllObjects];
    }
    if (array.count > 0) {
        [self.dataSources addObjectsFromArray:array];
        
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    [self initHeadViewWithHeaderAssetsModel:model];
}

- (void)requestListFailed {
    self.currentPage = 0;
    [self.dataSources removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void) initTableView{
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void) initHeadViewWithHeaderAssetsModel:(UserAssertModel*)model{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 280)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;

    UIView * baseView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 8, self.view.frame.size.width - 20, 130)];
    baseView1.layer.shadowColor = [UIColor blueColor].CGColor;
    baseView1.layer.shadowOpacity = 0.2f;
    baseView1.layer.shadowRadius = 4.f;
    baseView1.layer.shadowOffset = CGSizeMake(5,10);
    [self.headerView addSubview:baseView1];

    
    UIImageView * baseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 20, 130)];
    baseView.image = [UIImage imageNamed:@"user_property_bg"];
    baseView.layer.cornerRadius = 10;
    baseView.layer.masksToBounds = YES;
    [baseView1 addSubview:baseView];
    
    self.assetsLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, baseView.frame.size.width, 40)];
    
    self.assetsLb.attributedText = [NSString attributedStringWithString:@"" stringColor:kWhiteColor stringFont:kFontSize(14) subString:[NSString stringWithFormat:@"%@ BUB",[model.amount formatDecimalNumber]] subStringColor:kWhiteColor subStringFont:[UIFont fontWithName:@"SFU DIN" size:30] numInSubColor:kWhiteColor numInSubFont:kFontSize(37)];
    self.assetsLb.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:self.assetsLb];
    
    self.converLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, baseView.frame.size.width, 20)];
    self.converLab.text = [NSString stringWithFormat:@"折合人民币  %@¥",[model.amount formatDecimalNumber]] ;
    self.converLab.font = [UIFont systemFontOfSize:15];
    self.converLab.textColor = [UIColor whiteColor];
    self.converLab.textAlignment = NSTextAlignmentCenter;
    [baseView addSubview:self.converLab];
    
    UILabel * recordTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(baseView1.frame) + 20, self.view.frame.size.width, 23)];
    recordTitleLb.text = @"资产变更记录";
    recordTitleLb.font = [UIFont systemFontOfSize:18];
    recordTitleLb.textAlignment =NSTextAlignmentCenter;
    [self.headerView addSubview:recordTitleLb];
    
    NSArray * titleArr = @[@"可用",@"交易中"];
    NSArray * accountArr = @[model.usableFund,model.frozenFund];
    for (int i = 0; i < 2; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width/2, CGRectGetMaxY(recordTitleLb.frame) + 20, self.view.frame.size.width/2, 26)];
        label.text = titleArr[i];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:label];
        
        UILabel * accountLb= [[UILabel alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width/2, CGRectGetMaxY(label.frame) + 10, self.view.frame.size.width/2, 26)];
        accountLb.text = accountArr[i];
        accountLb.font = [UIFont systemFontOfSize:18];
        accountLb.textAlignment = NSTextAlignmentCenter;
        [self.headerView addSubview:accountLb];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width/2 - 2, CGRectGetMaxY(label.frame) - 10, 2, 30)];
        lineView.backgroundColor = [UIColor colorWithRed:246.0/256 green:245.0/256 blue:250.0/256 alpha:1];
        [self.headerView addSubview:lineView];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [AssetsCell cellHeightWithModel];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AssetsData* data = _dataSources[indexPath.row];
    AssetsCell* cell =[AssetsCell cellWith:tableView];
    [cell richElementsInCellWithModel:data];
    return cell;
}
#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        //        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        
        
        kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 1;
            [self  requestListWithPage:self.currentPage];
        }
        footer:^{
            kStrongSelf(self);
            ++self.currentPage;
            [self requestListWithPage:self.currentPage];
        }
         ];
    }
    return _tableView;
}

- (NSUInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}

- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (AssetsVM *)vm {
    if (!_vm) {
        _vm = [AssetsVM new];
    }
    return _vm;
}
@end
