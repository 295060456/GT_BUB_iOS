//
//  AddAccountVC.m
//  gt
//
//  Created by cookie on 2018/12/21.
//  Copyright © 2018 GT. All rights reserved.
//

#import "AddAccountVC.h"
#import "UpLoadImageHV.h"
#import "MyInputCell.h"

#import "ZXingObjC.h"
#import "AliyunQuery.h"
#import "PaymentAccountModel.h"
#import "PaymentAccountVM.h"
#import "SecuritySettingVC.h"
@interface AddAccountVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, copy)NSString * imageUrl;
@property (nonatomic, copy)NSString * imageCordString;
@property (nonatomic, strong) UpLoadImageHV* uploadImageHV;
@property (nonatomic , strong) NSArray *dataSource;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIAlertController *actionSheet;
@property (nonatomic, strong) PaymentAccountVM* vm;

@property (nonatomic, copy) DataBlock block;

@property (nonatomic, strong) NSString * text0;
@property (nonatomic, strong) NSString * text1;
@property (nonatomic, strong) NSString * text2;
@property (nonatomic, strong) NSString * text3;
@property (nonatomic, strong) NSString * text4;
@property (nonatomic, strong) NSString * text5;
@property (nonatomic, strong) NSString * text6;


@property (nonatomic, strong) id requestParams;
@property (nonatomic,assign) PaywayType paywayType;
@property (nonatomic,assign) PaywayOccurType paywayOccurType;
@end

@implementation AddAccountVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
            withPaywayType:(PaywayType)paywayType
           paywayOccurType:(PaywayOccurType)paywayOccurType
                   success:(DataBlock)block
{
    AddAccountVC *vc = [[AddAccountVC alloc] init];
    vc.block = block;
    vc.paywayType = paywayType;
    vc.paywayOccurType = paywayOccurType;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件
-(void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
    [self.view endEditing:YES];
    if (self.text0.length>0 || self.text1.length > 0 || self.imageCordString.length>0) {
        [self showAlertView];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)showAlertView{
    kWeakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"退出后当前编辑信息不会保存" preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [weakself.navigationController popViewControllerAnimated:YES];
    }]];
    [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:true completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.text0 = @"";
    self.text1 = @"";
    self.text2 = @"";
    self.text3 = @"";
    self.text4 = @"";
    self.text5 = @"";
    self.text6 = @"";
    self.imageUrl = @"";
    self.imageCordString = @"";
    switch (_paywayType) {
        case PaywayTypeWX:
            {
                self.title = @"添加微信账号";
                self.dataSource = @[@{@"姓名":@"请输入姓名"},
                                    @{@"微信账号":@"请输入微信账号"},
                                    @{accountS:@"请输入账户单日收款上限"},
//                                    @{@"备注":@"请输入备注"},
                                    @{@"BUB支付密码":@"请输入BUB支付密码"}];
            }
            break;
        case PaywayTypeZFB:
        {
            self.title = @"添加支付宝账号";
            self.dataSource = @[@{@"姓名":@"请输入姓名"},
                                @{@"支付宝账号":@"请输入支付宝账号"},
                                @{accountS:@"请输入账户单日收款上限"},
//                                @{@"备注":@"请输入备注"},
                                @{@"BUB支付密码":@"请输入BUB支付密码"}];
        }
            break;
        case PaywayTypeCard:
        {
            self.title = @"添加银行卡账号";
            self.dataSource = @[@{@"姓名":@"请输入姓名"},
                                @{@"开户银行":@"请输入开户银行"},
                                @{@"开户支行":@"请输入开户支行"},
                                @{@"银行卡号":@"请输入银行卡号"},
                                @{@"银行卡确认":@"请确认银行卡号"},
                                @{accountS:@"请输入账户单日收款上限"},
//                                @{@"备注":@"请输入备注"},
                                @{@"BUB支付密码":@"请输入BUB支付密码"}];
        }
            break;
        default:
            break;
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset([YBSystemTool isIphoneX]? -[YBFrameTool tabBarHeight]:-48.5);
    }];
    
    if (_paywayType!=PaywayTypeCard) {
        [self initHeaderView];
    }
    
    [self.view bottomSingleButtonInSuperView:self.view WithButtionTitles:@"添加账号" leftButtonEvent:^(id data) {
        [self nextBtnClick];
    }];
}

- (void)initHeaderView {
    _uploadImageHV = [[UpLoadImageHV alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 200) WithModel:@1];
    _tableView.tableFooterView = _uploadImageHV;
    [_uploadImageHV actionBlock:^(id data) {
        UIButton* uploadImgBtn = data;
        
        [self pickImageFromAlbumWithCompletionHandler:^(NSData *imageData, UIImage *image) {
            
            [SVProgressHUD showWithStatus:@"上传中..." maskType:SVProgressHUDMaskTypeBlack];
            kWeakSelf(self);
            [AliyunQuery uploadImageToAlyun:image title:@"IDcard" completion:^(NSString *imgUrl) {
                kStrongSelf(self);
                [NSThread sleepForTimeInterval:1.0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    if (self && ![NSString isEmpty:imgUrl]) {
                        self.imageUrl = imgUrl;
                        CGImageRef imageRef = image.CGImage;
                        ZXCGImageLuminanceSource * source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageRef];
                        ZXBinaryBitmap * bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
                        NSError * error = nil;
                        ZXDecodeHints * hints = [ZXDecodeHints hints];
                        ZXMultiFormatReader * reader = [ZXMultiFormatReader reader];
                        ZXResult * result = [reader decode:bitmap hints:hints error:&error];
                        if (result) {
                            self.imageCordString = imgUrl;
                        NSLog(@".....imageCordString=%@",self.imageCordString);
                            [uploadImgBtn setImage:image forState:UIControlStateNormal];
                        }else{
                            [SVProgressHUD showErrorWithStatus:@"图片非正规二维码，请重新添加二维码"];
                            [uploadImgBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
                        }
                    }else{
                        [uploadImgBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
                        [SVProgressHUD showErrorWithStatus:@"二维码上传失败，请重新添加二维码"];
                    }
                });
            }];
        }];
    }];
}

