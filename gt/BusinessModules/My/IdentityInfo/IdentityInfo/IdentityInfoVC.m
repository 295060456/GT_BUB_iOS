
#import "IdentityInfoVC.h"
#import "CertificationView.h"
#import "LoginVM.h"
#import "LoginModel.h"
#import "IdentityAuthModel.h"

@interface IdentityInfoVC ()
@property (nonatomic, strong) LoginModel* requestParams;
//@property (nonatomic, strong) CerSuccessView *successView;
@property (nonatomic, strong) CertificationView *certificationView;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, copy) DataBlock block;
@end

@implementation IdentityInfoVC
#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    IdentityInfoVC *vc = [[IdentityInfoVC alloc] init];
    vc.block = block;
    vc.requestParams = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];//requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
//    self.title = @"认证信息";
//    [self createScrollview];
    [self initViews];
}

-(void)initViews {

    [self.view addSubview:self.certificationView];
    [self.certificationView actionBlock:^(id data) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.certificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)createScrollview{}

-(CertificationView*)certificationView {
    if (!_certificationView) {
        _certificationView = [[CertificationView alloc] init];
    }
    return _certificationView;
}

@end

