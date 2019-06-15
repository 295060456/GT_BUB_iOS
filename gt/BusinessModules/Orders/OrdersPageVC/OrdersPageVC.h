//
//  PageViewController.h
//  TestTabTitle
//
//  Created by Aalto on 2018/12/20.
//  Copyright © 2018年 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrdersPageListView.h"

@interface OrdersPageVC : UIViewController

@property (nonatomic, strong) OrdersPageListView *mainView;

@property (nonatomic,copy)NSString *tag;
@property (nonatomic,strong) NSString *titleType;
@property (nonatomic,assign)UserType utype;

- (void)actionBlock:(TwoDataBlock)block;

- (void)ordersPageListView:(OrdersPageListView *)view
       requestListWithPage:(NSInteger)page;

@end
