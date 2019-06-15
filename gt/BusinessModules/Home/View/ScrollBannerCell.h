//
//  PHIndexScrollBanner.h
//  PregnancyHelper
//
//  Created by AaltoChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScrollBannerCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *imagesModels;
- (void)actionBlock:(ActionBlock)block;
+(CGFloat)cellHeight;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(NSArray*)imagesModels;
@end
