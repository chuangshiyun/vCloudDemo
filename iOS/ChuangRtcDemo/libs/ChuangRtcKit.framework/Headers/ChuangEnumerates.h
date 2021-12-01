//
//  ChuangEnumerates.h
//  ChuangRtcKit
//
//  Created by wzh on 2021/5/13.
//  Copyright © 2021 chuangcache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 @brief 推流截图回调block
 */
typedef void(^ChuangTakeSnapshotCallback)(NSString * _Nullable streamId, int errorCode, UIImage * _Nullable image);

/*!
@brief 用户身份
*/
typedef NS_ENUM(int, ChuangUserRole) {
    /*!
     @brief  1:用户为主播，只需要推流
    */
    ChuangUserRoleAnchor = 1,
    /*!
     @brief  2:用户为观众，只需要拉流
    */
    ChuangUserRoleAudience = 2,
    /*!
     @brief  3:用户为互动，既需要推流也需要拉流
    */
    ChuangUserRoleInteraction = 3,
};

/*!
 @brief 房间状态
 */
typedef NS_ENUM(NSUInteger, ChuangRoomState) {
    
    /*!
     @brief 连接中
     */
    ChuangRoomStateConnecting   = 0,
    /*!
     @brief 连接成功
     */
    ChuangRoomStateConnected    = 1,
    /*!
     @brief 连接断开
     */
    ChuangRoomStateDisconnected = 2,
};

/*!
 @brief 推流状态
 */
typedef NS_ENUM(NSUInteger, ChuangPublishState) {
    /*!
     @brief 连接中
     */
    ChuangPublishStateConnecting = 0,
    /*!
     @brief 连接成功
     */
    ChuangPublishStateConnected,
    /*!
     @brief 连接断开
     */
    ChuangPublishStateDisconnected
};

/*!
 @brief 播流状态
 */
typedef NS_ENUM(NSUInteger, ChuangPlayState) {
    /*!
     @brief 连接中
     */
    ChuangPlayStateConnecting = 0,
    /*!
     @brief 连接成功
     */
    ChuangPlayStateConnected,
    /*!
     @brief 连接断开
     */
    ChuangPlayStateDisconnected
};


/*!
 @brief 流离开原因
 */
typedef NS_ENUM(NSUInteger, ChuangStreamRemoveReason) {
    /*!
     @brief 默认，正常离开
     */
    ChuangStreamRemoveReasonNormal,
    /*!
     @brief 网络异常
     */
    ChuangStreamRemoveReasonBadNetwork,
    /*!
     @brief 服务异常
     */
    ChuangStreamRemoveReasonBannedByServer,
};

/*!
 @brief 摄像头类型
 */
typedef NS_ENUM(NSInteger, ChuangCameraType) {
    /*!
     @brief  0:前置摄像头
    */
    ChuangCameraTypeFront = 0,
    /*!
     @brief  1：后置摄像头
    */
    ChuangCameraTypeBack = 1,
};



/*!
 @brief 推流视频属性配置预设列表
 */
typedef NS_ENUM(NSUInteger, ChuangVideoConfigPreset) {
    /*!
    @brief  推流分辨率 180x320，帧率15，码率300（kbps）
    */
    ChuangVideoConfigPreset180X320_15_300 = 0,
    /*!
     @brief  推流分辨率 270x480，帧率15，码率400（kbps）
    */
    ChuangVideoConfigPreset270X480_15_400,
    /*!
     @brief  推流分辨率 360x640，帧率15，码率600（kbps）
    */
    ChuangVideoConfigPreset360X640_15_600,
    /*!
     @brief  推流分辨率 540x960，帧率15，码率1200（kbps）
    */
    ChuangVideoConfigPreset540X960_15_1200,
    /*!
     @brief  推流分辨率 720x1280，帧率15，码率1500（kbps）
    */
    ChuangVideoConfigPreset720X1280_15_1500,
    /*!
     @brief  推流分辨率 1080x1920，帧率15，码率3000（kbps）
    */
    ChuangVideoConfigPreset1080X1920_15_3000,
};

/*!
 @brief 推流音频属性配置预设列表
 */
