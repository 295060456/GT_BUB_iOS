//
//  TransferVC.h
//  OTC
//
//  Created by mac30389 on 2018/11/29.
//  Copyright © 2018 yang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiTransferVC : BaseVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;

@end
