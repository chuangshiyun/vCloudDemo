//
//  ChuangExpressObjects.h
//  ChuangRtcKit
//
//  Created by wzh on 2021/5/13.
//  Copyright © 2021 chuangcache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangEnumerates.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @class ChuangSoundLevel
 @brief SDK 推拉流音量回调信息
 */
@interface ChuangSoundLevel : NSObject
/*!
 @brief 音量值 0-100 数值越大，音量越大
 */
@property (nonatomic, assign) int soundLevel;
/*!
 @brief 流名
 */
@property (nonatomic, copy) NSString *streamId;
/*!
 @brief 是否启用vad  启用:YES  不启用:NO
 */
@property (nonatomic, assign) BOOL vad;

@end

@interface ChuangVideoCanvas : NSObject
/*!
 @brief 视图对象，  展示本端视频预览的界面 (主要是推流显示视图)
 */
@property (nonatomic, strong) UIView *view;
/*!
 @brief 视频显示模式（是否拉伸等），详情见ChuangVideoRenderMode
 */
@property (nonatomic, assign) ChuangVideoRenderMode renderMode;
/*!
 @brief 视图镜像模式，详见ChuangVideoMirrorMode
 
 本地预览视图镜像模式：如果你使用前置摄像头，默认启动本地视图镜像模式；如果你使用后置摄像头，默认关闭本地视图镜像模式。
 远端播流用户视图镜像模式：默认关闭远端用户的镜像模式。
 */
@property (nonatomic, assign) ChuangVideoMirrorMode mirrorMode;


@end

@interface ChuangTrafficControlInfo : NSObject

/*!
 @brief 需要调整的视频帧率 ( fps)
 */
@property (nonatomic, assign) NSUInteger videoFPS;
/*!
 @brief 视频的码率，单位是 kbps
 */
@property (nonatomic, assign) NSUInteger videoBitrate;

/*!
 @brief 需要调整的视频分辨率
 */
@property (nonatomic, assign) CGSize videoResolution;


@end

/*!
 @brief 混音数据
 */
@interface ChuangAudioMxingData : NSObject
/*!
 @brief 音频采样率
 */
@property (nonatomic, assign) int sampleRate;
/*!
 @brief 声道数
 */
@property (nonatomic, assign) int channel;
/*!
 @brief pcm数据
 */
@property (nonatomic, assign) void* pData;
/*!
 @brief pcm数据长度，单位字节
 */
@property (nonatomic, assign) int exceptedDataBytes;

@end

NS_ASSUME_NONNULL_END
