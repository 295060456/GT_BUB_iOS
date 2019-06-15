//
//  ChatKeyBoardSymbolView.h
//  gt
//
//  Created by cookie on 2018/12/31.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatKeyBoardDatas.h"
#import "ChatIMEmotionModel.h"
#import "UIImage+SSAdd.h"


/**
 表情视图底部发送和表情筛选部分
 */
#define SSChatKeyBordSymbolFooterH  40

@protocol ChatKeyBordSymbolFooterDelegate <NSObject>

-(void)SSChatKeyBordSymbolFooterBtnClick:(UIButton *)sender;

@end


@interface ChatKeyBordSymbolFooter : UIView

@property(nonatomic,assign)id<ChatKeyBordSymbolFooterDelegate>delegate;

//表情切换的滚动视图(其实没有很多，为了能拓展就用这个吧)
@property (nonatomic,strong)UIScrollView *emojiFooterScrollView;
//发送按钮
@property (nonatomic,strong)UIButton *sendButton;
//第一类表情 第二类表情
@property (nonatomic,strong)UIButton *mButton1,*mButton2;


@end



/**
 表单cell
 */

#define SSChatEmojiCollectionCellId  @"SSChatEmojiCollectionCellId"
#define DeleteButtonId               @"DeleteButtonId"

@interface ChatEmojiCollectionCell : UICollectionViewCell

@property (nonatomic,strong)NSString *string;
@property (nonatomic,strong)UIImage *image;
@property (nonatomic,strong)UIButton *button;

@end




/**
 表情列表视图
 */
@protocol ChatKeyBordSymbolViewDelegate <NSObject>

-(void)SSChatKeyBordSymbolViewBtnClick:(NSInteger)index;
//点击其中的一个表情或者删除按钮
- (void)SSChatKeyBordSymbolCellClick:(NSObject *)emojiText;

@end

@interface ChatKeyBoardSymbolView : UIView<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ChatKeyBordSymbolFooterDelegate>

@property(nonatomic,assign)id<ChatKeyBordSymbolViewDelegate>delegate;

@property(nonatomic,strong)ChartEmotionImages *emotion;
@property (nonatomic,strong)NSMutableArray *defaultEmoticons;
@property (nonatomic,strong)NSMutableArray *emoticonImages;

//每一页的表情数量
@property (nonatomic,assign)NSInteger number;
//底部pagecontroller显示的数量
@property (nonatomic,assign)NSInteger numberPage;
@property (nonatomic,assign)NSInteger numberPage1;
@property (nonatomic,assign)NSInteger numberPage2;


@property(nonatomic,strong) ChatKeyBordSymbolFooter *footer;


@property (nonatomic,strong)ChatCollectionViewFlowLayout *layout;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIPageControl *pageControl;

@end


