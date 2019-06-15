//
//  UserInfoViewModel.h
//  gt
//
//  Created by XiaoCheng on 10/06/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoViewModel : NSObject
@property (nonatomic, strong) RACCommand *verificationPWRequest;
@property (nonatomic, strong) NSString *pwText;
@property (nonatomic, strong) RACSignal *nextSignal;

@property (nonatomic, strong) NSString *areaCode;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) RACSignal *verificationSignal;
@property (nonatomic, strong) RACCommand *verificationPhoneRequest;
@end

NS_ASSUME_NONNULL_END
