//
//  XcChangeTelephoneVC.m
//  gt
//
//  Created by XiaoCheng on 10/06/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "XcChangeTelephoneVC.h"
#import "UserInfoViewModel.h"
#import "InputVerificationCodeVC.h"

@interface XcChangeTelephoneVC ()
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;
@property (nonatomic, strong) UserInfoViewModel *viewModel;
@end

@implementation XcChangeTelephoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel.areaCode = @"86";
}

- (UserInfoViewModel *)viewModel{
    if (!_viewModel) { _viewModel = UserInfoViewModel.new;}
    return _viewModel;
}

- (void)bindViewModelRequest{
    [self.phoneNumber.rac_textSignal subscribe:RACChannelTo(self.viewModel,phoneNum)];
    RAC(self.verificationCodeBtn,enabled) = self.viewModel.verificationSignal;
    
    @weakify(self)
    [[self.phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self getCountryOrRegionTelephoneNumCodeBtnClickEvent:nil];
    }];
    
    [[self.verificationCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.viewModel.verificationPhoneRequest execute:nil];
    }];
    
    [self.viewModel.verificationPhoneRequest.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [InputVerificationCodeVC pushFromVC:self  requestParams:@[self.viewModel.areaCode,self.viewModel.phoneNum] success:^(id data) {}];
    }];
}

-(void)getCountryOrRegionTelephoneNumCodeBtnClickEvent:(UIButton *)sender{
    
    XWCountryCodeController *countryCodeVC = [[XWCountryCodeController alloc] init];
    @weakify(self)
    countryCodeVC.countryCodeBlock = ^(NSString *countryName, NSString *code) {
        @strongify(self)
        self.viewModel.areaCode = code;
        [self.phoneBtn setTitle:[@"+"stringByAppendingString:code] forState:UIControlStateNormal];
    };
    
    [self presentViewController:countryCodeVC
                       animated:YES
                     completion:Nil];
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
