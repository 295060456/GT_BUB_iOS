//
//  TCGoogleCodeModel.h
//  OTC
//
//  Created by Terry.c on 2018/11/25.
//  Copyright © 2018 yang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoogleSecretData : NSObject
@property (nonatomic, strong) NSString *qrcodeurl;
@property (nonatomic, strong) NSString *secret;
@end

@interface GoogleSecretModel : NSObject
@property (nonatomic, strong) GoogleSecretData *resultinfo;
@property (nonatomic, strong) NSString *err_code;
@property (nonatomic, strong) NSString *msg;
@end

NS_ASSUME_NONNULL_END
