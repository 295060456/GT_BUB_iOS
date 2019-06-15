//
//  CertificationView.h
//  OTC
//
//  Created by Terry.c on 2018/11/26.
//  Copyright © 2018 yang peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AliyunQuery.h"
#import "TZImagePickerController.h"
#import <SDWebImage/UIImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN
@interface CertificationView : UIView
- (void)actionBlock:(DataBlock)block;
-(void)setReviewStatu;
@end

NS_ASSUME_NONNULL_END
