//
//  EventListTableViewCell.m
//  OTC
//
//  Created by David on 2018/11/18.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import "EventListTableViewCell.h"
#import "EventListModel.h"
@implementation EventListTableViewCell
- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    //下分割线
    //    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    CGContextSetStrokeColorWithColor(context,HEXCOLOR(0xf6f5fa).CGColor);
    CGContextStrokeRect(context,CGRectMake(0, rect.size.height-.5, rect.size.width- 0,2));
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    _EventPic.layer.cornerRadius = 21.5;
//    _EventPic.layer.masksToBounds = YES;
//    _EventNumber.layer.cornerRadius = 8.5;
//    _EventNumber.layer.masksToBounds = YES;

}

+(instancetype)cellWith:(UITableView*)tabelView{
    [tabelView registerNib:[UINib nibWithNibName:@"EventListTableViewCell" bundle:nil] forCellReuseIdentifier:@"EventListTableViewCell"];
    EventListTableViewCell *cell = (EventListTableViewCell *)[tabelView dequeueReusableCellWithIdentifier:@"EventListTableViewCell"];
    if (!cell) {
        cell = [[EventListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventListTableViewCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeightWithModel:(EventListAllMessage*)data{
    
    return 120;
}

- (void)richElementsInCellWithModel:(EventListAllMessage*)listModel{
    self.EventName.text = listModel.title;
    self.EventIndo.text = listModel.content;
    self.EventTime.text = listModel.createdTime;
    self.EventNumber.hidden = YES;
    //type 1.订单消息 2.系统消息 3.客服消息
    
    [self.EventPic setImage:kIMG(@"icon-in-app")];
    
}

@end
