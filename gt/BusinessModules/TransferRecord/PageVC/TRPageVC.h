//
//  PageViewController.h
//  TestTabTitle
//
//  Created by Aalto on 2018/12/20.
//  Copyright © 2018年 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TRPageListView;
@interface TRPageVC : UIViewController
- (void)actionBlock:(ActionBlock)block;
@property (nonatomic,copy)NSString *tag;
- (void)trpageListView:(TRPageListView *)view requestListWithPage:(NSInteger)page;
@end
