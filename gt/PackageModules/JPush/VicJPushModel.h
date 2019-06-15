//
//  VicJPushModel.h
//  OTC
//
//  Created by Dodgson on 2/23/19.
//  Copyright © 2019 yang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VicPushPageType){
    VicPushPageType_OrderDetail         = 1,
};


@interface VicJPushModel : NSObject

@property (nonatomic, assign) VicPushPageType pageType;

@property (nonatomic, copy) NSDictionary *param;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@end
