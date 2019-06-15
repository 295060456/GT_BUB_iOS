//
//  AboutUsVC.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.
//  关于我们

#import "MyTransferCodeVC.h"
#import "ZXingObjC.h"
#import "Photos/Photos.h"
#import "TransferRecordVC.h"
#import "LoginVM.h"
#import "AboutUsModel.h"
#import "LoginModel.h"
@interface MyTransferCodeVC ()
@property (nonatomic, strong)UIView * saveView;
@property (nonatomic, strong) UIImageView* QRView;
@property (nonatomic, copy) NSString *zfbQRCode;
@property(nonatomic,strong)UILabel * aboutUsLab;
@property(nonatomic,strong)UILabel * UsQQ;
@property (nonatomic, strong) LoginVM* vm;
@property (nonatomic, strong) AboutUsModel* model;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation MyTransferCodeVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    MyTransferCodeVC *vc = [[MyTransferCodeVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [YBGeneralColor themeColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor, NSFontAttributeName:YBGeneralFont.navigationBarTitleFont}];
    [self.navigationItem addCustomLeftButton:self withImage:[UIImage imageNamed:@"icon_back_white"] andTitle:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault; // 解决我的收款码 偶尔为白色
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = YBGeneralColor.navigationBarColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:YBGeneralColor.navigationBarTitleColor, NSFontAttributeName:YBGeneralFont.navigationBarTitleFont}];
}

-(void)leftButtonEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.view.backgroundColor = [YBGeneralColor themeColor];
    
    self.title = @"我的收款码";
    
    kWeakSelf(self);
    [self.vm network_myTransferCodeWithRequestParams:@1
                                             success:^(id data) {
                                                 [weakself richElementsInView:data];
                                             } failed:^(id data) {
                                                 
                                             } error:^(id data) {
                                                 
                                             }];
}