typedef NS_ENUM(NSUInteger, ChuangAudioConfigPreset) {
    /*!
    @brief  0: 默认设置。 通信场景下：32 KHz 采样率，语音编码，单声道，编码码率最大值为 18 Kbps。
      主播场景下：48 KHz 采样率，音乐编码，单声道，编码码率最大值为 64 Kbps。
    */
    ChuangAudioConfigPresetDefault = 0,
    /*!
     @brief  1: 指定 32 KHz采样率，语音编码，单声道，编码码率最大值为 18 Kbps
    */
    ChuangAudioConfigPresetSpeechStandard = 1,
    /*!
     @brief  2: 指定 48 KHz采样率，音乐编码，单声道，编码码率最大值为 64 Kbps
    */
    ChuangAudioConfigPresetMusicStandard = 2,
    /*!
     @brief 3: 指定 48 KHz采样率，音乐编码，双声道，编码码率最大值为 80 Kbps
    */
    ChuangAudioConfigPresetMusicStansardStereo = 3,
    /*!
     @brief 4: 指定 48 KHz 采样率，音乐编码，单声道，编码码率最大值为 96 Kbps
    */
    ChuangAudioConfigPresetMusicHighQuality = 4,
    /*!
     @brief  5: 指定 48 KHz采样率，音乐编码，双声道，编码码率最大值为 128 Kbps
    */
    ChuangAudioConfigPresetMusicHighAualityStereo = 5,
};


/*!
 @brief 混流输出分辨率列表
 */
typedef NS_ENUM(NSUInteger, ChuangMixOutputResolution) {
    /*!
      @brief  混流输出分辨率 800x600
     */
    ChuangMixOutputResolution800X600,
    /*!
        @brief  混流输出分辨率 432x768
    */
    ChuangMixOutputResolution432X768,
    /*!
       @brief  混流输出分辨率 768x432
    */
    ChuangMixOutputResolution768X432,
    /*!
       @brief  混流输出分辨率 1280x720
    */
    ChuangMixOutputResolution1280X720,
    /*!
    @brief  混流输出分辨率 720x1280
    */
    ChuangMixOutputResolution720X1280
};


/*!
 @brief 流模式
 */
typedef NS_ENUM(NSUInteger, ChuangStreamMode) {
    /*!
      @brief  0:  音视频流
   */
    ChuangStreamModeVideo = 0,
    /*!
      @brief 1: 纯音频流
    */
    ChuangStreamModeAudioOnly = 1,
    /*!
       @brief 1: 纯视频画面流，无声音，比如屏幕共享
    */
    ChuangStreamModeVideoOnly = 2,
};

/*!
 @brief 流类型
 */
typedef NS_ENUM(NSUInteger, ChuangStreamType) {
    /*!
     @brief rtc 流
     */
    ChuangStreamTypeRTC,
    /*!
     @brief 混流
     */
    ChuangStreamTypeMix,
};

/*!
 @brief 设备状态
 */
typedef NS_ENUM(NSUInteger, ChuangDeviceState) {
    /*!
        @brief  0:  设备关闭，比如麦克风静音/关闭摄像头画面
    */
    ChuangDeviceStateMute = 0,
    /*!
        @brief  0:  设备不关闭，比如麦克风采集音频/摄像头采集画面
    */
    ChuangDeviceStateUnMute = 1,
};


/*!
 @brief 音频编码器
 */
typedef NS_ENUM(NSUInteger, ChuangAudioEncoderMode) {
    /*!
        @brief  100:  AAC编码（默认
    */
    ChuangAudioEncoderModeAAC = 100,
    /*!
        @brief  200:  opus编码
    */
    ChuangAudioEncoderModeOpus = 200,
};


/*!
 @brief 视频显示模式
 */
typedef NS_ENUM(NSUInteger, ChuangVideoRenderMode) {
  /*!
      @brief  0: 视窗缩放被填满。视频尺寸等比缩放，直至整个视窗被视频填满。如果视频长宽与显示窗口不同，则视频流会按照显示视窗的比例进行周边图像拉伸后填满视窗,可能会出现部分被裁剪。
  */
    ChuangVideoRenderModePerfectFill = 0,
    /*!
        @brief  1: 视窗不变形被填满，视频尺寸等比缩放，直至视频窗口的一边与视窗边框对齐。如果视频尺寸与显示视窗尺寸不一致，在保持长宽比的前提下，将视频进行缩放后填满视窗，缩放后的视频四周可能会有一圈黑边。
    */
    ChuangVideoRenderModePerfectFit = 1,
    
    /*!
        @brief  2: 视窗变形被填满，视频尺寸缩放，直至视频窗口的两边与视窗边框对齐。如果视频尺寸与显示视窗尺寸不等比可能会出现拉伸情况
       */
    ChuangVideoRenderModeScaleFill = 2,
};


