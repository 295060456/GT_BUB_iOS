
#import <Foundation/Foundation.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsVM : NSObject

- (void)network_getAssetsListWithPage:(NSInteger)page
                     WithExchangeType:(ExchangeType)type
                              success:(TwoDataBlock)success
                               failed:(DataBlock)failed
                                error:(DataBlock)err;

- (void)network_getUserAssertSuccess:(DataBlock)success
                              failed:(DataBlock)failed
                               error:(DataBlock)err;

@end

NS_ASSUME_NONNULL_END
