//

#import <Foundation/Foundation.h>
#import "TransferModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface TransferVM : NSObject
- (void)network_transferBrokeageRateSuccess:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
- (void)network_postMultiTransferWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
- (void)network_postTransferWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
