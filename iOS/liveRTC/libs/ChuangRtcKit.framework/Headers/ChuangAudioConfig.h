//
//  ChuangAudioConfig.h
//  ChuangRtcKit
//
//  Created by wzh on 2021/5/13.
//  Copyright © 2021 chuangcache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangEnumerates.h>


NS_ASSUME_NONNULL_BEGIN


@interface ChuangCustomAudioCaptureConfig : NSObject
/*!
 @brief 自定义音频渲染的采样率 (kHz) 推荐值：48 kHz
 */
@property (nonatomic, assign) double sampleRate;
/*!
 @brief 自定义音频渲染的声道数
 */
@property (nonatomic, assign) NSUInteger channels;
@end


@interface ChuangCustomAudioRenderConfig : NSObject
/*!
 @brief 自定义音频渲染的采样率 (kHz) 推荐值：48 kHz
 */
@property (nonatomic, assign) double sampleRate;
/*!
 @brief 自定义音频渲染的声道数
 */
@property (nonatomic, assign) NSUInteger channels;
@end


@interface ChuangAudioConfig : NSObject
/*!
 @brief 音频配置ID
 */
@property (nonatomic, assign) ChuangAudioProfileId profileId;

@end

NS_ASSUME_NONNULL_END
