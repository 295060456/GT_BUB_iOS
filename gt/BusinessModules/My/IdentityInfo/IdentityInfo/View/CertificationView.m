//
//  CertificationView.m
//  OTC
//
//  Created by Terry.c on 2018/11/26.
//  Copyright © 2018 yang peng. All rights reserved.
//

#import "CertificationView.h"
#import "VicFaceAuthManager.h"
#import "LoginModel.h"
#import "IdentityAuthVM.h"
#import "LoginModel.h"
#import "CerfResultView.h"
#import "IdentityAuthModel.h"

@interface CertificationView ()
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, copy) NSString *optionImageUrlS;
@property (nonatomic, copy) NSString *confirmImageUrlS;
@property (nonatomic, copy) UIImageView *optionImageView;
@property (nonatomic, copy) UIImageView *confirmImageView;

@property (nonatomic, strong) UIImageView *optionBtn;
@property (nonatomic, strong) UIImageView *confirmBtn;

@property (nonatomic, strong) UIButton *bootomBtn;
@property (nonatomic, strong) IdentityAuthVM* vm;
//@property (nonatomic, strong) NSString *identityNumber;
//@property (nonatomic, strong) NSString *identityName;
//@property (nonatomic, strong) NSString *suingAuthority;
@end
@implementation CertificationView

-(UIImageView*)optionImageView{
    if (_optionImageView == nil) {
        _optionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 15*SCALING_RATIO, 285*SCALING_RATIO, 150*SCALING_RATIO)];
    }return _optionImageView;
}

-(UIImageView*)confirmImageView{
    if (_confirmImageView == nil) {
        _confirmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15*SCALING_RATIO, 15*SCALING_RATIO, 285*SCALING_RATIO, 150*SCALING_RATIO)];
    }return _confirmImageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

-(void)setupView {
    
    UILabel *noticeLable = [UILabel new];
    [self addSubview:noticeLable];
    [noticeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15*SCALING_RATIO);
        make.left.mas_equalTo(30*SCALING_RATIO);
        make.height.mas_equalTo(kRealValue(20*SCALING_RATIO));
    }];
    noticeLable.numberOfLines = 0;
    noticeLable.textColor = HEXCOLOR(0x333333);
    noticeLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20*SCALING_RATIO];
    noticeLable.text = @"实名认证";
    
    UILabel *noticeLable1 = [UILabel new];
    [self addSubview:noticeLable1];
    [noticeLable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noticeLable.mas_bottom).offset(10*SCALING_RATIO);
        make.left.mas_equalTo(noticeLable.mas_left);
        make.height.mas_equalTo(kRealValue(18*SCALING_RATIO));
    }];
    noticeLable1.numberOfLines = 0;
    noticeLable1.textColor = HEXCOLOR(0x333333);
    noticeLable1.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18*SCALING_RATIO];
    noticeLable1.text = @"请上传身份证照片";
    
    UILabel *noticeLable2 = [UILabel new];
    [self addSubview:noticeLable2];
    [noticeLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noticeLable1.mas_bottom).offset(10*SCALING_RATIO);
        make.left.mas_equalTo(noticeLable.mas_left);
        make.height.mas_equalTo(kRealValue(14*SCALING_RATIO));
    }];
    noticeLable2.numberOfLines = 0;
    noticeLable2.textColor = HEXCOLOR(0x8c96a5);
    noticeLable2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13*SCALING_RATIO];
    noticeLable2.text = @"拍照时请确保身份证边框完整、图像清晰";
    
    self.optionBtn = [UIImageView new];
    [self addSubview:self.optionBtn];
    self.optionBtn.userInteractionEnabled = YES;
    self.optionBtn.image = kIMG(@"renxiangmianXiraS");
    UITapGestureRecognizer *ta1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionBtnAction)];
    [self.optionBtn addGestureRecognizer:ta1];
//    [self.optionBtn setImage:kIMG(@"renxiangmianXira") forState:(UIControlStateNormal)]; // shenfenXeimian
//    [self.optionBtn addTarget:self action:@selector(optionBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noticeLable2.mas_bottom).offset(26*SCALING_RATIO);
        make.left.mas_equalTo(noticeLable.mas_left);
        make.height.mas_equalTo(kRealValue(180*SCALING_RATIO));
        make.width.mas_equalTo(kRealValue(315*SCALING_RATIO));
    }];
    
    self.confirmBtn = [UIImageView new];
    [self addSubview:self.confirmBtn];
    self.confirmBtn.userInteractionEnabled = YES;
    self.confirmBtn.image = kIMG(@"shenfenXeimianS");
    UITapGestureRecognizer *ta2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confirmBtnAction)];
    [self.confirmBtn addGestureRecognizer:ta2];
