//
//  XcSecuritySettingsVM.h
//  gt
//
//  Created by bub chain on 20/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XcSecuritySettingsVM : NSObject
@property (nonatomic, strong) RACCommand *submitRequest;
@property (nonatomic, strong) RACCommand *getUserInfoRequest;
@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) NSString *pw,*nPw;
@property (nonatomic, strong) RACSignal *submitBtnEnabled;
@property (nonatomic, assign) BOOL pwIsEqual;
@end

NS_ASSUME_NONNULL_END
