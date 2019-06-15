//
//  PageViewController.m
//  TestTabTitle
//
//  Created by Aalto on 2018/12/20..
//  Copyright © 2018年 Aalto. All rights reserved.
//

#import "IdentityAuthVC.h"
#import "IdentityAuthView.h"
#import "LoginVM.h"
#import "IdentityInfoVC.h"
#import "ApplyAuthVC.h"
#import "AboutUsModel.h"
//#import "SettingPasswordVC.h"

//// 活体认证
#import "FaceIDMegNetwork.h"
#if TARGET_IPHONE_SIMULATOR
// NSLog(@"模拟器不做高级认证处理");
#else /* if TARGET_IPHONE_SIMULATOR */
#import <MGFaceIDDetect/MGFaceIDDetect.h>
#endif


@interface IdentityAuthVC ()<IdentityAuthViewDelegate>
@property (nonatomic, strong) IdentityAuthView *mainView;
@property (nonatomic, strong) LoginVM *vm;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, strong) LoginModel* loginModel;
@property (nonatomic,strong) AboutUsModel* aboutUsModel;
@property (nonatomic, copy) NSString* contact;
@property (nonatomic, copy) DataBlock successBlock;

// 活体认证
@property (nonatomic ,strong) UIView  *facelIDCertificationView;
@property (nonatomic, strong) UISegmentedControl* liveTypeSegC;

@end

@implementation IdentityAuthVC


+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block
{
    IdentityAuthVC *vc = [[IdentityAuthVC alloc] init];
    vc.requestParams =requestParams;
    vc.successBlock = block;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.facelIDCertificationView removeFromSuperview];
    [self identityAuthView:self.mainView requestListWithPage:1];
}


-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    //    self.title = @"身份认证";
    
    [self initView];
    kWeakSelf(self);
    [self.vm network_helpCentreWithRequestParams:@{} success:^(id data) {
        kStrongSelf(self);
        self.aboutUsModel = data;
        self.contact = [NSString stringWithFormat:@"%@",self.aboutUsModel.qq];
        
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
    [self identityAuthView:self.mainView requestListWithPage:1];
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)initView {
    
    
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    kWeakSelf(self);
    [self.mainView actionBlock: ^(id data) {
        
        IndexSectionType tag = [data[kIndexSection] intValue];
        kStrongSelf(self);
        switch (tag) {
            case IndexSectionZero:
            {
                IdentityAuthType type = [data[kType] intValue];
                if (type ==IdentityAuthTypeFinished) {
                    return ;
                }
                else if (type ==IdentityAuthTypeHandling){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您的信息已提交，审核中...\n\n如有任何疑问请联系客服：%@",self.contact] message:nil preferredStyle:  UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (self.block) {
                            self.block(data);
                        }
                    }]];
                    [self presentViewController:alert animated:true completion:nil];
                }
                else{
                    [IdentityInfoVC pushFromVC:self requestParams:@1 success:^(id data) {}];
                }
            }
                break;
            case IndexSectionOne:
            {
                SeniorAuthType type = [data[kType] intValue];
                if (type ==SeniorAuthTypeFinished) {
                    return ;
                }else if (type ==SeniorAuthTypeUndone){
                    if (self.loginModel!=nil&&[self.loginModel.userinfo.valiidnumber intValue]!= IdentityAuthTypeFinished) {
                        [YKToastView showToastText:@"请先实名认证"];
                        return;
                    }
                    if ([self determineCameraCermissions]) {
                        [self gotoFaeclIDCertificationWith:self.loginModel];
                    }
                }
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - IdentityAuthViewDelegate
- (void)identityAuthView:(IdentityAuthView *)view requestListWithPage:(NSInteger)page{
    kWeakSelf(self);
    [self.vm network_checkUserInfoWithRequestParams:@1 success:^(id data,id data2) {
        kStrongSelf(self);
        self.loginModel = data2;
        [self.mainView requestListSuccessWithArray:data andDataModel:data2 WithPage:page];
    } failed:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListFailed];
    } error:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter
- (IdentityAuthView *)mainView {
    if (!_mainView) {
        _mainView = [IdentityAuthView new];
        _mainView.delegate = self;
    }
    return _mainView;
}
- (LoginVM *)vm {
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}


-(UIView*)facelIDCertificationView{
    if (_facelIDCertificationView == nil) {
        _facelIDCertificationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
        _facelIDCertificationView.backgroundColor = COLOR_HEX(0x000000, .8);
    } return _facelIDCertificationView;
}


#pragma mark 高级认证
- (void)gotoFaeclIDCertificationWith:(id)data{
    [self getBizToken:data];
}

//#pragma mark - BizToken
- (void)getBizToken:(id)data{
    
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    kWeakSelf(self);
    [FaceIDMegNetwork getFaceIDTokenSuccess:^(id data) {
        kStrongSelf(self);
        if (data) {
            [SVProgressHUD dismiss];
            [self.facelIDCertificationView removeFromSuperview];
            [self startDetectWithFaceIDToken:[NSString stringWithFormat:@"%@",data]];
        }else{
            [self removFaceBackView:@"获取数据失败"];
        }
    } failed:^(id data) {} error:^(id data) {}];
}

#pragma mark - Detect
- (void)startDetectWithFaceIDToken:(NSString*)token{
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"模拟器不做高级认证处理");
#else /* if TARGET_IPHONE_SIMULATOR */
    FaceIDDetectError* error;
    MGFaceIDDetectManager* liveDetectManager = [[MGFaceIDDetectManager alloc] initFaceIdManagerWithToken:token
                                                                                                   error:&error];
    if (error && !liveDetectManager) {
        [self removFaceBackView:@"高级认证创建失败"];
        return;
    }
    MGFaceIDLiveDetectCustomConfigItem* customConfigItem = [[MGFaceIDLiveDetectCustomConfigItem alloc] init];
    [liveDetectManager setMGFaceIDLiveDetectCustomUIConfig:customConfigItem];
    [liveDetectManager setMGFaceIDLiveDetectPhoneVertical:MGFaceIDLiveDetectPhoneVerticalFront];
    kWeakSelf(self);
    [liveDetectManager startDetect:self
                          callback:^(NSUInteger Code, NSString *Message) {
                              kStrongSelf(self);
                              //                              NSLog(@"--------- >>>>>>>>返回数据: %@",Message);
                              if ([Message isEqualToString:@"SUCCESS"]) {
                                  [self postFaceResultsWithToken:token];
                              }else{
                                  NSString *message = [self faceIDRsultWithString:Message];
                                  if (message.length>0) {
                                      [self removFaceBackView:message];
                                  }
                              }
                          }];
#endif
}

-(void)postFaceResultsWithToken:(NSString*)token{
    [SVProgressHUD showWithStatus:@"数据加载中..."];
    kWeakSelf(self);
    [FaceIDMegNetwork postFaceIDWithBizTonken:token Success:^(id data) {
        if (data) {
            [SVProgressHUD showWithStatus:@""];
            [weakself identityAuthView:weakself.mainView requestListWithPage:1];
        }
    } failed:^(id data) {} error:^(id data) {}];
}

-(void)removFaceBackView:(NSString*)msg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.facelIDCertificationView removeFromSuperview];
        [YKToastView showToastText:msg];
    });
}

