//  Created by Aalto on 2018/12/28.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PostAppealSectionHeaderView.h"
#define kPostAppealHeightForHeaderInSections  38//15+21
#define kPostAppealHeightForFootInSections  185
@interface PostAppealSectionHeaderView ()
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation PostAppealSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[PostAppealSectionHeaderView class] forHeaderFooterViewReuseIdentifier:PostAppealSectionHeaderReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kPostAppealHeightForHeaderInSections);
        
        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, kPostAppealHeightForHeaderInSections-.5, MAINSCREEN_WIDTH, .5)];
        self.sectionLine.backgroundColor = RGBSAMECOLOR(214)
        ;
        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.sectionLine];
        
        
        _topicRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicRefreshBtn.hidden = YES;
        [self.contentView addSubview:_topicRefreshBtn];
        _topicRefreshBtn.origin = CGPointMake( 0 , 0);
        _topicRefreshBtn.size = CGSizeMake(MAINSCREEN_WIDTH, kPostAppealHeightForHeaderInSections);
        _topicRefreshBtn.layer.borderWidth=0.0;
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _topicRefreshBtn.titleLabel.font = kFontSize(12);
        _topicRefreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [_topicRefreshBtn setTitleColor:kClearColor forState:UIControlStateNormal];
        [_topicRefreshBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 180, kPostAppealHeightForHeaderInSections)];
        _titleLabel.font = kFontSize(17);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor =  HEXCOLOR(0x232630);
        [_topicRefreshBtn addSubview:_titleLabel];
        
        
        _icon = [[UIImageView alloc]init];
        [self.contentView addSubview:_icon];
        
    }
    return self;
}

- (void)richElementsInViewWithModel:(id)model{
    IndexSectionType type = [model[kIndexSection] integerValue];
    NSArray* arr = (NSArray*)(model[kIndexInfo]);
    NSString* title =  arr[0];
    NSString* subTitle = arr[1];
    self.sectionLine.hidden = NO;
    switch (type) {
        case IndexSectionTwo:{
            _topicRefreshBtn.hidden = NO;
            _sectionLine.hidden = YES;
            _topicRefreshBtn.tag = type;
            _titleLabel.textColor =  HEXCOLOR(0x232630);
            _titleLabel.text = title;
//            _titleLabel.attributedText = [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x999999) image:[UIImage imageNamed:@""]] ;
            [_topicRefreshBtn setTitle:subTitle forState:UIControlStateNormal];
        }
            break;
//        
        default:{
            
            _topicRefreshBtn.hidden = YES;
            _sectionLine.hidden = YES;
        }
            break;
    }
}

- (void)refreshTopic:(UIButton*)sender {
    
}
+ (CGFloat)viewHeight
{
    return 36;
}
@end


@interface PostAppealSectionFooterView ()

@property (nonatomic, copy) TwoDataBlock block;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *selectedBtns;

@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (nonatomic, strong)NSDictionary* model;
@end


@implementation PostAppealSectionFooterView

+ (void)sectionFooterViewWith:(UITableView*)tableView{
    [tableView registerClass:[PostAppealSectionFooterView class] forHeaderFooterViewReuseIdentifier:PostAppealSectionFooterReuseIdentifier];
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];
        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kPostAppealHeightForHeaderInSections);
        _postAdsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_postAdsButton];
       _postAdsButton.frame = CGRectMake(MAINSCREEN_WIDTH-kPostAppealHeightForFootInSections, -16, kPostAppealHeightForFootInSections, kPostAppealHeightForHeaderInSections);
        [_postAdsButton addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)refreshTopic:(UIButton*)sender {
    
    if (self.block) {
        self.block(sender,self.model);
        //.clickSectionBlock = ^(NSInteger *sec){
    }
}


-(void)richElementsInViewWithModel:(id)model{
    _model = model;
    IndexSectionType type = [model[kIndexSection] integerValue];
    NSArray* arr = (NSArray*)(model[kIndexInfo]);
    NSString* title =  arr[1];
    NSString* subTitle = arr[2];
    switch (type) {
        case IndexSectionTwo:{
            [_postAdsButton setAttributedTitle:[NSString attributedStringWithString:title stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(14) subString:subTitle subStringColor:[YBGeneralColor themeColor] subStringFont:kFontSize(14) ] forState:UIControlStateNormal];
        }
            break;
            //
        default:{
        }
            break;
    }
}
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

+ (CGFloat)viewHeightWithType:(IndexSectionType)type
{
    return 30;
        
}

@end