/*!
 @brief 视频镜像模式
 */
typedef NS_ENUM(NSUInteger, ChuangVideoMirrorMode) {
    /** 由 SDK 决定镜像模式，默认*/
    ChuangVideoMirrorModeAuto = 0,
    /** 1: 启用镜像模式 */
    ChuangVideoMirrorModeEnabled = 1,
    /** 2: 关闭镜像模式 */
    ChuangVideoMirrorModeDisabled = 2,
};


/*!
 @brief 视频采集方向，默认是竖屏，不设置默认竖屏采集
 */
typedef NS_ENUM(NSUInteger, ChuangAppOrientation) {
    /*!
       @brief 竖屏； Home键在下
    */
    ChuangAppOrientationPortrait = 0,
    
    /*!
       @brief 横屏； Home键在右
    */
    ChuangAppOrientationLandscape = 1,
    
};


/*!
 @brief 错误码
 */
typedef NS_ENUM(NSUInteger, ChuangErrorCode) {

    /*!
     @brief 操作成功
     */
    ChuangErrorCodeSuccess                          = 0,
    /*!
     @brief SDK未初始化
     */
    ChuangErrorCodeEngineNotInit                    = 10001,
    /*!
     @brief appId 传空
     */
    ChuangErrorCodeAppIdNull                        = 10002,
    /*!
     @brief appId 包含非法字符，
     appId 仅支持 0-9, a-z, A-Z
     */
    ChuangErrorCodeAppIdInvalid                     = 10003,
    /*!
     @brief appKey传空
     */
    ChuangErrorCodeAppKeyNull                       = 10004,
    /*!
     @brief appKey 包含非法字符，
     appKey仅支持 0-9, a-z, A-Z
     */
    ChuangErrorCodeAppKeyInvalid                    = 10005,
    /*!
     @brief sdk代理未设置
     */
    ChuangErrorCodeEngineDelegateNull               = 10006,
    /*!
     @brief 无效的参数
     */
    ChuangErrorCodeInvalidParameters                = 10008,
    /*!
     @brief 角色与操作不符
     */
    ChuangErrorCodeRolePermissionError              = 10009,
    /*!
     @brief 用户ID为空
     */
    ChuangErrorCodeUserIdNull                       = 11001,
    /*!
     @brief 用户ID过长，长度应小于256字节
     */
    ChuangErrorCodeUserIdTooLong                    = 11002,
    /*!
     @brief 用户ID非法，
     仅支持0-9, a-z, A-Z, -, _
     */
    ChuangErrorCodeUserIdInvalid                    = 11003,
    /*!
     @brief 房间ID为空
     */
    ChuangErrorCodeRoomIdNull                       = 11004,
    /*!
     @brief 房间ID过长，长度应小于256字节
     */
    ChuangErrorCodeRoomIdTooLong                    = 11005,
    /*!
     @brief 房间ID非法，
     仅支持0-9, a-z, A-Z, -, _
     */
    ChuangErrorCodeRoomIdInvalid                    = 11006,
    /*!
     @brief token 校验出错，
     可能是token过期或者token传错
     */
    ChuangErrorCodeTokenAuthError                   = 11007,
    /*!
     @brief token 校验失败，
     可能是网络异常导致校验超时
     */
    ChuangErrorCodeTokenAuthFailed                  = 11008,
    /*!
     @brief 登录失败,一般是AppId/AppKey错误导致
     */
    ChuangErrorCodeLoginFailedAppId                 = 11009,
    /*!
     @brief 由于被封禁导致登录失败
     */
    ChuangErrorCodeLoginFailedBanned                = 11010,
    /*!
     @brief 其他原因导致登录失败
     */
    ChuangErrorCodeLogInFailed                      = 11011,
    /*!
     @brief 网络原因导致与房间连接断开
     */
    ChuangErrorCodeRoomDisconnectedBadNetwork       = 11012,
    /*!
     @brief 参数错误导致房间连接失败,一般是服务端返回
     */
    ChuangErrorCodeLoginFailedParamError           = 11013,
    /*!
     @brief 房间重连成功
     */
    ChuangErrorRoomReconnected                     = 11014,
    /*!
     @brief 流ID 为空
     */
    ChuangErrorCodeStreamIdNull                     = 12001,
    /*!
     @brief 流ID过长，长度应小于256字节
     */
    ChuangErrorCodeStreamIdTooLong                  = 12002,
    /*!
     @brief 流ID包含非法字符，
     仅支持0-9, a-z, A-Z, -, _
     */
    ChuangErrorCodeStreamIdInvalid                  = 12003,
    /*!
     @brief 推流转推RTMP地址非法，目前仅支持rtmp协议
     */
    ChuangErrorCodeRTMPAddressInvalid               = 12004,
    /*!
     @brief 推流转推RTMP地址过长，长度应小于1024字节
     */
    ChuangErrorCodeRTMPAddressTooLong               = 12005,
    /*!
     @brief 推流附加消息内容为空
     */
    ChuangErrorCodePublishMessageNull               = 12006,
    /*!
     @brief 流ID或者推流已经存在
     */
    ChuangErrorCodeStreamIdExist                    = 12007,
    /*!
     @brief 未登录房间，调用推流、拉流前必须登录房间成功
     */
    ChuangErrorCodeNotLogin                         = 12008,
    /*!
     @brief 发送推流附加消息时还未推流成功
     */
    ChuangErrorCodePublishMessageBeforePublish      = 12009,
    /*!
     @brief 视频配置错误
     */
    ChuangErrorCodeVideoConfigError                 = 12010,
    /*!
     @brief 音频配置错误
     */
    ChuangErrorCodeAudioConfigError                 = 12011,
    /*!
     @brief 推流ID非法，可能已经被占用
     */
    ChuangErrorCodePublishStreamIdAuthFailed        = 12012,
    /*!
     @brief 网络原因导致推流或播流中断重连
     */
    ChuangErrorCodeStreamDisconnectedBadNetwork     = 12013,
    /*!
     @brief 转推RTMP连接服务器失败
     */
    ChuangErrorCodeRTMPTransformConnectFailed       = 12014,
    /*!
     @brief 没有麦克风权限
     */
    ChuangErrorCodeNoMicPermission                  = 12015,
    /*!
     @brief 没有摄像头权限
     */
    ChuangErrorCodeNoCameraPermission               = 12016,
    /*!
     @brief 推流音频采集数据失败
     */
    ChuangErrorCodeMicCaptureDataFailed             = 12017,
    /*!
     @brief 采集摄像头初始化失败
     */
    ChuangErrorCodeCameraInitFailed                 = 12019,
    /*!
     @brief 麦克风初始化失败
     */
    ChuangErrorCodeMicInitFailed                    = 12020,
    /*!
     @brief 预览canvas view 为空
     */
    ChuangErrorCodeCanvasNull                       = 12021,
    /*!
     @brief 设置视频自定义采集格式错误
     */
    ChuangErrorCodeCustomVideoConfigError           = 12022,
    /*!
     @brief 视频自定义采集接口调用错误
     */
    ChuangErrorCodeCustomVideoCaptureCalledError    = 12023,
    /*!
     @brief 推流重连成功
     */
    ChuangErrorCodePublishStreamReconnected         = 12025,
    /*!
     @brief 播流重连成功
     */
    ChuangErrorCodePlayStreamReconnected            = 12026,
    /*!
     @brief 未设置预览就开始预览
     */
    ChuangStartPreviewNotSetPreview                 = 12027,
    /*!
     @brief 截图出错，如设置回调为nil或者截图图像为空
     */
    ChuangSnapShotError                             = 12028,
    /*!
     @brief 推流失败，一般是网络异常引起的请求服务失败
     */
    ChuangPublishServerQuestFaild                   = 12029,
    
    /*!
     @brief 播流失败，播放的流ID不存在
     */
    ChuangPlayStreamNonExist                        = 12036,

    /*!
     @brief 混流地址非法，
     混流的rtmp地址为空或者传入了非rtmp://协议地址
     */
    ChuangErrorCodeMixStreamAddressInvalid          = 13001,
    /*!
     @brief 混流ID过长，长度应小于256字节
     */
    ChuangErrorCodeMixStreamIdTooLong               = 13002,
    /*!
     @brief 混流输入流数量过多，最多允许混9路流
     */
    ChuangErrorCodeMixStreamTooMuch                 = 13003,
    /*!
     @brief 未推流成功就发起混流
     */
    ChuangErrorCodeMixStreamBeforePublish           = 13004,
    /*!
     @brief 混流配置设置错误
     */
    ChuangErrorCodeMixStreamConfigError             = 13005,
    /*!
     @brief 混流分辨率不支持
     */
    ChuangErrorCodeMixStreamResolutionNoSuppored    = 13006,
    /*!
     @brief 混流参数错误
     */
    ChuangErrorCodeMixStreamParameterInvalid        = 13007,
    /*!
     @brief 混流ID为空
     */
    ChuangErrorCodeMixStreamIdNull                  = 13008,
    /*!
     @brief 混流ID包含非法字符
     仅支持0-9, a-z, A-Z, -, _
     */
    ChuangErrorCodeMixStreamIdInvalid               = 13009,
    /*!
     @brief 网络测速时还未登录房间
     */
    ChuangErrorCodeSpeedTestBeforeLogin             = 14001,
    /*!
     @brief 网络测速参数错误
     */
    ChuangErrorCodeSpeedTestParametersInvalid       = 14002,
    /*!
     @brief 网络测速连接服务器超时
     */
    ChuangErrorCodeSpeedTestConnectTimeout          = 14003,
    
    
};

