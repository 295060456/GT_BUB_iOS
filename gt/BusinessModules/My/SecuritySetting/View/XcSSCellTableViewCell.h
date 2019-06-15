//
//  XcSSCellTableViewCell.h
//  gt
//
//  Created by bub chain on 20/05/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XcSSCellTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *data;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

NS_ASSUME_NONNULL_END
