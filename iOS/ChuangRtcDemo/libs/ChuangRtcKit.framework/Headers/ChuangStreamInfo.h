//
//  ChuangStreamInfo.h
//  ChuangRtcKit
//
//  Created by wzh on 2021/5/13.
//  Copyright © 2021 chuangcache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangEnumerates.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChuangStreamInfo : NSObject
/*!
 @brief 用户ID
 */
@property (nonatomic, copy) NSString *userId;
/*!
 @brief 流ID
 */
@property (nonatomic, copy) NSString *streamId;
/*!
 @brief 流模式
 */
@property (nonatomic, assign) ChuangStreamMode streamMode;
/*!
 @brief 流类型
 */
@property (nonatomic, assign) ChuangStreamType streamType;
/*!
 @brief 流宽度
 */
@property (nonatomic, assign) CGFloat width;
/*!
 @brief 流高度
 */
@property (nonatomic, assign) CGFloat height;
/*!
 @brief 流离开原因
 */
@property (nonatomic, assign) ChuangStreamRemoveReason removeReason;

@end

/*!
 @brief 推流质量
 */
@interface ChuangPublishStreamQuality : NSObject
/*!
 @brief 流ID
 */
@property (nonatomic, copy) NSString *streamId;

/*!
 @brief 视频采集帧率（动态）
 */
@property (nonatomic, assign) int videoCaptureFps;

/*!
 @brief 视频编码帧率
 */
@property (nonatomic, assign) int videoFps;
/*!
 @brief 音频编码帧率
 */
@property (nonatomic, assign) int audioFps;
/*!
 @brief 视频码率
 */
@property (nonatomic, assign) int videoBitrateKbps;
/*!
 @brief 音频码率
 */
@property (nonatomic, assign) int audioBitrateKbps;
/*!
 @brief 丢包率(0-1)
 */
@property (nonatomic, assign) double packetLostRate;
/*!
 @brief 延时
 */
@property (nonatomic, assign) int rtt;
/*!
 @brief  上传速度 单位 KB/s
 */
@property (nonatomic, assign) double uploadSpeed;
/*!
 @brief  下载速度 单位 KB/s
 */
@property (nonatomic, assign) double downloadSpeed;

@property (nonatomic, assign) long uploadBytes;
@property (nonatomic, assign) long downloadBytes;

@end

/*!
 @brief 播流质量
 */
@interface ChuangPlayStreamQuality : ChuangPublishStreamQuality
/*!
 @brief 远端推流rtt 延时
 */
@property (nonatomic, assign) int publisherRtt;
/*!
 @brief 远端推流丢包率 (0-1)
 */
@property (nonatomic, assign) double publisherLPacketLostRate;

@end

NS_ASSUME_NONNULL_END
