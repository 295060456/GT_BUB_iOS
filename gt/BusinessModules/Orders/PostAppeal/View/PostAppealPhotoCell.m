//
//  PostAppealPhotoCell.m
//  gt
//
//  Created by Administrator on 23/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "PostAppealPhotoCell.h"

@interface PostAppealPhotoCell ()



@end

@implementation PostAppealPhotoCell

+(instancetype)cellWith:(UITableView*)tabelView{
    
    PostAppealPhotoCell *cell = (PostAppealPhotoCell *)[tabelView dequeueReusableCellWithIdentifier:@"PostAppealPhotoCell"];
    
    if (!cell) {
        
        cell = [[PostAppealPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostAppealPhotoCell"];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)initView{
    
    //标题
    UILabel *titleLab = UILabel.new;
    
    titleLab.text = @"请上传您的支付截图凭证:";
    
    titleLab.textColor = RGBCOLOR(35, 38, 48);
    
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    
    [self.contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(5);
        
        make.left.equalTo(self.contentView).offset(20);
    }];
    
    //图片
    self.photoBtn = UIButton.new;
    
    [self.photoBtn setImage:kIMG(@"tianjiaX")
              forState:UIControlStateNormal];
    
    [NSObject cornerCutToCircleWithView:self.photoBtn
                        AndCornerRadius:4];
    
    [self.photoBtn addTarget:self
                      action:@selector(photo:)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.photoBtn];
    
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(titleLab);
        
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        
        make.size.mas_equalTo(CGSizeMake(126, 80));
    }];
}

-(void)photo:(UIButton *)sender{
    
    if (self.PhotoBlock) {
        
        self.PhotoBlock();
    }
}



@end