//    [self.confirmBtn setImage:kIMG(@"shenfenXeimian") forState:(UIControlStateNormal)]; // shenfenXeimian
//    [self.confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.optionBtn.mas_bottom).offset(10*SCALING_RATIO);
        make.left.mas_equalTo(noticeLable.mas_left);
        make.height.mas_equalTo(kRealValue(180*SCALING_RATIO));
        make.width.mas_equalTo(kRealValue(315*SCALING_RATIO));
    }];
    
    _bootomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_bootomBtn];
    _bootomBtn.titleLabel.numberOfLines = 0;
    _bootomBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12*SCALING_RATIO];
    [_bootomBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
    [_bootomBtn setTitle:@"本人确保以上信息真实有效，如有伪造、隐瞒行为，造成的后果本人愿意自行承担。" forState:UIControlStateNormal];
    [_bootomBtn setImage:[UIImage imageNamed:@"user_auth_nomal"] forState:UIControlStateNormal];
    [_bootomBtn addTarget:self action:@selector(onClickOptionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bootomBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    [_bootomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self);
        make.top.equalTo(self.confirmBtn.mas_bottom).offset(10*SCALING_RATIO);
        make.left.equalTo(self).offset(30*SCALING_RATIO);
        make.right.equalTo(self).offset(-30*SCALING_RATIO);
        make.height.mas_equalTo(kRealValue(34*SCALING_RATIO));
    }];
    
    [self bottomSingleSMZRButtonInSuperView:self WithButtionTitles:@"提交审核" leftButtonEvent:^(id data) {
        [self onClickConfirmBtn];
    }];
}

-(void)onClickOptionBtn:(UIButton*)sender {
    self.bootomBtn.selected = !self.bootomBtn.selected;
    if (sender.selected) {
        [_bootomBtn setImage:[UIImage imageNamed:@"GGinvalidName"] forState:UIControlStateNormal];
    } else {
        [_bootomBtn setImage:[UIImage imageNamed:@"user_auth_nomal"] forState:UIControlStateNormal];
    }
}


-(void)actionBlock:(DataBlock)block{
    self.block = block;
}

-(void)optionBtnAction{ // 第一个
    [self alertChooseButton:self.optionBtn];
}

-(void)confirmBtnAction{ // 第二个
    [self alertChooseButton:self.confirmBtn];
}


-(void)alertChooseButton:(UIImageView *)bu {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos && photos.count > 0) {
            UIImage *im = photos[0];
            if ([bu isEqual:self.optionBtn]) {
//                self.identityName = nil;
//                self.identityNumber = nil;
                self.optionImageView.image = im;
                [self.optionBtn addSubview:self.optionImageView];
            }else{
//                self.suingAuthority = nil;
                self.confirmImageView.image = im;
                [self.confirmBtn addSubview:self.confirmImageView];
            }
            [self imageToAliyunQuery:bu andImage:im];
        }
    }];
    [self.currentViewController presentViewController:imagePickerVc
                                             animated:YES
                                           completion:nil];
}

- (UIViewController *)currentViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

