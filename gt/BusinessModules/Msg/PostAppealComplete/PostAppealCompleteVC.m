//
//  PostAppealCompleteVC.m
//  gt
//
//  Created by 鱼饼 on 2019/4/25.
//  Copyright © 2019 GT. All rights reserved.
//

#import "PostAppealCompleteVC.h"
#import "PostAppealCompleteVM.h"
#import "PostAppealCompleteModel.h"
#import "PostAppealComleteView.h"
#import "AboutUsModel.h"
#import "LoginVM.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "AccountVC.h"




@interface PostAppealCompleteVC ()
@property(nonatomic,strong)id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) PostAppealComleteView *mainView;
@property (nonatomic, strong) AboutUsModel* customerServiceModel;
@property (nonatomic, strong) MWPhotoBrowser *potoBrowesr;
@end

@implementation PostAppealCompleteVC

+ (instancetype)pushViewController:(UIViewController *)rootVC
                     requestParams:(id)requestParams
                           success:(DataBlock)block{
    PostAppealCompleteVC *vc = [[PostAppealCompleteVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc
                                           animated:YES];
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    kWeakSelf(self);
    [PostAppealCompleteVM getPostAppealCompleteDataWithRequestParams:self.requestParams success:^(id data) {
        [weakself layoutView:data];
    } failed:^(id data) {} error:^(id data) {}];
    [self getcustomerServiceModelData];
}

-(void)getcustomerServiceModelData{
    
    LoginVM *vm = [[LoginVM alloc] init];
    [vm network_helpCentreWithRequestParams:@1 success:^(id data) {
        self.customerServiceModel = data;
    } failed:^(id data) {} error:^(id data) {}];
    [SVProgressHUD dismiss];
    
}

-(void)initView{
    kWeakSelf(self);
    self.mainView = [[PostAppealComleteView alloc] initWithBlockSuccess:^(NSInteger types, id data2) {
        switch (types) {
            case custServiceType:
            {
                [self pushCustomerService];
            } break;
            case examImageType:
            {
                PostAppealCompleteModel *mo = (PostAppealCompleteModel*)data2;
                [self seeImage:mo.data];
            } break;
            case contentType:
            {
                [AccountVC pushFromVC:weakself
                                         requestParams:@1
                                               success:^(id data) {}];
            } break;
            default:
                break;
        }
    }];
    [self.view addSubview:self.mainView];
}


-(void)layoutView:(PostAppealCompleteModel*)model{
    
    [self.mainView layoutView:model];

}

-(void)seeImage:(NSArray*)imageAr{
    if (imageAr && imageAr.count > 0) {
        NSDictionary *dic = imageAr[0];
         NSString *urlS = dic[@"voucherUrl"];
        if (urlS && urlS.length > 1) {
            MWPhoto *po = [MWPhoto photoWithURL:[NSURL URLWithString:urlS]];
            NSArray *ar = @[po];
            _potoBrowesr = [[MWPhotoBrowser alloc] initWithPhotos:ar];
            _potoBrowesr.displayActionButton = NO;
            [self.navigationController pushViewController:_potoBrowesr animated:YES];
            
            [self performSelector:@selector(toChengColer) withObject:nil afterDelay:0.3];
        }
    }
}

-(void)toChengColer{
    if (_potoBrowesr) {
        _potoBrowesr.navigationController.navigationBar.barTintColor = kWhiteColor;
         [YBSystemTool modifyNavigationBarWith:_potoBrowesr.navigationController];
    }
}

-(void)pushCustomerService{
    if (self.customerServiceModel !=nil) {
        NSString *sessionId = [NSString stringWithFormat:@"%@",self.customerServiceModel.rongCloudId];
        NSString *title = [NSString stringWithFormat:@"%@",self.customerServiceModel.rongCloudName];
        RCDCustomerServiceViewController *chatService = [[RCDCustomerServiceViewController alloc] init];
        chatService.conversationType = ConversationType_CUSTOMERSERVICE;
        chatService.targetId = sessionId;
        chatService.title = title;
        [self.navigationController pushViewController :chatService animated:YES];
    }else{
        [SVProgressHUD showWithStatus:@"获取客服信息失败" maskType:SVProgressHUDMaskTypeBlack];
    }
}

@end
