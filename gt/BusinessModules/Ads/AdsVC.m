//
//  AdsVC.m
//  gtp
//
//  Created by GT on 2018/12/19.
//  Copyright © 2018 GT. All rights reserved.
//

#import "AdsVC.h"
#import "TabScrollview.h"
#import "TabContentView.h"

#import "PageVC.h"
#import "XcPostAdsVC.h"
#import "InputPWPopUpView.h"
#import "PageVM.h"
#import "ModifyAdsModel.h"
#import "ModifyAdsVC.h"

#import "LoginModel.h"
#import "IdentityAuthVC.h"
#import "AdsAlertActionView.h"
#import "HomeModel.h"
#import "AssetsVM.h"
#import "XcSecuritySettingsVC.h"


#define titleHeirht 35


@interface AdsVC ()<UITextFieldDelegate>
@property (nonatomic,strong)TabScrollview *tabScrollView;
@property (nonatomic,strong)TabContentView *tabContent;
@property (nonatomic, strong) UIButton * editAdsBtn;
@property (nonatomic,strong)NSMutableArray *tabs;
@property (nonatomic, strong) PageVM *vm;
@property (nonatomic,strong)NSMutableArray *contents;
@property (nonatomic,strong)UITextField * tf1;
@end

@implementation AdsVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    AdsVC *vc = [[AdsVC alloc] init];
//    singLeton.headerHit = 35;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //}
    //-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
    //{
    if (textField == self.tf1) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 9)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"我的广告";
    NSArray* titles = @[@{@"全部":@"0"},
                        @{@"出售中":@"1"},
                        @{@"售罄":@"3"},
                        @{@"已下架":@"2"}
                        ];
    
    _tabs=[[NSMutableArray alloc]initWithCapacity:titles.count];
    _contents=[[NSMutableArray alloc]initWithCapacity:titles.count];
    
    kWeakSelf(self);
    for(int i=0;i<titles.count;i++){
        NSDictionary *dic=titles[i];
        
        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.font = kFontMediumSize(15);
        tab.text = dic.allKeys[0];
        tab.textColor=RGBCOLOR(51, 51, 51);
        [_tabs addObject:tab];
        
        PageVC *con=[PageVC new];
        
        con.view.backgroundColor= RANDOMRGBCOLOR;
        con.tag = dic.allValues[0];
        [_contents addObject:con];
        __weak typeof(con) weakCon = con;
        [con actionBlock:^(id data, id data2,UIView* view,UITableView* tableView,NSMutableArray *dataSource,NSIndexPath* indexPath) {
            kStrongSelf(self);
            EnumActionTag sec = [data integerValue];
            ModifyAdsModel* model = data2;
            switch (sec) {
                case EnumActionTag0:
                {
                    [XcPostAdsVC pushFromVC:self requestParams:model success:^(id data) {
                        
                    }];
                }
                    break;
                case EnumActionTag1:
                {
                    [self getAssetBalance:model andPageVC:weakCon pageListView:view];
                    
                }
                    break;
                case EnumActionTag2:
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认要下架吗？" message:nil preferredStyle:  UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
                        [popupView showInApplicationKeyWindow];
                        [popupView actionBlock:^(id data) {
                            
                            [self.vm network_outlineAdRequestParams:data withAdID:model.ugOtcAdvertId success:^(id data) {
                                
                                [tableView beginUpdates];
                                [dataSource removeObjectAtIndex:indexPath.section];
                                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationLeft];
                                [weakCon pageListView:(PageListView *)view requestListWithPage:1];
                                [tableView reloadData];
                                [tableView endUpdates];
                                //                                [YKToastView showToastText:@"下架成功"];
                                
                            } failed:^(id data) {
                                
                            } error:^(id data) {
                                
                            }];
                            
                            
                            
                        }];
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:true completion:nil];
                }
                    break;
                case EnumActionTag3:
                {
                    [ModifyAdsVC pushFromVC:self
                                   withAdId:model.ugOtcAdvertId success:^(id data) {
                                       
                                   }];
                }
                    break;
                default:
                    break;
            }
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
    [_tabScrollView configParameter:horizontal viewArr:_tabs tabWidth:[UIScreen mainScreen].bounds.size.width/titles.count tabHeight:titleHeirht index:0 block:^(NSInteger index) {
        
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
    
    
    [_tabContent configParam:_contents Index:0 block:^(NSInteger index) {
        [weakSelf.tabScrollView updateTagLine:index];
    }];
    
    _editAdsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _editAdsBtn.tag = IndexSectionFour;
    [_editAdsBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    //    _editAdsBtn.backgroundColor = kGrayColor;
    [_editAdsBtn setImage:[UIImage imageNamed:@"editAds"] forState:UIControlStateNormal];
    _editAdsBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:self.editAdsBtn];
    [self.editAdsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-11);
        make.bottom.equalTo(self.view).offset(-70);
        make.width.height.equalTo(@54);
    }];
    
    return;
    //    [_tabContent actionBlock:^(id data) {
    //
    //        CATransition* transition = [CATransition animation];
    //        transition.duration = .3;
    //        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //        transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    //        [self.navigationController.view.layer addAnimation:transition forKey:nil];
    //        [[self navigationController] popViewControllerAnimated:NO];
    //
    //        //            [self.navigationController popViewControllerAnimated:YES];
    //
    //    }];
}

- (void)clickItem:(UIButton*)button{
    [XcPostAdsVC pushFromVC:self requestParams:nil success:^(id data) {}];
}

-(void)getAssetBalance:(ModifyAdsModel*)model andPageVC:(PageVC*)con pageListView:(UIView *)view {
    
    [SVProgressHUD showWithStatus:@""];
    kWeakSelf(self);
    [[[AssetsVM alloc] init] network_getUserAssertSuccess:^(id data) {
        if (data) {
            kStrongSelf(self);
            UserAssertModel* mo = data;
            model.usableFund = mo.usableFund;
            AdsAlertActionView *v = [[AdsAlertActionView alloc] initWitModle:model hBlock:^(id data1) {
                if (data1) {
                    self.tf1 = data1;
                    self.tf1.delegate =self;
                    InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
                    [popupView showInApplicationKeyWindow];
                    [popupView actionBlock:^(id data) {
                        [self.vm network_onlineAdRequestParams:data withAdID:model.ugOtcAdvertId withNumber:self.tf1.text success:^(id data) {
                            [con pageListView:(PageListView *)view requestListWithPage:1];
                        } failed:^(id data) {
                        } error:^(id data) {
                        }];
                    }];
                }
            }];
            [kAPPDelegate.window addSubview:v];
        }else{
            [YKToastView showToastText:@"获取固定资产失败"];
        }
        [SVProgressHUD dismiss];
    } failed:^(id data) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:@"获取固定资产失败"];
    } error:^(id data) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:@"获取固定资产失败"];
    }];
}

- (PageVM *)vm {
    if (!_vm) {
        _vm = [PageVM new];
    }
    return _vm;
}

@end

