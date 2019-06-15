//
//  ChatKeyBordFunctionView.h
//  gt
//
//  Created by cookie on 2018/12/31.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatKeyBoardDatas.h"


NS_ASSUME_NONNULL_BEGIN

/**
 多功能视图
 */

@protocol ChatKeyBordFunctionViewDelegate <NSObject>

-(void)SSChatKeyBordFunctionViewBtnClick:(NSInteger)index;

@end

@interface ChatKeyBordFunctionView : UIView<UIScrollViewDelegate>

@property(nonatomic,assign)id<ChatKeyBordFunctionViewDelegate>delegate;

@property(nonatomic,strong)UIScrollView  *mScrollView;
@property(nonatomic,strong)UIPageControl *pageControll;

@end

NS_ASSUME_NONNULL_END
