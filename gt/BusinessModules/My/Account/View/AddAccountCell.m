//
//  AddAccountCell.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/20.
//  Copyright © 2018年 GT. All rights reserved.
//

#import "AddAccountCell.h"
@interface AddAccountCell ()

@property (nonatomic, strong) UIImageView * cellImgView;
@property (nonatomic, strong) UILabel * cellTittleLb;
@property (nonatomic, copy) UIImageView * typeImgView;
@property (nonatomic, copy) DataBlock block;

@end
@implementation AddAccountCell

+(CGFloat)cellHeightWithModel{
    return  165/3;
}
+(instancetype)cellWith:(UITableView*)tabelView{
    AddAccountCell *cell = (AddAccountCell *)[tabelView dequeueReusableCellWithIdentifier:@"AddAccountCell"];
    if (!cell) {
        cell = [[AddAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddAccountCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)richElementsInCellWithModel:(NSDictionary*)model WithIndexRow:(NSInteger)row SelectedRow:(NSInteger)selectedRow{
    self.cellTittleLb.text = model.allKeys[0];
    self.cellImgView.image = [UIImage imageNamed:model.allValues[0]];
    self.typeImgView.image = [UIImage imageNamed:row == selectedRow?@"iconSucc":@""];
}

- (void)actionBlock:(DataBlock)block
{
    self.block = block;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _cellImgView = [[UIImageView alloc] initWithFrame:CGRectMake(27 * SCALING_RATIO, 13, 29, 29)];
        [self addSubview:_cellImgView];
        
        _cellTittleLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cellImgView.frame) + 10, 15.5, 200, 24)];
        _cellTittleLb.font = [UIFont systemFontOfSize:17];
        [self addSubview:_cellTittleLb];
        _typeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 40-20, 32/2, 20, 20)];
        _typeImgView.backgroundColor = [UIColor colorWithRed:232.0/256 green:236.0/256 blue:241.0/256 alpha:1];
        _typeImgView.layer.cornerRadius = 10;
        _typeImgView.layer.masksToBounds = YES;
        [self addSubview:_typeImgView];
        
    }
    return self;
}
@end
