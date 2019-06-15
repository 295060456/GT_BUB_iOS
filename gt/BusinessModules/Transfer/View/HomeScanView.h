//
//  HomeScanView.h
//  OTC
//
//  Created by David on 2018/11/24.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


//typedef void(^clickConfirmBlock)(void);
//typedef void(^buyABBlock)(void);
//typedef void(^HelpBlock)(void);
//typedef void(^cancelBlock)(void);


@interface HomeScanView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *haveInfoLab;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *useHelpBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyABBtn;
@property (weak, nonatomic) IBOutlet UILabel *noMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *ifLab;
@property (weak, nonatomic) IBOutlet UIButton *dontShowBtn;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;

@property (assign, nonatomic) BOOL haveMoney;
@property (copy, nonatomic) NoResultBlock scanBlock;
@property (copy, nonatomic) NoResultBlock buyBlock;
@property (copy, nonatomic) NoResultBlock helpBlock;
@property (copy, nonatomic) NoResultBlock cancelBlock;

@end

NS_ASSUME_NONNULL_END
