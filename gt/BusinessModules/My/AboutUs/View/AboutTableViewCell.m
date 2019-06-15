//
//  AboutTableViewCell.m
//  gt
//
//  Created by bub chain on 15/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AboutTableViewCell.h"
#import "AboutUsVCViewModel.h"

@implementation AboutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.circle.layer.masksToBounds = YES;
    self.circle.layer.cornerRadius = self.circle.width/2;
}

- (void) setData:(NSDictionary *)data{
    if (data) {
        self.title.text = data[@"title"];
        NSString *version = data[@"version"];
        NSString *newVersion = data[@"newVersion"];
        BOOL isVersion = version && version.length>0;
        self.version.hidden = !isVersion;
        if (isVersion) {
            NSInteger integer = [AboutUsVCViewModel compareVersion2:version to:newVersion];
            if (integer==-1) {//有最新版
                self.version.text = [@"V " stringByAppendingString:newVersion];
                self.circle.hidden = NO;
                self.arrow.hidden = NO;
                self.versionLeading.constant = 3;
            }else{//无新版
                self.version.text = [@"V " stringByAppendingString:version];
                self.circle.hidden = YES;
                self.arrow.hidden = YES;
                self.versionLeading.constant = -10;
            }
        }else{
            self.arrow.hidden = NO;
            self.circle.hidden = YES;
        }
    }
}

- (void) setVersionContent:(NSString *)versionContent{
    if (versionContent && versionContent.length>0) {
//        self.num.text = [NSString stringWithFormat:@"%lu.",self.indexPath.row+1];
        self.content.text = versionContent;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
