//
//  FaceIDMegNetwork.m
//  gt
//
//  Created by 鱼饼 on 2019/5/1.
//  Copyright © 2019 GT. All rights reserved.
//

#import "FaceIDMegNetwork.h"


@implementation FaceIDMegNetwork


+(void)getFaceIDTokenSuccess:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_FeacIDToken] andType:All andWith:@{} success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
                NSString *toKenSington = [NSString stringWithFormat:@"%@",dic[@"bizToken"]];
                success(toKenSington);
        }else{
            [YKToastView showToastText:dic[@"msg"]];
        }
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
    }];
}



+(void)postFaceIDWithBizTonken:(NSString*)token Success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    
    
    NSDictionary* proDic =@{@"bizToken": token
                            };
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_FaceIDResults] andType:All andWith:proDic success:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
                [YKToastView showToastText:@"认证通过!"];
                 success(dic);
        }
        else{
            [YKToastView showToastText:dic[@"msg"]];
        }
    } error:^(NSError *error) {
        err(error);
        [SVProgressHUD dismiss];
        [YKToastView showToastText:error.description];
    }];
}


@end
