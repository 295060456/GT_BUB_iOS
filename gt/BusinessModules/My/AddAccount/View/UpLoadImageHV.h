//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class TransactionData;
@interface UpLoadImageHV : UIView

- (void)actionBlock:(DataBlock)block;
//- (void)richElementsInHeaderWithModel:(NSDictionary*)data;
- (instancetype)initWithFrame:(CGRect)frame WithModel:(id)requestParams;
- (instancetype)initWithFrame:(CGRect)frame WithNotYetVertifyModel:(id)requestParams;
@end
