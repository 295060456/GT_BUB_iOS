//
//  WebViewController.m
//  WebViewProgress
//
//  Created by DK on 17/3/16.
//  Copyright © 2017年 DK. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "UIWebView+DKProgress.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property(nonatomic, assign) DKProgressStyle style;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, copy) DataBlock block;
@end

@implementation WebViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestUrl:(NSString* )requestUrl withProgressStyle:(DKProgressStyle)style success:(DataBlock)block{
    WebViewController *vc = [[WebViewController alloc] init];
    vc.block = block;
    vc.requestUrl = requestUrl;
    vc.style = style;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSURL *url = [[NSURL alloc] initWithString:_requestUrl];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.dk_progressLayer = [[DKProgressLayer alloc] initWithFrame:CGRectMake(0, 40, DK_DEVICE_WIDTH, 4)];
    self.webView.dk_progressLayer.progressColor = [YBGeneralColor themeColor];
    self.webView.dk_progressLayer.progressStyle = _style;
    
    [self.navigationController.navigationBar.layer addSublayer:self.webView.dk_progressLayer];
//    [self showCustomBackButton];
}

/** 显示自定义返回按钮 */
- (void)showCustomBackButton {
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(0, 0, 35, 35);
    [customButton setImage:[UIImage imageNamed:@"naviBackItem"] forState:UIControlStateNormal];
    [customButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
//    [customButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
}

/** 显示自定义title */
- (void)setCustomTitle:(NSString *)title {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleView.font = [UIFont boldSystemFontOfSize:17.0];
    titleView.textColor = kBlackColor;// [YBGeneralColor themeColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = title;
    self.navigationItem.titleView = titleView;
}
#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件 
- (void)YBGeneral_clickBackItem:(UIBarButtonItem *)item {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//- (void)backAction:(UIButton *)sender {
//    if ([_webView canGoBack]) {
//        [_webView goBack];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

#pragma mark - WebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self setCustomTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

- (void)dealloc {
    NSLog(@"%@ - dealloc", NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
