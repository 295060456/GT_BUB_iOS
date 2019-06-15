//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostAppealSubDataItem;

@interface PostAppealCell : UITableViewCell

@property(nonatomic,strong)id requestParams;

@property (nonatomic,strong)NSArray * letter;

+(CGFloat)cellHeightWithModel:(id)model;

+(instancetype)cellWith:(UITableView*)tabelView
          requestParams:(id)requestParams
                   data:(id)data;

- (void)actionBlock:(TwoDataBlock)block;

- (void)txActionBlock:(DataBlock)block;

- (void)richElementsInCellWithModel:(id)model;

-(void)chengButtonTextString:(NSString*)s;


@end
