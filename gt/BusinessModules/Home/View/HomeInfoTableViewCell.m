//
//  HomeInfoTableViewCell.m
//  OTC
//
//  Created by David on 2018/11/21.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import "HomeInfoTableViewCell.h"
#import "HomeModel.h"
@implementation HomeInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWith:(UITableView*)tabelView{
    [tabelView registerNib:[UINib nibWithNibName:@"HomeInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeInfoTableViewCell"];
    HomeInfoTableViewCell *cell = (HomeInfoTableViewCell *)[tabelView dequeueReusableCellWithIdentifier:@"HomeInfoTableViewCell"];
    if (!cell) {
        cell = [[HomeInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeInfoTableViewCell"];
       
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeightWithModel:(HomeData*)data{
    
    return 80;
}

-(UIView*)views{
    if (_views==nil) {
        _views = [[UIView alloc] initWithFrame:CGRectMake(7.5, 7.5, 40, 40)];
        [self.contentView addSubview:_views];
        CALayer *subLayer=[CALayer layer];
        CGRect fixframe = _views.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=20;
        subLayer.backgroundColor=[[UIColor whiteColor] colorWithAlphaComponent:1].CGColor;
        subLayer.masksToBounds=NO;
        subLayer.shadowColor = HEXCOLOR(0x272727).CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.08;//阴影透明度，默认0
        subLayer.shadowRadius = 3;//阴影半径，默认3
        [_views.layer insertSublayer:subLayer below:_views.layer];
    } return _views;
}

- (void)richElementsInCellWithModel:(HomeData*)listModel{
    
    [self.contentView addSubview:self.views];
    
    self.homeCoinLab.text = [NSString stringWithFormat:@"%.2f",[listModel.price floatValue]];
    
    self.homeRMBLab.text = [NSString stringWithFormat:@"≈￥ %.2f",[listModel.rmbPrice floatValue]];
//    self.homeTypeLab.backgroundColor = kRedColor;
    
    self.homeTypeLab.text = listModel.coinId;
    
//    self.homeTypeImage.image = [UIImage imageNamed:listModel.coinId];
    [self.homeTypeImage setImageWithURL:[NSURL URLWithString:listModel.coinImageUrl] placeholderImage:kIMG(@"icon-in-app")];
    [self.contentView bringSubviewToFront:self.homeTypeImage];
    if ([listModel.upAndDown floatValue] > 0) {
        self.homeUpDownLab.text = [NSString stringWithFormat:@"+%@",listModel.upAndDown];
        self.homeUpDownLab.textColor = HEXCOLOR(0xff2525);
        self.homeUpDownLab.backgroundColor =  HEXCOLOR(0xffe6ed);
    }else{
        self.homeUpDownLab.text = [NSString stringWithFormat:@"%@",listModel.upAndDown];
        self.homeUpDownLab.textColor = HEXCOLOR(0x00c6b0);
        self.homeUpDownLab.backgroundColor = HEXCOLOR(0xedf6fd);
    }
    self.homeUpDownLab.layer.cornerRadius = 15;
    self.homeUpDownLab.layer.masksToBounds = YES;
}
@end