//-(void)startUpload:(UIButton*)button andImage:(UIImage*)iamgeView {
//
//    UIImage *needUploadImage = iamgeView;
//    kWeakSelf(self);
//    [SVProgressHUD showWithStatus:@"图片识别中..." maskType:SVProgressHUDMaskTypeBlack];
//    [VicFaceAuthManager authIdentityCardWithImage:needUploadImage legality:YES successCompletion:^(id  _Nonnull data) {
//        kStrongSelf(self);
//        [SVProgressHUD dismiss];
//        if([data isKindOfClass:[NSDictionary class]]){
//            NSDictionary *dict = (NSDictionary *)data;
//            if([[dict objectOrNilForKey:@"cards"] count] > 0){
//                NSDictionary *cardDict = [[dict objectOrNilForKey:@"cards"] firstObject];
//                NSDictionary *legalityDict = [cardDict objectOrNilForKey:@"legality"];
//
//                NSDictionary *idcardParam = @{};
//
//                if([button isEqual:self.optionBtn]){
//                    idcardParam = [idcardParam vic_appendKey:@"type" value:[cardDict objectOrNilForKey:@"type"]];
//                    idcardParam = [idcardParam vic_appendKey:@"address" value:[cardDict objectOrNilForKey:@"address"]];
//                    idcardParam = [idcardParam vic_appendKey:@"gender" value:[cardDict objectOrNilForKey:@"gender"]];
//                    idcardParam = [idcardParam vic_appendKey:@"idCardNumber" value:[cardDict objectOrNilForKey:@"id_card_number"]];
//                    idcardParam = [idcardParam vic_appendKey:@"name" value:[cardDict objectOrNilForKey:@"name"]];
//                    idcardParam = [idcardParam vic_appendKey:@"race" value:[cardDict objectOrNilForKey:@"race"]];
//                }else{
//                    idcardParam = [idcardParam vic_appendKey:@"issuedBy" value:[cardDict objectOrNilForKey:@"issuedBy"]];
//                    idcardParam = [idcardParam vic_appendKey:@"validDate" value:[cardDict objectOrNilForKey:@"validDate"]];
//                }
//
//                idcardParam = [idcardParam vic_appendKey:@"side" value:[cardDict objectOrNilForKey:@"side"]];
//                idcardParam = [idcardParam vic_appendKey:@"idPhoto" value:[legalityDict objectOrNilForKey:@"ID Photo"]];
//                idcardParam = [idcardParam vic_appendKey:@"temporaryIdPhoto" value:[legalityDict objectOrNilForKey:@"Temporary ID Photo"]];
//                idcardParam = [idcardParam vic_appendKey:@"photoCopy" value:[legalityDict objectOrNilForKey:@"Photocopy"]];
//                idcardParam = [idcardParam vic_appendKey:@"screen" value:[legalityDict objectOrNilForKey:@"Screen"]];
//                idcardParam = [idcardParam vic_appendKey:@"edited" value:[legalityDict objectOrNilForKey:@"Edited"]];
//                NSLog(@"--- %@",cardDict);
//                [self photoInformationToSever:idcardParam bu:button andImage:needUploadImage and:cardDict];
//            }
//        }
//    } errorCompletion:^(NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
//    }];
//}

-(void)imageToAliyunQuery:(UIImageView*)button andImage:(UIImage*)iamgeView{
    
     UIImage *needUploadImage = iamgeView;
    kWeakSelf(self);
    [SVProgressHUD showWithStatus:@"上传中..." maskType:SVProgressHUDMaskTypeBlack];
    [AliyunQuery uploadImageToAlyun:needUploadImage title:@"auth" completion:^(NSString *imgUrl) {
        kStrongSelf(self);
        [NSThread sleepForTimeInterval:1.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            if (self && ![NSString isEmpty:imgUrl]) {
                [YKToastView showToastText:@"上传成功"];
                if ([button isEqual:self.optionBtn]) {
                    self.optionImageUrlS = imgUrl;
                }else{
                    self.confirmImageUrlS = imgUrl;
                }
            } else {
                [YKToastView showToastText:@"上传失败,请稍后再试"];
                if ([button isEqual:self.optionBtn]) {
                    [self.optionImageView removeFromSuperview];
                    self.optionImageUrlS = nil;
                }else{
                    [self.confirmImageView removeFromSuperview];
                    self.confirmImageUrlS = nil;
                }
            }
        });
    }];
}


-(void)onClickConfirmBtn {
    
    if (self.optionImageUrlS == nil || self.optionImageUrlS.length < 2 ) {
        [YKToastView showToastText:@"请上传人像面照片"];
        return;
    }
    if (self.confirmImageUrlS == nil || self.confirmImageUrlS.length < 2 ) {
        [YKToastView showToastText:@"请上传国徽面照片"];
        return;
    }
    if (!self.bootomBtn.selected) {
        [YKToastView showToastText:@"请确认信息真实有效"];
        return;
    }
//    @property (nonatomic,strong) IdentityAuthModel* model;
    kWeakSelf(self);
    [self.vm postIdentityApplyWithidCardFont:self.optionImageUrlS idCardReverse:self.confirmImageUrlS success:^(id data) {
        IdentityAuthModel* model = data;  //        errcode    String    0-验证失败，1-审核通过，2-审核中，3-无效的用户，请重新提交审核 ,9-系统异常
        if ([model.errcode isEqualToString:@"1"]) {
            [weakself certificationResultShow:ResultViewSuccess];
        }else if ([model.errcode isEqualToString:@"0"]){
            [weakself certificationResultShow:ResultViewFailure];
        }else{
            [YKToastView showToastText:model.msg];
        }
    } failed:^(id data) {} error:^(id data) {
        [weakself certificationResultShow:ResultViewTomeOut];
    }];
}

-(void)certificationResultShow:(CerfResultViewType)type{
    
    CerfResultView *v = [[CerfResultView  alloc] initWithType:type block:^(id data) {
        if (self.block) {
            self.block(@1);
        }
    }];
    [kAPPDelegate.window addSubview:v];
}

-(void)setReviewStatu{}

- (IdentityAuthVM *)vm {
    if (!_vm) {
        _vm = [IdentityAuthVM new];
    }
    return _vm;
}
@end
