//
//  PostAdsPayChooseCell.h
//  gt
//
//  Created by 鱼饼 on 2019/5/23.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface PostAdsPayChooseCell : UITableViewCell

//@property (nonatomic ,strong) AccountPaymentWayModel *cellModel;

-(void)realCellDataWithModel:(AccountPaymentWayModel *)cellModel withChooseAr:(NSMutableArray*)chooseArr andShowBottomLien:(BOOL)show block:(DataBlock)block;

@end


