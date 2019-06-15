//
//  VicFaceAuthManager.h
//  OTC
//
//  Created by Dodgson on 2019/1/12.
//  Copyright © 2019 yang peng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VicLandmark){
    VicLandmark_Not         = 0,
    VicLandmark_Check106    = 1,
    VicLandmark_Check83     = 2,
};


NS_ASSUME_NONNULL_BEGIN

@interface VicFaceAuthManager : NSObject

+ (void)authIdentityCardWithImage:(UIImage *)image
                         legality:(BOOL)legality
                successCompletion:(void(^)(id data))successCompletion
                  errorCompletion:(void(^)(NSError *error))errorcompletion;



/**
 *
 *  @brief  人脸识别
 *
 *  @param landmark             是否检测并返回人脸关键点。合法值为 不检测/106个关键点/83个关键点
 *  @param attributes           不检测属性/none gender/age/smiling/headpose/facequality/blur/eyestatus/emotion/ethnicity/beauty/mouthstatus/eyegaze/skinstatus -> 希望检测并返回的属性。需要将属性组成一个用逗号分隔的字符串，属性之间的顺序没有要求。
 *  @param calculate_all        是否检测并返回所有人脸的人脸关键点和人脸属性。如果不使用此功能，则本 API 只会对人脸面积最大的五个人脸分析人脸关键点和人脸属性
 *  @param face_rectangle        是否指定人脸框位置进行人脸检测。如果此参数传入值为空，或不传入此参数，则不使用此功能。本 API 会自动检测图片内所有区域的所有人脸。如果使用正式 API Key 对此参数传入符合格式要求的值，则使用此功能。需要传入一个字符串代表人脸框位置，系统会根据此坐标对框内的图像进行人脸检测，以及人脸关键点和人脸属性等后续操作。系统返回的人脸矩形框位置会与传入的 face_rectangle 完全一致。对于此人脸框之外的区域，系统不会进行人脸检测，也不会返回任何其他的人脸信息。参数规格：四个正整数，用逗号分隔，依次代表人脸框左上角纵坐标（top），左上角横坐标（left），人脸框宽度（width），人脸框高度（height）。例如：70,80,100,100
 */
+ (void)faceRecognitionWithImage:(UIImage *)image
                        landmark:(VicLandmark)landmark
                      attributes:(NSString *)attributes
                   calculate_all:(BOOL)calculate_all
                  face_rectangle:(CGRect)face_rectangle
               successCompletion:(void(^)(id data))successCompletion
                 errorCompletion:(void(^)(NSError *error))errorcompletion;


+ (void)compareFaceWithFirstFaceImage:(UIImage *)firstFaceImage
                       firstFaceToken:(NSString *)firstFaceToken
                      secondFaceImage:(UIImage *)secondFaceImage
                      secondFaceToken:(NSString *)secondToken
                       firstRectangle:(CGRect)firstRectangle
                      secondRectangle:(CGRect)secondRectangle
                    successCompletion:(void(^)(id data))successCompletion
                      errorCompletion:(void(^)(NSError *error))errorcompletion;


+ (void)compareFaceWithFirstFaceURL:(NSString *)firstFaceURL
                       firstFaceToken:(NSString *)firstFaceToken
                       firstRectangle:(CGRect)firstRectangle
                    successCompletion:(void(^)(id data))successCompletion
                    errorCompletion:(void(^)(NSError *error))errorcompletion;

@end

NS_ASSUME_NONNULL_END
