//
//  NOGoogleThreeViewController.h
//  gt
//
//  Created by cookie on 2018/12/25.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NOGoogleThreeViewController : UIViewController

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id )requestParams
                     style:(NSString *)style
                   success:(DataBlock)block;


//-(instancetype)initWithStyle:(NSString *)style;

@end

NS_ASSUME_NONNULL_END