-(BOOL)determineCameraCermissions{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n还没开启相机权限，是否立马开启?\n" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"立马开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }]];
        [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:true completion:nil];
        return NO;
    } else {
        return YES;
    }
}



-(NSString*)faceIDRsultWithString:(NSString*)s{
    NSString *rsult = @"";
    if ([s isEqualToString:@"PASS_LIVING_NOT_THE_SAME"]) {
        rsult = @"有效信息与人脸对比不是同一人";
    }else if ([s isEqualToString:@"NO_ID_CARD_NUMBER"]
              || [s isEqualToString:@"NO_FACE_FOUND"]
              || [s isEqualToString:@"NO_ID_PHOTO"]
              || [s isEqualToString:@"PHOTO_FORMAT_ERROR"]
              || [s isEqualToString:@"DATA_SOURCE_ERROR"]
              || [s isEqualToString:@"FAIL_LIVING_FACE_ATTACK"]
              || [s isEqualToString:@"REPLACED_FACE_ATTACK"]
              || [s isEqualToString:@"MISSING_ARGUMENTS"]
              || [s isEqualToString:@"INIT_FAILED"]
              || [s isEqualToString:@"MORE_RETRY_TIMES"]
              || [s isEqualToString:@"BALANCE_NOT_ENOUGH"]
              || [s isEqualToString:@"NON_ENTERPRISE_CERTIFICATION"]
              || [s isEqualToString:@"IP_NOT_ALLOWED"]
              || [s isEqualToString:@"ACCOUNT_DISCONTINUED"]
              || [s isEqualToString:@"API_KEY_BE_DISCONTINUED"]){
        rsult = @"数据有误，认证失败";
    }else if ([s isEqualToString:@"ID_NUMBER_NAME_NOT_MATCH"]){
        rsult = @"身份证号，姓名不匹配，认证失败";
    }else if ([s isEqualToString:@"MOBILE_PHONE_NOT_SUPPORT"]){
        rsult = @"该手机在不支持此高级认证";
    }else if ([s isEqualToString:@"INVALID_BUNDLE_ID"]){
        rsult = @"信息验证失败，请重启程序或设备后重试";
    }
    else if ([s isEqualToString:@"NETWORK_ERROR"]){
        rsult = @"连不上互联网，请连接上互联网后重试";
    }
    else if ([s isEqualToString:@"FACE_INIT_FAIL"]){
        rsult = @"无法启动人脸识别，请稍后重试";
    }else if ([s isEqualToString:@"LIVENESS_DETECT_FAILED"]){
        rsult = @"活体检测不通过，认证失败";
    }
    else if ([s isEqualToString:@"LIVING_OVERTIME"]){
        rsult = @"操作超时，认证失败";
    }
    else if ([s isEqualToString:@"NO_SENSOR_PERMISSION"]){
        rsult = @"获取数据有误，请开启权限后重试";
    }
    else if ([s isEqualToString:@"UNDETECTED_FACE"]){
        rsult = @"未检测到人脸，认证失败";
    }
    else if ([s isEqualToString:@"ACTION_ERROR"]){
        rsult = @"用户未按照动画做动作，认证失败";
    }
    return rsult;
}


@end
