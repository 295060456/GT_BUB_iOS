//
//  AssetsCell.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.
//

#import "AssetsCell.h"
#import "AssetsModel.h"
@interface AssetsCell ()
@property (nonatomic, strong) UILabel * cellTitleLb;
@property (nonatomic, strong) UILabel * cellTimeLb;
@property (nonatomic, strong) UILabel * amountLb;
@end

@implementation AssetsCell
+(CGFloat)cellHeightWithModel{
    return 80;
}
+(instancetype)cellWith:(UITableView*)tabelView{
    AssetsCell *cell = (AssetsCell *)[tabelView dequeueReusableCellWithIdentifier:@"AssetsCell"];
    if (!cell) {
        cell = [[AssetsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AssetsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.cellTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(22, 15, 200, 20)];
        
        self.cellTitleLb.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.cellTitleLb];
        
        self.cellTimeLb = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(_cellTitleLb.frame) + 10, 200, 20)];
        
        self.cellTimeLb.font = [UIFont systemFontOfSize:14];
        self.cellTimeLb.textColor = [UIColor colorWithRed:102.0/256 green:102.0/256 blue:102.0/256 alpha:1];
        [self addSubview:self.cellTimeLb];
        
        self.amountLb = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_cellTitleLb.frame), [[UIScreen mainScreen] bounds].size.width - 20, 20)];
        
        self.amountLb.font = [UIFont systemFontOfSize:17];
        self.amountLb.textColor = [UIColor redColor];
        self.amountLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.amountLb];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(20, 80 - 1, [[UIScreen mainScreen] bounds].size.width - 40, 1)];
        line.backgroundColor = [UIColor colorWithRed:230.0/256 green:230.0/256 blue:230.0/256 alpha:1];
        [self addSubview:line];
    }
    return self;
}
- (void)richElementsInCellWithModel:(AssetsData*)model{
    self.cellTitleLb.text = [model getUserAssetsTypeName];
    self.cellTimeLb.text = model.createdTime;
    self.amountLb.text = [NSString stringWithFormat:@"%@  BUB",[model getUserAssetsNum]];
    self.amountLb.textColor = [model getUserAssetsNumColor];
    
}
@end
