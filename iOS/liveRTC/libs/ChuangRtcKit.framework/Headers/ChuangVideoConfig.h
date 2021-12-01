//
//  ChuangVideoConfig.h
//  ChuangRtcKit
//
//  Created by wzh on 2021/5/13.
//  Copyright © 2021 chuangcache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangEnumerates.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChuangVideoRawDataFrameParam : NSObject

/*!
 @brief 自定义的视频像素格式（目前支持I420、BGRA、NV12）
 */
@property (nonatomic, assign) ChuangVideoPixelFormat pixelFormat;

/*!
 @brief 视频帧的画面尺寸
*/
@property (nonatomic, assign) CGSize size;

/*!
 @brief 视频帧的旋转方向，如果需要对视频做旋转操作，则传入设备方向
 */
@property (nonatomic, assign) ChuangStreamRotation rotation;


@end

@interface ChuangEncodedFrameParam : NSObject

/*!
 @brief 视频帧的格式,详情参照 ChuangVideoEncodedFrameFormat
 */
@property (nonatomic, assign) ChuangVideoEncodedFrameFormat format;
/*!
 @brief 是否为关键帧
 */
@property (nonatomic, assign) BOOL isKeyFrame;

/*!
 @brief 视频帧的旋转方向，详情参照ChuangStreamRotation
 */
@property (nonatomic, assign) ChuangStreamRotation rotation;

/*!
 @brief 视频帧的画面尺寸
*/
@property (nonatomic, assign) CGSize size;
@end

@interface ChuangCustomVideoCaptureConfig : NSObject
/*!
 @brief 视频帧数据类型
 */
@property (nonatomic, assign) ChuangVideoBufferType bufferType;
@end

@interface ChuangCustomVideoRenderConfig : NSObject
/*!
 @brief 接收自定义渲染视频数据类型，1:    ChuangPixelBuffer  2:rawData  3:编码后/解码前 H.264数据，,推荐ChuangPixelBuffer。详情参照ChuangVideoBufferType
 */
@property (nonatomic, assign) ChuangVideoBufferType bufferType;
/*!
 @brief 接收自定义渲染视频像素格式（目前支持I420、BGRA、NV12），详情参照ChuangVideoPixelFormat 。 如果bufferType传3时可不需要设置pixelFormat。其他必须设置pixelFormat。
 */
@property (nonatomic, assign) ChuangVideoPixelFormat pixelFormat;
/*!
 @brief 是否在自定义视频渲染的同时启用内部引擎也渲染（默认NO），注意：当bufferType设置为ChuangVideoBufferTypeEncodedData时候，该设置无效
 */
@property (nonatomic, assign) BOOL enableEngineRender;

@end

@interface ChuangVideoFrameParam : NSObject
/*!
 @brief 接收自定义渲染视频像素格式（目前支持I420、BGRA、NV12）。详情参照ChuangVideoPixelFormat
 */
@property (nonatomic, assign) ChuangVideoPixelFormat pixelFormat;
 
/*!
 @brief 视频尺寸
 */
@property (nonatomic, assign) CGSize videoSize;

/*!
 @brief 视频帧的旋转方向，详情参照ChuangStreamRotation
 */
@property (nonatomic, assign) ChuangStreamRotation rotation;
@end


@interface ChuangVideoConfig : NSObject
/*!
 @brief 视频拍摄采集分辨率，使用默认相机采集且相机启动前设置有效，预览展示可使用该分辨率，默认不设置的话会执行内部默认采集分辨率。
 */
@property (nonatomic, assign) CGSize captureSize;
/*!
 @brief 推流的视频编码分辨率，推荐值：540x960。推流前设置有效
 */
@property (nonatomic, assign) CGSize encodeSize;
/*!
 @brief  推流的视屏帧率，推荐值：15  推流前设置
 */
@property (nonatomic, assign) NSUInteger fps;
/*!
 @brief  推流的视频比特率（单位：kbps），推荐值：600 kbps。推流前设置
 */
@property (nonatomic, assign) NSUInteger bitrateKbps;
/*!
 @brief 视频显示模式（是否拉伸等），详情见ChuangVideoRenderMode
 */
@property (nonatomic, assign) ChuangVideoRenderMode renderMode;

/*!
 @brief  常用推流属性设置预设项 （定义几种常见分辨率下的码率、帧率配置组合，方便快速切换）.推荐常用推流属性设置预设项，videoConfigPreset详情参照ChuangVideoConfigPreset，如果给videoConfigPreset设了默认设置预设，分辨率、帧率、码率不需要再单独设置了；如果预设列表中几种都不能满足实际的视频属性，可以自定义分别设置分辨率、帧率、码率的值，则该预设属性不用再调用
 */
+ (instancetype)configWithPreset:(ChuangVideoConfigPreset)videoConfigPreset;
@end
NS_ASSUME_NONNULL_END
