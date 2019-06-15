//
//  AboutTableViewCell.h
//  gt
//
//  Created by bub chain on 15/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *circle;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionLeading;
@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (nonatomic, strong) NSString *versionContent;
@end

NS_ASSUME_NONNULL_END
