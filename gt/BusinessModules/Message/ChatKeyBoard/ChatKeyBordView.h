//
//  ChatKeyBordView.h
//  gt
//
//  Created by cookie on 2018/12/31.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatKeyBoardDatas.h"
#import "ChatKeyBoardSymbolView.h"
#import "ChatKeyBordFunctionView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 多功能界面+表情视图的承载视图
 */

@protocol ChatKeyBordViewDelegate <NSObject>

//点击其他按钮
-(void)SSChatKeyBordViewBtnClick:(NSInteger)index type:(KeyBordViewFouctionType)type;

//点击表情
-(void)SSChatKeyBordSymbolViewBtnClick:(NSObject *)emojiText;

@end
@interface ChatKeyBordView : UIView<UIScrollViewDelegate,ChatKeyBordSymbolViewDelegate,ChatKeyBordFunctionViewDelegate>

@property(nonatomic,assign)id<ChatKeyBordViewDelegate>delegate;

//弹窗界面是表情还是其他功能
@property(nonatomic,assign)KeyBordViewFouctionType type;
//表情视图
@property(nonatomic,strong)ChatKeyBoardSymbolView   *symbolView;
//多功能视图
@property(nonatomic,strong)ChatKeyBordFunctionView *functionView;
//覆盖视图
@property(nonatomic,strong)UIView *mCoverView;

@end



NS_ASSUME_NONNULL_END
