//
//  PostAdsVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PostAppealVC.h"
#import "PostAppealView.h"
#import "PostAppealVM.h"
#import "OrderDetailModel.h"
#import "PostAppealPhotoCell.h"
#import "MWPhoto.h"
#import "PhotoDeleteTipPopUpView.h"
#import "AliyunQuery.h"
#import "LoginVM.h"
#import "AboutUsModel.h"


@interface PostAppealVC () <PostAppealViewDelegate,MWPhotoBrowserDelegate>
@property (nonatomic, strong) MWPhotoBrowser *potoBrowesr;
@property (nonatomic, strong) PostAppealView *mainView;
@property (nonatomic, strong) PostAppealVM *postAppealVM;
@property (nonatomic, strong) OrderDetailModel *orderDetailModel;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong)NSMutableArray *dataMutArr;
@property (nonatomic, assign)OrderType orderType;
@property (nonatomic, strong) UIButton *chooseImageButton;
@property (nonatomic, strong)LeePhotoOrAlbumImagePicker *pickerController;
@property (nonatomic, strong) AboutUsModel* customerServiceModel;
@property (nonatomic, assign) BOOL isantiAppeal;
@property (nonatomic, strong) NSString *reason;
@end

@implementation PostAppealVC

#pragma mark - life cycle
+ (instancetype)pushViewController:( UIViewController * _Nullable )rootVC
                     requestParams:(id)requestParams
                         orderType:(OrderType)orderType
                      isAntiAppeal:(BOOL)antiAppeal
                            reason:(NSString*)reason
                           success:(DataBlock)block{
    
    PostAppealVC *vc = [[PostAppealVC alloc] init];
    
    vc.block = block;
    
    vc.orderType = orderType;
    vc.isantiAppeal = antiAppeal;
    vc.reason = reason;
    vc.requestParams = requestParams;
    
    [rootVC.navigationController pushViewController:vc
                                           animated:YES];
    return vc;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    
    self.title = @"提交申诉";
    
    [self initView];
    [self getcustomerServiceModelData];

}