/*!
 @brief 网络连接类型
 */
typedef NS_ENUM(NSInteger, ChuangNetworkType ) {
    /*!
      @brief  -1: 网络连接类型未知。
    */
    ChuangNetworkTypeUnknown = -1,
    /*!
     @brief  0: 网络连接已断开
    */
    ChuangNetworkTypeOffLine = 0,
    /*!
     @brief   1: 网络类型为 LAN。
    */
    ChuangNetworkTypeLan = 1,
    /*!
    @brief   2: 网络类型为 Wi-Fi（包含热点）
    */
    ChuangNetworkTypeWifi = 2,
    /*!
    @brief   3: 网络类型为 2G 移动网络
    */
    ChuangNetworkTypeMobile2G = 3,
    /*!
    @brief   4: 网络类型为 3G 移动网络。
    */
    ChuangNetworkTypeMobile3G = 4,
    /*!
    @brief  5: 网络类型为 4G 移动网络。
    */
    ChuangNetworkTypeMobile4G = 5,
    /*!
    @brief  6: 网络类型为 5G 移动网络。
    */
    ChuangNetworkTypeMobile5G = 6,
};


/*!
 @brief 日志级别
 */
typedef NS_ENUM(NSUInteger, ChuangLogLevel) {
    
    /// 输出所有 API 日志信息。如果想获取最完整的日志，可以将日志级别设为该等级
    ChuangLogLevelVerbose   = 0,
    
    /// 输出Debug，Info，Warn，Error日志
    ChuangLogLevelDebug     = 1,
    
    /// 输出Info，Warn，Error日志
    ChuangLogLevelInfo      = 2,
    
    /// 输出Warn，Error日志
    ChuangLogLevelWarn      = 3,
    
    /// 输出Error日志
    ChuangLogLevelError     = 4,
    
    /// 不输出日志
    ChuangLogLevelNone      = 0xff,
    
};


