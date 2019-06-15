//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//
#import "PostAdsReplyCell.h"
#import "PostAdsModel.h"

@interface PostAdsReplyCell ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *tv;

@property (nonatomic, copy) DataBlock block;
@end

@implementation PostAdsReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    CGRect rect = CGRectMake(16, 12, MAINSCREEN_WIDTH-32, 160);
    UITextView *textView = [[UITextView alloc] initWithFrame:rect];
    textView.delegate = self;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 8;
    textView.font = [UIFont systemFontOfSize:14];
    textView.layer.borderColor = HEXCOLOR(0xf6f5fa).CGColor;
    textView.backgroundColor = HEXCOLOR(0xf6f5fa);
    //文字设置居右、placeHolder会跟随设置
    textView.textAlignment = NSTextAlignmentLeft;
    textView.scrollEnabled = NO;
    textView.textColor = HEXCOLOR(0x000000);
    _tv = textView;
    
    _isHiddenLimitCount = NO;
    [self.contentView addSubview:textView];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
}

+(instancetype)cellWith:(UITableView*)tabelView{
    PostAdsReplyCell *cell = (PostAdsReplyCell *)[tabelView dequeueReusableCellWithIdentifier:@"PostAdsReplyCell"];
    if (!cell) {
        cell = [[PostAdsReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostAdsReplyCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSDictionary*)model{
    return 12+160;
}

- (void)richElementsInCellWithModel:(NSDictionary*)paysDic{
    _tv.zw_placeHolderColor =HEXCOLOR(0xb2b2b2);
    _tv.zw_placeHolder = paysDic.allValues[0];
    if (!_isHiddenLimitCount) {
        _tv.zw_limitCount = 140;
    }
    if (![NSString isEmpty:paysDic.allKeys[0]]) {
        _tv.text = paysDic.allKeys[0];
    }
}

- (void)richElementsInBuyVCCellWithModel:(NSDictionary*)paysDic{
    _tv.layer.borderColor = HEXCOLOR(0xffffff).CGColor;
    _tv.backgroundColor = HEXCOLOR(0xffffff);
    _tv.zw_placeHolderColor =HEXCOLOR(0xb2b2b2);
    _tv.zw_placeHolder = paysDic.allValues[0];
    if (!_isHiddenLimitCount) {
        _tv.zw_limitCount = 140;
    }
    if (![NSString isEmpty:paysDic.allKeys[0]]) {
        _tv.text = paysDic.allKeys[0];
    }
}

- (void)actionBlock:(DataBlock)block{
    
    self.block = block;
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView isEqual:self.tv]) {
        NSString* toBeString = ![NSString isEmpty:self.tv.text]? self.tv.text:@"";
        //过滤表情符
        if ([NSString stringContainsEmoji:toBeString] || [NSString hasEmoji:toBeString]) {
            toBeString = [NSString disableEmoji:toBeString];
        }
        if (self.block) {
            self.block(toBeString);
        }
    }
}

-(BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
replacementText:(NSString *)text{
    
    if ([[textView.textInputMode primaryLanguage] isEqualToString:@"emoji"] ||
        ![textView.textInputMode primaryLanguage]) {
        
        return NO;
    }
    return YES;
}
@end