- (void)richElementsInView:(AboutUsModel*)data{
    
    _zfbQRCode = ![NSString isEmpty:data.address]?data.address:@"";//@"4028838a00003a8401697b77d28f0000";
    
    self.saveView = [[UIView alloc]init];
    self.saveView.backgroundColor = HEXCOLOR(0x4c7fff);
    //    self.saveView.backgroundColor = KYellowColor;
    [self.view addSubview:self.saveView];
    [self.saveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(16);
        make.trailing.equalTo(self.view).offset(-16);
        make.top.equalTo(self.view).offset(17);
        //        make.bottom.equalTo(sub_view).offset(-9.5);
        make.height.equalTo(@488);
    }];
    
    UILabel* tiLab = [[UILabel alloc]init];
    [self.saveView addSubview:tiLab];
    //    tiLab.text = @"我的收款码";
    tiLab.textColor = kWhiteColor;
    tiLab.textAlignment = NSTextAlignmentCenter;
    tiLab.font = kFontSize(25);
    [tiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saveView.mas_top).offset(37);
        make.centerX.equalTo(self.saveView);
        make.height.mas_equalTo(@36);
    }];
    
    
    UIImageView* saveQRView = [[UIImageView alloc]init];
    [self.saveView addSubview:saveQRView];
    //    saveQRView.backgroundColor = kRedColor;
    [saveQRView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tiLab.mas_bottom).offset(15);
        make.centerX.equalTo(self.saveView);
        //            make.width.mas_equalTo(@20);
        make.width.height.mas_equalTo(@185);
    }];
    if (![NSString isEmpty:_zfbQRCode]) {
        ZXEncodeHints *hints = [ZXEncodeHints hints];
        hints.encoding = NSUTF8StringEncoding;
        hints.margin = @(0);
        ZXQRCodeWriter *writer = [[ZXQRCodeWriter alloc] init];
        ZXBitMatrix *result = [writer encode:_zfbQRCode
                                      format:kBarcodeFormatQRCode
                                       width:200
                                      height:200
                                       hints:hints
                                       error:nil];
        saveQRView.image = [UIImage imageWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];//7 64
    }
    
    
    LoginModel* userInfoModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
    UIButton* nameBtn = [[UIButton alloc]init];
    [self.saveView addSubview:nameBtn];
    NSString* name = ![userInfoModel.userinfo.username isEqualToString:userInfoModel.userinfo.nickname]?[NSString stringWithFormat:@"%@（%@）",userInfoModel.userinfo.username,userInfoModel.userinfo.nickname]:userInfoModel.userinfo.username;
    [nameBtn setTitle:name forState:UIControlStateNormal] ;
    nameBtn.titleLabel.numberOfLines = 0;
    [nameBtn setTitleColor:kWhiteColor forState:UIControlStateNormal] ;
    nameBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    nameBtn.titleLabel.font = kFontSize(20);
    [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveQRView.mas_bottom).offset(20);
        make.centerX.equalTo(self.saveView);
        //        make.height.mas_equalTo(@36);
    }];
    
    UIButton* tipBtn = [[UIButton alloc]init];
    [self.saveView addSubview:tipBtn];
    [tipBtn setTitle:[NSString stringWithFormat:@"%@",@"打开 币友 APP [扫一扫]"] forState:UIControlStateNormal] ;
    tipBtn.titleLabel.numberOfLines = 0;
    [tipBtn setTitleColor:kWhiteColor forState:UIControlStateNormal] ;
    tipBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tipBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 25.0f];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.saveView);
        make.height.mas_equalTo(@36);
    }];
    
    
    UIButton* iconBtn = [[UIButton alloc]init];
    [self.saveView addSubview:iconBtn];
    iconBtn.backgroundColor = kWhiteColor;
    [iconBtn setTitle:[NSString stringWithFormat:@"%@",@"币友支付"] forState:UIControlStateNormal] ;
    [iconBtn setImage:kIMG(@"icon-in-app90") forState:UIControlStateNormal];
    iconBtn.titleLabel.numberOfLines = 0;
    [iconBtn setTitleColor:HEXCOLOR(0x393738) forState:UIControlStateNormal] ;
    iconBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    iconBtn.titleLabel.font = kFontSize(24);
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.saveView.mas_bottom).offset(0);
        make.centerX.equalTo(self.saveView);
        make.height.mas_equalTo(@96);
        make.left.right.equalTo(self.saveView);
    }];
    [iconBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    
    
    
    
    UIView* topView = [[UIView alloc]init];
    topView.backgroundColor = HEXCOLOR(0xb3e5e8f6);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(17);
        //        make.bottom.equalTo(sub_view).offset(-9.5);
        make.height.equalTo(@50);
    }];
    
    
    
    [self.view layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topView.bounds;
    maskLayer.path = maskPath.CGPath;
    topView.layer.mask = maskLayer;
    
    UIImageView *im = [[UIImageView alloc] init];
    [topView addSubview:im];
    im.image = kIMG(@"myaccountPocket");
    [im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(20);
        make.top.mas_equalTo(topView).offset(17);
        make.width.equalTo(@18);
        make.height.equalTo(@20);
    }];
    
    UILabel *la = [[UILabel alloc] init];
    [topView addSubview:la];
    la.font = kFontSize(15);
    la.textColor = HEXCOLOR(0x464646);
    la.text = @"二维码收款";
    [la mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(48);
        make.top.mas_equalTo(topView).offset(16);
        make.width.equalTo(@100);
        make.height.equalTo(@23);
    }];
    
    //    UIButton* codeBtn = [[UIButton alloc] init];
    //    codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [topView addSubview:codeBtn];
    //    //    [transferBtn addTarget:self action:@selector(transferBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(topView.mas_left).offset(20);
    //        make.centerY.equalTo(topView);
    //        make.width.equalTo(@224);
    //    }];
    //    codeBtn.titleLabel.font = kFontSize(15);
    //    [codeBtn setTitleColor:HEXCOLOR(0x464646) forState:UIControlStateNormal];
    //    [codeBtn setTitle:@"二维码收款" forState:UIControlStateNormal];
    //    [codeBtn setImage:kIMG(@"myaccountPocket") forState:UIControlStateNormal];
    //    [codeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:12];
    
    
    UIView* downView = [[UIView alloc]init];
    downView.userInteractionEnabled = YES;
    downView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.top.equalTo(topView.mas_bottom).offset(0);
        //        make.bottom.equalTo(sub_view).offset(-9.5);
        make.height.equalTo(@458);
    }];
    
    [self.view layoutIfNeeded];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:downView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = downView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    downView.layer.mask = maskLayer1;
    
    
    UIButton* titleBtn = [[UIButton alloc] init];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [downView addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downView.mas_top).offset(28);
        make.centerX.equalTo(downView);
        make.height.equalTo(@18);
    }];
    titleBtn.titleLabel.font = kFontSize(15);
    [titleBtn setTitleColor:HEXCOLOR(0x464646) forState:UIControlStateNormal];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"打开 币友-扫一扫，扫二维码向我付款" attributes:@{
                                                                                                                                       NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 13.0f],
                                                                                                                                       NSForegroundColorAttributeName: [UIColor colorWithRed:35.0f / 255.0f green:38.0f / 255.0f blue:48.0f / 255.0f alpha:1.0f],
                                                                                                                                       NSKernAttributeName: @(0.0)
                                                                                                                                       }];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size: 13.0f] range:NSMakeRange(3, 6)];
    [titleBtn setAttributedTitle:attributedString forState:UIControlStateNormal];//155
    
    
    self.QRView = [[UIImageView alloc]init];
    [downView addSubview:self.QRView];
    [self.QRView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBtn.mas_bottom).offset(21);
        make.centerX.equalTo(downView);
        //            make.width.mas_equalTo(@20);
        make.width.height.mas_equalTo(@155);
    }];
    
    //    _zfbQRCode = ![NSString isEmpty:data.address]?data.address:@"";//@"4028838a00003a8401697b77d28f0000";
    if (![NSString isEmpty:_zfbQRCode]) {
        ZXEncodeHints *hints = [ZXEncodeHints hints];
        hints.encoding = NSUTF8StringEncoding;
        hints.margin = @(0);
        ZXQRCodeWriter *writer = [[ZXQRCodeWriter alloc] init];
        ZXBitMatrix *result = [writer encode:_zfbQRCode
                                      format:kBarcodeFormatQRCode
                                       width:200
                                      height:200
                                       hints:hints
                                       error:nil];
        self.QRView.image = [UIImage imageWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];//7 64
    }
    
    UIButton* saveBtn = [[UIButton alloc] init];
    saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [downView addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QRView.mas_bottom).offset(7);
        make.centerX.equalTo(downView);
        make.height.equalTo(@64);
    }];
    if (![NSString isEmpty:_zfbQRCode]) {
        [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    saveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13.0f];
    [saveBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存收款码图片" forState:UIControlStateNormal];
    
    UIButton* addrBtn = [[UIButton alloc] init];
    addrBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    addrBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [downView addSubview:addrBtn];
    [addrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveBtn.mas_bottom).offset(0);
        make.left.equalTo(downView).offset(27);
        make.right.equalTo(downView).offset(-27);
        make.height.equalTo(@74);
    }];
    [addrBtn addTarget:self action:@selector(copyAddrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addrBtn.titleLabel.numberOfLines = 0;
    addrBtn.titleLabel.font = kFontSize(13);
    [addrBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
    [addrBtn setTitle:[NSString stringWithFormat:@"收款地址：%@",_zfbQRCode] forState:UIControlStateNormal];
    addrBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    
    UIButton* copyBtn = [[UIButton alloc] init];
    copyBtn.userInteractionEnabled = NO;
    copyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    copyBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [addrBtn addSubview:copyBtn];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addrBtn.mas_top).offset(36);
        
        make.centerX.equalTo(addrBtn);
        make.height.equalTo(@38);
    }];
    copyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 13.0f];
    [copyBtn setTitleColor:HEXCOLOR(0x5584ff) forState:UIControlStateNormal];
    [copyBtn setTitle:[NSString stringWithFormat:@"复制"] forState:UIControlStateNormal];
    [copyBtn setImage:kIMG(@"grey_copy") forState:UIControlStateNormal];
    [copyBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    
    UIView* line = [[UIView alloc]init];
    [addrBtn addSubview:line];
    line.backgroundColor = HEXCOLOR(0xbbbbbb);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addrBtn.mas_bottom).offset(-1);
        
        make.left.right.equalTo(addrBtn).offset(0);
        
        make.height.equalTo(@1);
    }];//78  -12
    
    UIButton* transferBtn = [[UIButton alloc] init];
    [downView addSubview:transferBtn];
    [transferBtn addTarget:self action:@selector(goTransferBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addrBtn.mas_right).offset(0);
        make.left.equalTo(downView.mas_left).offset(38);
        make.top.equalTo(addrBtn.mas_bottom).offset(0);
        //        make.bottom.equalTo(downView.mas_bottom).offset(-12);
        make.height.equalTo(@78);
    }];
    
    
    UIImageView *imS = [[UIImageView alloc] init];
    [transferBtn addSubview:imS];
    imS.image = kIMG(@"myaccountRecord");
    [imS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(transferBtn).offset(29);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    
    UILabel *laS = [[UILabel alloc] init];
    [transferBtn addSubview:laS];
    laS.font = kFontSize(14);
    laS.textColor = HEXCOLOR(0x464646);
    laS.text = @"查看我的收款记录";
    [laS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imS.mas_right).offset(10);
        make.top.mas_equalTo(transferBtn).offset(29);
        make.width.equalTo(@200);
        make.height.equalTo(@23);
    }];

    UIImageView * arrowImgView = [[UIImageView alloc]init];
    arrowImgView.image = kIMG(@"btnRight");
    [transferBtn addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(transferBtn.mas_right).offset(0);
        make.centerY.equalTo(transferBtn);
        //        make.bottom.equalTo(sub_view).offset(-9.5);
        make.height.width.equalTo(@24);
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message…
        [SVProgressHUD showErrorWithStatus:@"收款码保存失败，请去 隐私 > 照片 中打开「币友APP」的照片权限"];
    }
    else  // No errors
    {
        // Show message image successfully saved
        [SVProgressHUD showSuccessWithStatus:@"收款码保存成功"];
    }
}

-(void)saveBtnClick{
    //    [SVProgressHUD showWithStatus:@"保存中..."];
    
    //    UIImageWriteToSavedPhotosAlbum(self.QRView.image,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
    
    [self.view layoutIfNeeded];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.saveView.width, self.saveView.height), NO, [UIScreen mainScreen].scale);
    
    [self.saveView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
    return;
    //    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
//        [PHAssetChangeRequest creationRequestForAssetFromImage:self.QRView.image];
//    } completionHandler:^(BOOL success, NSError * _Nullable error) {
//        if (success) {
//            //            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
//        }else{
//            //            [SVProgressHUD  showErrorWithStatus:@"保存失败"];
//        }
//    }];
}

- (void)copyAddrBtnClick:(UIButton*)sender{
    if (![NSString isEmpty:sender.titleLabel.text]) {
        [YKToastView showToastText:@"复制成功!"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = sender.titleLabel.text;
    }
}

- (void)goTransferBtnClick{
    [TransferRecordVC pushFromVC:self locateIndex:1];
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}
- (LoginVM *)vm {
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}

@end