/*!
 @brief 视频帧数据类型
 */
typedef NS_ENUM(NSInteger, ChuangVideoBufferType) {
    
    /** 未知类型视频帧 */
    ChuangVideoBufferTypeUnknown            = 0,
   /** CVPixelBuffer 类型视频帧 */
    ChuangVideoBufferTypePixelBuffer        = 1,
    /** 裸数据类型视频帧 */
    ChuangVideoBufferTypeRawData            = 2,
    /** 未解码的视频帧数据 */
    ChuangVideoBufferTypeEncodedData        = 3,
};


/*!
 @brief 视频渲染视频帧数据像素格式
 */
typedef NS_ENUM(NSUInteger, ChuangVideoPixelFormat) {
    /** I420 */
    ChuangVideoPixelFormatI420 = 1,
    /** BGRA */
    ChuangVideoPixelFormatBGRA = 2,
    /** NV12 */
    ChuangVideoPixelFormatNV12 = 3,
};


/*!
 @brief 视频编码帧格式
 */
typedef NS_ENUM(NSUInteger, ChuangVideoEncodedFrameFormat) {

    /*!
     @brief AVC AVCC(H.264)
     */
    ChuangVideoEncodedFrameFormatAVCC = 0,
    /*!
     @brief AVC Annex-B （暂不支持）
     */
    ChuangVideoEncodedFrameFormatAnnexB = 1
};
/*!
 @brief 流状态更新类型
 */
typedef NS_ENUM(NSUInteger, ChuangStreamUpdateType) {
    /*!
     @brief 流添加
     */
    ChuangStreamUpdateTypeAdd       = 1,
    /*!
     @brief 流移除
     */
    ChuangStreamUpdateTypeDelete    = 2,
};

