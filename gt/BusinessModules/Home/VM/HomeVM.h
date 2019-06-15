//

#import <Foundation/Foundation.h>
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeVM : NSObject

- (void)network_checkFixedPricesSuccess:(DataBlock)success
                                 failed:(DataBlock)failed
                                  error:(DataBlock)err;
//这里也可以用代理回调网络请求
- (void)network_getHomeListWithPage:(NSInteger)page
                            success:(DataBlock)success
                             failed:(DataBlock)failed
                              error:(DataBlock)err;

- (void)network_getTrendsListWithPage:(NSInteger)page
                              success:(void(^)(NSArray *dataArray))success
                               failed:(void(^)(void))failed;

//收款方式列表
- (void)network_accountListRequestParams:(id _Nullable)requestParams
                                 success:(DataBlock)success
                                  failed:(DataBlock)failed
                                   error:(DataBlock)err;
// 一键购买
- (void)networkNoeBuyBubPostDataWith:(NSDictionary*)postDic
                           esSuccess:(DataBlock)success
                              failed:(DataBlock)failed
                               error:(DataBlock)err;

@end

NS_ASSUME_NONNULL_END
