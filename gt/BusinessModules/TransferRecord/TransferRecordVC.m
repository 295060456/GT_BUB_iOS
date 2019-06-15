//
//  AdsVC.m
//  gtp
//
//  Created by GT on 2018/12/19.
//  Copyright © 2018 GT. All rights reserved.
//

#import "TransferRecordVC.h"
#import "TabScrollview.h"
#import "TabContentView.h"

#import "TRPageVC.h"
#import "TransferDetailVC.h"
#import "TRPageModel.h"

#define titleHeirht 35


@interface TransferRecordVC ()
@property (nonatomic,strong)TabScrollview *tabScrollView;
@property (nonatomic,strong)TabContentView *tabContent;
@property (nonatomic, strong) UIButton * editAdsBtn;
@property (nonatomic,strong)NSMutableArray *tabs;
@property (nonatomic,assign)NSInteger locateIndex;
@property (nonatomic,strong)NSMutableArray *contents;
@end

@implementation TransferRecordVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
   
    TransferRecordVC *vc = [[TransferRecordVC alloc] init];
    vc.locateIndex = 0;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC locateIndex:(NSInteger)locateIndex
{
    TransferRecordVC *vc = [[TransferRecordVC alloc] init];
    vc.locateIndex = locateIndex;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
//     singLeton.headerHit = 35;
    self.title = @"转账记录";
    NSArray* titles = @[@"全部",@"转入",@"转出"];
    _tabs=[[NSMutableArray alloc]initWithCapacity:titles.count];
    _contents=[[NSMutableArray alloc]initWithCapacity:titles.count];
    

    for(int i=0;i<titles.count;i++){
        NSString *titleStr=titles[i];
        
        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.font = kFontSize(14);
        tab.text=titleStr;
        tab.textColor=[UIColor blackColor];
        [_tabs addObject:tab];
            
        TRPageVC *con=[TRPageVC new];
        
        con.view.backgroundColor= RANDOMRGBCOLOR;
        con.tag= [NSString stringWithFormat:@"%d",i
                  ];
        [_contents addObject:con];
        kWeakSelf(self);
        [con actionBlock:^(id data) {
            TRPageData* itemData = data;
            [TransferDetailVC pushViewController:weakself requestParams:itemData.transferRecordId success:^(id data) {
                
            }];
        }];
        
    }
    
    _tabScrollView=[[TabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabScrollView];
    [_tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(titleHeirht);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    
    WS(weakSelf);
    [_tabScrollView configParameter:horizontal viewArr:_tabs tabWidth:[UIScreen mainScreen].bounds.size.width/titles.count tabHeight:titleHeirht index:self.locateIndex block:^(NSInteger index) {
        
        [weakSelf.tabContent updateTab:index];
    }];
    
    
    _tabContent=[[TabContentView alloc]initWithFrame:CGRectZero];
    _tabContent.userInteractionEnabled = YES;
    [self.view addSubview:_tabContent];
    
    [_tabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(weakSelf.tabScrollView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    
    [_tabContent configParam:_contents Index:self.locateIndex block:^(NSInteger index) {
        [weakSelf.tabScrollView updateTagLine:index];
    }];
    
    return;
    [_tabContent actionBlock:^(id data) {
        CATransition* transition = [CATransition animation];
        transition.duration = .3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] popViewControllerAnimated:NO];
    }];
   
}

@end