/*!
 @brief 音频配置ID
 */
typedef NS_ENUM(NSUInteger, ChuangAudioProfileId) {
    
    /*!
     @brief 0: 默认设置。 48 KHz 采样率，双单声道，16位，编码码率最大值为 64 Kbps。
     */
    ChuangAudioProfileIdDefault                 = 0,
    /*!
     @brief 1: 指定：32 KHz 采样率，双声道，16位，编码码率最大值为 16 Kbps。
     */
    ChuangAudioProfileIdCommunicateStandard     = 1,
    /*!
     @brief 2: 指定：32 KHz 采样率，双声道，16位，编码码率最大值为 32 Kbps。
     */
    ChuangAudioProfileIdCommunicateHighQuality  = 2,
    /*!
     @brief 3: 指定：48 KHz 采样率，双声道，16位，编码码率最大值为 64 Kbps。
     */
    ChuangAudioProfileIdMusicStandard           = 3,
    /*!
     @brief 4: 指定：48 KHz 采样率，双声道，16位，编码码率最大值为 128 Kbps。
     */
    ChuangAudioProfileIdMusicHighQuality        = 4,
};

/*!
 @brief 播流事件
 */
typedef NS_ENUM(NSUInteger, ChuangPlayStreamEvent) {
    /*!
     @brief 音频初始化
     */
    ChuangPlayStreamEventAudioInitialize,
    /*!
     @brief 视频初始化
     */
    ChuangPlayStreamEventVideoInitialize,
    /*!
     @brief 音频断开
     */
    ChuangPlayStreamEventAudioDisconnected,
    /*!
     @brief 视频断开
     */
    ChuangPlayStreamEventVideoDisconnected,
    /*!
     @brief 收到音频首帧
     */
    ChuangPlayStreamEventAudioReceiveFirstFrame,
    /*!
     @brief 收到视频首帧
     */
    ChuangPlayStreamEventVideoReceiveFirstFrame,
    /*!
     @brief 音频解码中
     */
    ChuangPlayStreamEventAudioDecodeing,
    /*!
     @brief 视频解码中
     */
    ChuangPlayStreamEventVideoDecodeing,
    /*!
     @brief 音频卡顿
     */
    ChuangPlayStreamEventAudioStuck,
    /*!
     @brief 视频卡顿
     */
    ChuangPlayStreamEventVideoStuck,
};

/*!
 @brief 流状态
 */
typedef NS_ENUM(NSInteger, ChuangStreamState) {
    /*!
     @brief 音频静音
     */
    ChuangStreamStateAudioMute,
    /*!
     @brief 音频未静音
     */
    ChuangStreamStateAudioUnmute,
    /*!
     @brief 视频静音
     */
    ChuangStreamStateVideoMute,
    /*!
     @brief 视频未静音
     */
    ChuangStreamStateVideoUnmute,
};

/*!
 @brief 视频流方向
 */
typedef NS_ENUM(NSUInteger, ChuangStreamRotation) {
    /*!
     @brief 0: 顺时针旋转 0°（Home键在下）
     */
    ChuangStreamRotation0       = 0,
    /*!
     @brief 1: 顺时针旋转 90°（Home键在左）
     */
    ChuangStreamRotation90      = 1,
    /*!
     @brief 2: 顺时针旋转 180°（Home键在上）
     */
    ChuangStreamRotation180     = 2,
    /*!
     @brief 3: 顺时针旋转 270°（Home键在右）
     */
    ChuangStreamRotation270     = 3,
};

/*!
 @brief 网络测速类型
 */
typedef NS_ENUM(NSUInteger, ChuangNetworkSpeedTestType) {
    /*!
     @brief 上行
     */
    ChuangNetworkSpeedTestTypeUpLink,
    /*!
     @brief 下行
     */
    ChuangNetworkSpeedTestTypeDownLink,
};

/*!
 @brief 网络测速状态
 */
typedef NS_ENUM(NSUInteger, ChuangNetworkSpeedTestState) {
    /*!
     @brief 测速已完成
     */
    ChuangNetworkSpeedTestStateComplete     = 1,
    /*!
     @brief 测速未完成
     */
    ChuangNetworkSpeedTestStateIncomplete   = 2,
    /*!
     @brief 测速失败
     */
    ChuangNetworkSpeedTestStateUnavailable  = 3,
};
