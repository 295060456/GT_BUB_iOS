//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//
#import "PostAppealCell.h"
#import "PostAppealModel.h"

@interface PostAppealCell ()<UITextViewDelegate>

@property (nonatomic, strong) UIButton *postAdsButton;

@property (nonatomic, strong)UITextView* rtf0;

@property (nonatomic,strong)UIButton * pickerButton;

@property (nonatomic, strong) UITextView *tv;

@property (nonatomic, strong) NSMutableArray* leftLabs;

@property (nonatomic, strong) NSMutableArray* rightTfs;

@property (nonatomic, copy) TwoDataBlock block;

@property (nonatomic, copy) DataBlock txActionBlock;

@end

@implementation PostAppealCell

-(void)setRequestParams:(id)requestParams{
    
    _requestParams = requestParams;
    
    UITextView *tf = _rightTfs[0];
    
    tf.placeholder = _requestParams;
}

+(instancetype)cellWith:(UITableView*)tabelView
          requestParams:(id)requestParams
                   data:(id)data{
    
    PostAppealCell *cell = (PostAppealCell *)[tabelView dequeueReusableCellWithIdentifier:@"PostAppealCell"];
    
    if (!cell) {
        
        cell = [[PostAppealCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:@"PostAppealCell"];
        
        cell.requestParams = requestParams;
        
        NSDictionary *dicData = data;
        
        cell.letter = dicData[kArr];
    }

    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:@"PostAppealCell"]) {
        
        [self richEles];
    }
    
    return self;
}

+ (CGFloat)cellHeightWithModel:(id)model{
    
    return 250.1f;
}

- (void)richEles{
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self layoutAccountPublic];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
}

-(void)layoutAccountPublic{
    _leftLabs = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    scrollView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.leading.equalTo(self.contentView).offset(30);
        //        make.trailing.equalTo(self.contentView).offset(-30);
        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
        //        make.top.equalTo(self.contentView).offset(47);
        //        make.height.equalTo(@178);
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    UIView *containView = [UIView new];
    containView.backgroundColor = kWhiteColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    //    return;
    UIView *lastView = nil;
    for (int i = 0; i < 3; i++) {
        UIView *sub_view = [UIView new];
        
        UILabel* leftLab = [[UILabel alloc]init];
//        leftLab.text = @"A";
        leftLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.textColor = HEXCOLOR(0x232630);
        leftLab.font = kFontSize(17);
        [sub_view addSubview:leftLab];
        [_leftLabs addObject:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(0);
            make.top.equalTo(sub_view).offset(17);
            make.bottom.equalTo(sub_view).offset(-37);
        }];

        UITextView* tf = [[UITextView alloc] init];
        tf.tag = i;
        tf.delegate = self;
        tf.textAlignment = NSTextAlignmentLeft;
        tf.backgroundColor = kClearColor;
        tf.textColor = HEXCOLOR(0x999999);
        tf.font = kFontSize(15);
        
        tf.zw_placeHolderColor = HEXCOLOR(0xb2b2b2);
        
        [sub_view addSubview:tf];
        [_rightTfs addObject:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(-4);
            make.top.equalTo(sub_view).offset(49);
            make.bottom.equalTo(sub_view).offset(-6);
            make.width.equalTo(@(MAINSCREEN_WIDTH));
        }];
        
        UIImageView* line1 = [[UIImageView alloc]init];
        [sub_view addSubview:line1];
        line1.backgroundColor = HEXCOLOR(0xe8e9ed);

        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(sub_view).offset(83);
            make.height.equalTo(@.5);
        }];
        
        [containView addSubview:sub_view];
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(83));//*i
            
            if (lastView){
                
                make.top.mas_equalTo(lastView.mas_bottom).offset(-3);//下个顶对上个底的间距=上个顶对整个视图顶的间距
                //                //上1个
                //                lastView.backgroundColor = HEXCOLOR(0xf2f1f6);
                //                lastView.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
            }else{
                make.top.mas_equalTo(containView.mas_top);//-15多出来scr
            }
            
        }];
        //最后一个
        //        sub_view.backgroundColor = kWhiteColor;
        //        sub_view.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        
        lastView = sub_view;
    }
    
    // 最后更新containView
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(0);
    }];
    
    self.pickerButton = [[UIButton alloc]init];
    self.pickerButton.layer.masksToBounds = YES;
    self.pickerButton.layer.cornerRadius = 4;
    self.pickerButton.backgroundColor = HEXCOLOR(0xf2f1f6);
    self.pickerButton.titleLabel.font = kFontSize(15);
    [self.pickerButton setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
    self.pickerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [containView addSubview:self.pickerButton];
    [self.pickerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(containView).offset(0);
        make.trailing.equalTo(containView).offset(0);
//        make.top.equalTo(sub_view).offset(49);
        make.bottom.equalTo(containView).offset(8);
        make.height.equalTo(@(40));
    }];
    [_pickerButton addTarget:self
                      action:@selector(buttonClickItem:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self richElementsInViewWithModel];
    
    UIImageView* line1 = [[UIImageView alloc]init];
    [self.pickerButton addSubview:line1];
    UIImage* iconImg = [UIImage imageNamed:@"btnPop"];
    line1.image = iconImg;
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-20.5);
        make.centerY.equalTo(self.pickerButton);
        make.width.equalTo(@(iconImg.size.width));
        make.height.equalTo(@(iconImg.size.height));
    }];
}

- (void)richElementsInViewWithModel{
    UILabel* lab0 = _leftLabs[0];
    lab0.text = @"订单编号";
    UILabel* lab1 = _leftLabs[1];
    lab1.text = @"联系方式";
    UILabel* lab2 = _leftLabs[2];
    lab2.text = @"申诉原因";
    
    UITextView* rtf1 = _rightTfs[1];
    rtf1.placeholder = @"填写邮箱、QQ、或微信号码";
    
    [_pickerButton setTitle:@"     请选择" forState:UIControlStateNormal];
    
//    UITextView* rtf2 = _rightTfs[2];
//    rtf2.placeholder = ;
}

- (void)richElementsInCellWithModel:(NSDictionary*)model{
    
    self.rtf0 = _rightTfs[0];
    
    self.rtf0.text = model[kTip];
    
    self.rtf0.editable = NO;

    self.letter = model[kArr];
}

-(void)chengButtonTextString:(NSString*)s{
     [_pickerButton setTitle:[NSString stringWithFormat:@"%@",s] forState:UIControlStateNormal];
}

- (void)actionBlock:(TwoDataBlock)block{
    
    self.block = block;
}

- (void)buttonClickItem:(UIButton*)sender{
    
    if (self.block) {
        self.block(sender,self.letter);
    }
}

- (void)txActionBlock:(DataBlock)block{
    
    self.txActionBlock = block;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    UITextView* rtf1 = _rightTfs[1];
    if ([textView isEqual:rtf1]) {
        if (self.txActionBlock) {
            self.txActionBlock(![NSString isEmpty:rtf1.text]?rtf1.text:@"");
        }
    }
}
@end
