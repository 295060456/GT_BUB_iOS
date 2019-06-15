//
//  ChatBaseCell.h
//  gt
//
//  Created by cookie on 2018/12/31.
//  Copyright © 2018 GT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageLayout.h"
NS_ASSUME_NONNULL_BEGIN

@class ChatBaseCell;

@protocol ChatBaseCellDelegate <NSObject>

//点击头像
-(void)ChatHeaderImgCellClick:(NSInteger)index indexPath:(NSIndexPath *)indexPath;

//点击文本cell
-(void)ChatTextCellClick:(NSIndexPath*)indexPath index:(NSInteger)index layout:(ChatMessageLayout *)layout;

//点击cell图片和短视频
-(void)ChatImageVideoCellClick:(NSIndexPath *)indexPath layout:(ChatMessageLayout *)layout;

//点击定位cell
-(void)ChatMapCellClick:(NSIndexPath*)indexPath layout:(ChatMessageLayout *)layout;


@end

@interface ChatBaseCell : UITableViewCell

-(void)initSSChatCellUserInterface;

@property(nonatomic,assign)id<ChatBaseCellDelegate>delegate;

@property(nonatomic, strong) NSIndexPath           *indexPath;
@property(nonatomic, strong) ChatMessageLayout  *layout;

//撤销 删除 复制
@property(nonatomic, strong) UIMenuController *menu;

//头像  时间  背景按钮
@property(nonatomic, strong) UIButton *mHeaderImgBtn;
@property(nonatomic, strong) UILabel  *mMessageTimeLab;
@property(nonatomic, strong) UIButton  *mBackImgButton;

//消息按钮
-(void)buttonPressed:(UIButton *)sender;

//文本消息
@property(nonatomic, strong) UITextView     *mTextView;

//图片消息
@property(nonatomic,strong) UIImageView *mImgView;

//视频消息
@property(nonatomic,strong) UIButton *mVideoBtn;
@property(nonatomic,strong) UIImageView *mVideoImg;


@end

NS_ASSUME_NONNULL_END
