//
//  OTCConversationListCellTableViewCell.m
//  gt
//
//  Created by Administrator on 27/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "OTCConversationListCellTableViewCell.h"

@interface OTCConversationListCellTableViewCell ()

@end

@implementation OTCConversationListCellTableViewCell

//
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    //
    if(self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        //
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];  // 此处设置无效，willdisplay中设置
        [self setupUI];
    }
    
    return self;
}
//
-(void)setupUI{
    
    // bg
    UIImageView *bgImgV=[UIImageView new];
//    [bgImgV setImage:[UIImage imageNamed:@"messageList"]];
    [bgImgV setImage:[UIImage imageWithColor:kRedColor]];
    [bgImgV setContentMode:UIViewContentModeTop];
    [self addSubview:bgImgV];
    [bgImgV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 10, 10, 10)];
    
    
    // photo
    UIImageView *photoImgV=[UIImageView new];
    _photoImgV=photoImgV;
    [photoImgV.layer setMasksToBounds:true];
    [photoImgV.layer setCornerRadius:50/2];
    [bgImgV addSubview:photoImgV];
    [photoImgV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [photoImgV autoSetDimension:ALDimensionWidth toSize:50];
    [photoImgV autoSetDimension:ALDimensionHeight toSize:50];
    [photoImgV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:5];
    
    
    // name
    UILabel *nameL=[UILabel new];
    _nameL=nameL;
//    [nameL setFont:YTFONT_PF_S(15)];
//    [nameL setTextColor:YTColorFromRGB(0x414141)];
    [bgImgV addSubview:nameL];
    [nameL autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:photoImgV];
    [nameL autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:photoImgV withOffset:5];
    [nameL autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:80];
    
    
    // content
    UILabel *contentL=[UILabel new];
    _contentL=contentL;
    contentL.backgroundColor = [UIColor yellowColor];
//    [contentL setFont:YTFONT_PF(13)];
//    [contentL setTextColor:YTColorFromRGB(0x414141)];
    [bgImgV addSubview:contentL];
    [contentL autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:nameL];
    [contentL autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:photoImgV];
    [contentL autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:36];
    
    
    // time
    UILabel *timeL=[UILabel new];
    _timeL=timeL;
    timeL.backgroundColor = [UIColor greenColor];
//    [timeL setFont:YTFONT_PF(15)];
//    [timeL setTextColor:YTColorFromRGB(0x5d5d5d)];
    [bgImgV addSubview:timeL];
    [timeL autoAlignAxis:ALAxisHorizontal toSameAxisOfView:nameL];
    [timeL autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    
    //
    UILabel *numL=[UILabel new];
    _numL=numL;
    [numL setTextAlignment:NSTextAlignmentCenter];
    [numL setBackgroundColor:[UIColor redColor]];
    [numL.layer setCornerRadius:15/2];
    [numL.layer setMasksToBounds:true];
//    [numL setFont:YTFONT_PF(12)];
//    [numL setTextColor:YTColorFromRGB(0xffffff)];
    [bgImgV addSubview:numL];
    [numL autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:timeL];
    [numL autoSetDimension:ALDimensionWidth toSize:15];
    [numL autoSetDimension:ALDimensionHeight toSize:15];
    [numL autoAlignAxis:ALAxisHorizontal toSameAxisOfView:contentL];
}

-(void)setConvM:(RCConversationModel *)convM
    withIsFirst:(BOOL)isF
   withUserInfo:(RCUserInfo *)info{
    //
//    [_timeL setText:[YTConvertToTimeTool ConvertChatMessageTime:(convM.receivedTime>convM.sentTime?convM.receivedTime:convM.sentTime)/1000]];
    
    [_numL setText:[NSString stringWithFormat:@"%ld",convM.unreadMessageCount]];
    if(convM.unreadMessageCount == 0){
        [_numL setHidden:true];
    }else{
        [_numL setHidden:false];
    }
    
    if(isF){
        //
        NSString *titleStr=@"YOTO   官方   ";
//        NSMutableAttributedString *muT=[[NSMutableAttributedString alloc]initWithString:titleStr attributes:@{NSForegroundColorAttributeName:YTColorFromRGB(0x414141),NSFontAttributeName:YTFONT_PF_S(15)}];
//        [muT addAttributes:@{NSFontAttributeName:YTFONT_PF_S(12),NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:YTMainColor} range:[titleStr rangeOfString:@" 官方 "]];
//        [_nameL setAttributedText:muT];

        [_photoImgV setImage:[UIImage imageNamed:@"official"]];
        
        if(convM.lastestMessage){
            [_contentL setText:((RCTextMessage *)convM.lastestMessage).content];
        }
    }else if(info){
//        [_photoImgV sd_setImageWithURL:[NSURL URLWithString:info.portraitUri] placeholderImage:[UIImage imageNamed:@"userList"]];
        [_nameL setText:info.name];
        [_contentL setText:((RCTextMessage *)convM.lastestMessage).content];
    }
}
@end