-(void)nextBtnClick{
    kWeakSelf(self);
    [self.view endEditing:YES];
    if (_paywayType !=PaywayTypeCard) {
        NSString *s = nil;
        if (self.text0.length < 0.5) {
            s = @"姓名不能为空";
        }else if (self.text1.length < 0.5){
             s = @"账号不能为空";
        }else if (self.text3.length < 0.5){
            s = @"密码不能为空";
        }else if (self.imageCordString.length<0.5){
            s = @"收款二维码不能为空";
        }
        if (self.text2 && self.text2.length > 0) {
            if (![self validateNumber:self.text2]) {
                s = @"限额只能是数字";
            }
        }
        if (s && s.length>0) {
            [YKToastView showToastText:s];
            return;
        }
        NSString *md5Pwd = [NSString MD5WithString:self.text3 isLowercase:YES];
            [self.vm network_addAccountRequestParams:[NSString stringWithFormat:@"%lu",(unsigned long)_paywayType]
                        name:self.text0
                     account:self.text1
                      remark:@""
                    tradePwd:md5Pwd
                      QRCode:self.imageCordString
                   upperLimit:self.text2
             accountOpenBank:@""
            accountOpenBranch:@""
             accountBankCard:@""
            accountBankCardRepeat:@""
                         success:^(id data) {
                             kStrongSelf(self);
                             [self.navigationController popViewControllerAnimated:YES];
                             if (self.block) {
                                 self.block(data);
                             }
                         } failed:^(id data) {
                             kStrongSelf(self);
                             [self faildAlertView:data];
                         } error:^(id data) {
                             
                         }];
    }else{
        
//        NSLog(@"------ %@    %@   %@   %@   %@   %@   %@  ")
        NSString *s = nil;
        if (![self.text3 isEqualToString:self.text4]) {
            s = @"银行卡号前后输入不一致";
        }
        if (self.text0.length < 0.5) {
            s = @"姓名不能为空";
        }else if (self.text3.length < 0.5){
            s = @"银行卡号不能为空";
        }else if (self.text6.length < 0.5){
            s = @"密码不能为空";
        }else if (self.text1.length<0.5){
            s = @"开户行不能为空";
        }else if (self.text2.length<0.5){
            s = @"开户支行不能为空";
        }
        if (self.text5 && self.text5.length > 0) {
            if (![self validateNumber:self.text5]) {
                s = @"限额只能是数字";
            }
        }
        if (s == nil) {
            if (![self validateNumber:self.text3]) {
                s = @"银行卡号只能是数字";
            }
        }
        if (s && s.length>0) {
            [YKToastView showToastText:s];
            return;
        }
        
        NSString *md5Pwd = [NSString MD5WithString:self.text6 isLowercase:YES];
        [self.vm network_addAccountRequestParams:[NSString stringWithFormat:@"%lu",(unsigned long)_paywayType]
                    name:self.text0
                 account:@""
                  remark:@""
                tradePwd:md5Pwd
                  QRCode:@""
              upperLimit:self.text5
         accountOpenBank:self.text1
       accountOpenBranch:self.text2
         accountBankCard:self.text3
   accountBankCardRepeat:self.text4
                 success:^(id data) {
                     kStrongSelf(self);
                     [self.navigationController popViewControllerAnimated:YES];
                     if (self.block) {
                         self.block(data);
                     }
                 } failed:^(id data) {
                     kStrongSelf(self);
                     [self faildAlertView:data];
                 } error:^(id data) {
                     
                 }];
       }
}

-(void)faildAlertView:(id)data{
    PaymentAccountModel* model = data;
    NSString* msg = model.msg;
    if ([msg isEqualToString:@"设置完支付密码才能添加收款方式哦"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您还没有设置支付密码" message:@"设置完支付密码才能添加收款方式哦" preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"稍后验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"现在去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [SecuritySettingVC pushFromVC:self requestParams:@1 success:^(id data) {
                
            }];
        }]];
        [self presentViewController:alert animated:true completion:nil];
    }
    else{
        [YKToastView showToastText:msg];
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView YBGeneral_configuration];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MyInputCell cellHeightWithModel];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyInputCell *cell = [MyInputCell cellWith:tableView];
    NSDictionary* model = self.dataSource[indexPath.row];
    [cell richElementsInAddAccountCellWithModel:model WithIndexRow:indexPath.row WithAllSourceSum:self.dataSource.count];
//    WS(weakSelf);
    [cell actionBlock:^(id data,id data2) {
        UITextField * textField = data;
        EnumActionTag tag = textField.tag;
            switch (tag) {
                case EnumActionTag0:
                    self.text0 = data2;
                    break;
                case EnumActionTag1:
                    self.text1 = data2;
                    break;
                case EnumActionTag2:
                    self.text2 = data2;
                    break;
                case EnumActionTag3:
                    self.text3 = data2;
                    break;
                case EnumActionTag4:
                    self.text4 = data2;
                    break;
                case EnumActionTag5:
                    self.text5 = data2;
                    break;
                case EnumActionTag6:
                    self.text6 = data2;
                    break;
                    break;
                default:
                    break;
            }
    }];
    return cell;
}

- (PaymentAccountVM *)vm {
    if (!_vm) {
        _vm = [PaymentAccountVM new];
    }
    return _vm;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
