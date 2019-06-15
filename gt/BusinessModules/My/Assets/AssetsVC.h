//
//  AssetsVC.h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetsVC : BaseVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
