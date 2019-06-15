
//
//  PHIndexScrollBanner.m
//  PregnancyHelper
//
//  Created by AaltoChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "ScrollBannerCell.h"
#import "SDCycleScrollView.h"
@interface ScrollBannerCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;

@property (nonatomic, copy) ActionBlock block;

@end
@implementation ScrollBannerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kWhiteColor;
        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat scrollViewHeight = [ScrollBannerCell cellHeight];
        _sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 20, 0, MAINSCREEN_WIDTH-40, scrollViewHeight)  placeholderImage:[UIImage imageNamed:@"LONG_PLACEDHOLDER_IMG"]];
        _sdCycleScrollView.autoScrollTimeInterval = 2.0;
        _sdCycleScrollView.autoScroll = NO;
        _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sdCycleScrollView.currentPageDotColor = HEXCOLOR(0xc6c6c6); // 自定义分页控件小圆标颜色
        
        [self.contentView addSubview:_sdCycleScrollView];
    }
    
    return self;
}

+ (CGFloat)cellHeight{
    return kGETVALUE_HEIGHT(335, 120, MAINSCREEN_WIDTH);
}

+ (instancetype)cellWith:(UITableView*)tabelView{
    ScrollBannerCell *cell = (ScrollBannerCell *)[tabelView dequeueReusableCellWithIdentifier:@"ScrollBannerCell"];
    if (!cell) {
        cell = [[ScrollBannerCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ScrollBannerCell"];
    }
    return cell;
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)richElementsInCellWithModel:(NSMutableArray*)imagesModels{
    
    NSMutableArray* imageURLStrings = [NSMutableArray array];
//    NSMutableArray* imageTitles = [NSMutableArray array];
    
    if (imagesModels.count>0) {
        for (int i=0; i<imagesModels.count; i++) {
            NSDictionary *model = imagesModels[i];
            [imageURLStrings addObject:model[kImg]];
        }
    }
    
    _sdCycleScrollView.imageURLStringsGroup = imageURLStrings;
    
    if (imagesModels.count==1) {
        
        _sdCycleScrollView.autoScroll = NO;
    }else{
        
        _sdCycleScrollView.autoScroll = YES;
    }

    kWeakSelf(self);
    
    _sdCycleScrollView.clickItemOperationBlock = ^(NSInteger index) {

        kStrongSelf(self);
        
        NSDictionary *model = imagesModels[index];
        if (self.block) {
            self.block(model);
        }
    };
    
}
@end
