//
//  EventListTableViewCell.h
//  OTC
//
//  Created by David on 2018/11/18.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EventListAllMessage;
@interface EventListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *EventPic;
@property (weak, nonatomic) IBOutlet UILabel *EventName;
@property (weak, nonatomic) IBOutlet UILabel *EventIndo;
@property (weak, nonatomic) IBOutlet UILabel *EventTime;
@property (weak, nonatomic) IBOutlet UILabel *EventNumber;

+(CGFloat)cellHeightWithModel:(EventListAllMessage*)data;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(EventListAllMessage*)data;
@end

NS_ASSUME_NONNULL_END
