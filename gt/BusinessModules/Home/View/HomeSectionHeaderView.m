

//
//  HomeSectionHeaderView.m
//
//  Created by AaltoChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "HomeSectionHeaderView.h"
#define kHeightForHeaderInSections  56//12+17+18+9
@interface HomeSectionHeaderView()
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation HomeSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[HomeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HomeSectionHeaderViewReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kHeightForHeaderInSections);
        
        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 12)];
        self.sectionLine.backgroundColor = HEXCOLOR(0xf6f5fa);
        ;
        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.sectionLine];
        
        
        _topicRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicRefreshBtn.hidden = NO;
        [self.contentView addSubview:_topicRefreshBtn];
        _topicRefreshBtn.origin = CGPointMake( 32 , 12);
        _topicRefreshBtn.size = CGSizeMake(180, kHeightForHeaderInSections-12);
        _topicRefreshBtn.layer.borderWidth=0.0;
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _topicRefreshBtn.titleLabel.font = kFontSize(13);
        _topicRefreshBtn.titleLabel.numberOfLines = 1;
        [_topicRefreshBtn setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        [_topicRefreshBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 17, 180, 18)];
        _titleLabel.font = kFontSize(13);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor =  HEXCOLOR(0x000000);
        _icon = [[UIImageView alloc]init];
        [self.contentView addSubview:_icon];
        
    }
    return self;
}
+ (CGFloat)viewHeight
{
    return kHeightForHeaderInSections;
}

- (void)richElementsInViewWithModel:(id)model{
    IndexSectionType type = [model[kIndexSection] integerValue];
    NSArray* arr = (NSArray*)(model[kIndexInfo]);
    NSString* title =  arr[0];
    NSString* subTitle = arr[1];
    self.sectionLine.hidden = NO;
    
    switch (type) {
        case IndexSectionOne:{
            _sectionLine.hidden = NO;
            [_topicRefreshBtn setImage:[UIImage imageNamed:subTitle] forState:UIControlStateNormal];
            [_topicRefreshBtn setTitle:title forState:UIControlStateNormal];
            [_topicRefreshBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:13];
            
        }
            break;
//        
        default:{
            _sectionLine.hidden = YES;
        }
            break;
    }
}

- (void)refreshTopic:(UIButton*)sender {

}
@end