-(void)getcustomerServiceModelData{
    
    LoginVM *vm = [[LoginVM alloc] init];
    [vm network_helpCentreWithRequestParams:@1 success:^(id data) {
        self.customerServiceModel = data;

    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
    [SVProgressHUD dismiss];
    
}


- (void)initView {
    
    [self.view addSubview:self.mainView];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    [self postAppealView:self.mainView requestListWithPage:1];
    kWeakSelf(self);
    
    [self.mainView actionBlock:^(id data, id data2) {
        
        kStrongSelf(self);
        
        EnumActionTag btnType  = [data integerValue];
        
        switch (btnType) {
            case EnumActionTag0:{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case EnumActionTag1:{
                
                NSArray *dataAr =  (NSArray*)data2;
                NSMutableArray *dataMutableAr = [NSMutableArray arrayWithArray:dataAr];
                [dataMutableAr addObject:(NSString*)self.requestParams];
                
                UIImage *im = [self.chooseImageButton imageForState:UIControlStateNormal];
                if (im  == kIMG(@"tianjiaX")) {
                    [self submitAppeal:dataMutableAr];
                }else{
                    [self upDataAliyun:im andData:dataMutableAr];
                }
                
            }
                break;
            case EnumActionTag2:{
                UIButton *button = (UIButton*)data2;
                [self photo:button];
            }
                break;
            case EnumActionTag3:{
                if (self.customerServiceModel !=nil) {
                    NSString *sessionId = [NSString stringWithFormat:@"%@",self.customerServiceModel.rongCloudId];
                    NSString *title = [NSString stringWithFormat:@"%@",self.customerServiceModel.rongCloudName];
                    [RongCloudManager updateNickName:title userId:sessionId];
                    [RongCloudManager jumpNewSessionWithSessionId:sessionId title:title navigationVC:self.navigationController];
                }else{
                     [SVProgressHUD showWithStatus:@"获取客服信息失败" maskType:SVProgressHUDMaskTypeBlack];
                }
            }
                break;
            default:
                
                break;
        }
    }];
}

-(void)upDataAliyun:(UIImage*)im andData:(id)data{
    [SVProgressHUD showWithStatus:@"图片上传中..." maskType:SVProgressHUDMaskTypeBlack];
    [AliyunQuery uploadImageToAlyun:im title:@"appeal" completion:^(NSString *imgUrl) {
        [NSThread sleepForTimeInterval:1.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (self && ![NSString isEmpty:imgUrl]) {
//                 NSLog(@"UPLOAD SUCCESS index:%ld ----- %@", self.uploadIndex, imgUrl);
                NSArray *dataAr =  (NSArray*)data;
                NSMutableArray *ar = [NSMutableArray arrayWithArray:dataAr];
                [ar addObject:imgUrl];
                [self submitAppeal:ar];
                [SVProgressHUD dismiss];
                
//
//                [self dealWithUploadFile:imgUrl needUploadImage:needUploadImage index:index];
            } else {
                [SVProgressHUD showErrorWithStatus:@"上传凭证图片失败,请稍后再试"];
            }
        });
    }];
}



- (void)submitAppeal:(id)data{
   
    if (self.isantiAppeal) { // 反申诉
        
        NSString * appealID = self.requestParams;
        if (appealID == nil) {
            [YKToastView showToastText:@"参数有误，请重新加载页面"];
            return;
        }
        [PostAppealVM postAntiAppealWithRequestParams:appealID andData:data success:^(id data) {
            [SVProgressHUD dismiss];
             if (self.block) {
              self.block(nil);
             }
            [self.navigationController popViewControllerAnimated:YES];
        } failed:^(id data) {} error:^(id data) {
            [SVProgressHUD dismiss];
        }];

    }else{
        [self.postAppealVM network_submitAppealWithRequestParams:data
                                                         success:^(id data) {
                                                             if (self.block) {
                                                                 self.block(nil);
                                                             }
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         } failed:^(id data) { } error:^(id data) {}];
    }
}

-(void)photo:(UIButton*)button{
    
    
    self.chooseImageButton = button;
    UIImage *im = [button imageForState:UIControlStateNormal];
    if (im  == kIMG(@"tianjiaX")) {
        // 没有图片
        self.pickerController = [[LeePhotoOrAlbumImagePicker alloc]init];
        //    kWeakSelf(self);
        [self.pickerController getPhotoAlbumOrTakeAPhotoWithController:self
                                                            photoBlock:^(UIImage *img) {
//                                                                NSLog(@"%@",img);
                                                                [button setImage:img forState:UIControlStateNormal ];
                                                            }];
    }else{
        
        NSArray *potoAr = @[[MWPhoto photoWithImage:im]];
        self.potoBrowesr = [[MWPhotoBrowser alloc] initWithPhotos:potoAr];
        self.potoBrowesr.displayActionButton = NO;
        self.potoBrowesr.title = @"提交申诉";
        [self.navigationController pushViewController:_potoBrowesr animated:YES];
        
        UIButton *detele = [[UIButton alloc]init];
        [detele setImage:[UIImage imageNamed:@"shanchuX"] forState:UIControlStateNormal];
        [self.potoBrowesr.view addSubview:detele];
        [detele mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.equalTo(self.potoBrowesr.view.mas_bottom).offset(-26);
        }];
        [detele addTarget:self
                          action:@selector(deteleClickItem)
                forControlEvents:UIControlEventTouchUpInside];
        [self performSelector:@selector(toChengColer) withObject:nil afterDelay:0.3];
    }
}

-(void)toChengColer{
    if (self.potoBrowesr) {
        self.potoBrowesr.title = @"提交申诉";
        self.potoBrowesr.navigationController.navigationBar.barTintColor = kWhiteColor;
         [YBSystemTool modifyNavigationBarWith:_potoBrowesr.navigationController];
    }
}


-(void)deteleClickItem{
    
    PhotoDeleteTipPopUpView* popupView = [[PhotoDeleteTipPopUpView alloc]init];
    [popupView showInApplicationKeyWindow];
    [popupView richElementsInViewWithModel:@"确定删除该照片?"];
    [popupView actionBlock:^(id data) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.chooseImageButton setImage:kIMG(@"tianjiaX") forState:UIControlStateNormal];
    }];
}

#pragma mark - HomeViewDelegate

- (void)postAppealView:(PostAppealView *)view requestListWithPage:(NSInteger)page {

    
    kWeakSelf(self);
    
    [self.postAppealVM network_getPostAppealListWithPage:page
                                       WithRequestParams:self.requestParams
                                               orderType:self.orderType
                                                 success:^(NSArray * _Nonnull dataArray) {
                                                     kStrongSelf(self);
                                                     [self.mainView requestListSuccessWithArray:dataArray andIsAntiAppeal:self.isantiAppeal andResonString:self.reason];
                                                 } failed:^{
                                                     kStrongSelf(self);
                                                     [self.mainView requestListFailed];
                                                 }];
}

#pragma mark - lazyLoad

- (PostAppealView *)mainView {
    
    if (!_mainView) {
        
        _mainView = [[PostAppealView alloc]initWithFrame:CGRectZero
                                           requestParams:self.requestParams];
        
        _mainView.delegate = self;
    }
    
    return _mainView;
}

- (PostAppealVM *)postAppealVM {
    
    if (!_postAppealVM) {
        
        _postAppealVM = [PostAppealVM new];
    }
    return _postAppealVM;
}

-(NSMutableArray *)dataMutArr{
    
    if (!_dataMutArr) {
        
        _dataMutArr = NSMutableArray.array;
    }
    
    return _dataMutArr;
}

@end
