//
//  ChuangLiveEngine.h
//  ChuangRtcKit
//
//  Created by wzh on 2021/5/13.
//  Copyright © 2021 chuangcache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangStreamConfig.h>
#import <ChuangRtcKit/ChuangStreamInfo.h>
#import <ChuangRtcKit/ChuangEnumerates.h>
#import <ChuangRtcKit/ChuangVideoConfig.h>
#import <ChuangRtcKit/ChuangAudioConfig.h>
#import <ChuangRtcKit/ChuangMixStreamConfig.h>
#import <ChuangRtcKit/ChuangExpressObjects.h>
#import <ChuangRtcKit/ChuangNetworkSpeedTestConfig.h>

NS_ASSUME_NONNULL_BEGIN


@protocol ChuangAudioMixingDelegate <NSObject>
/*!
 @brief 混音数据回调
 @param audioMixData 数据，详见ChuangAudioMxingData
 */
- (void)onAudioMixingCopyData:(ChuangAudioMxingData *)audioMixData;

@end

#pragma mark - 自定义采集视频代理方法
@protocol ChuangVideoCustomCaptureDelegate <NSObject>

@optional

/*!
 @brief SDK 通知将要开始采集视频帧，收到该回调后向 SDK 发送的视频帧数据才有效
 @param channelIndex  预留参数，目前默认0；
*/
- (void)onStart:(int)channelIndex;

/*!
 @brief SDK 通知将要停止采集视频帧
 @param channelIndex  预留参数，目前默认0；
*/
- (void)onStop:(int)channelIndex;

/*!
 @brief 自定义视频编码控制信息回调（选择自定义采集已编码数据的前提才会返回）
 
  SDK检测到网络变化，通知开发者需要做流量控制，由于选择自定义采集传输已编码数据的情况下，SDK内部是无法得知自定义的编码配置，因此流控制操作需要开发者自己完成，SDK会根据当前的网络情况，将视频配置的推荐值通知开发者，开发者需要自行对编码器配置进行修改，从而保证视频传输的流畅性。注意：请不要在此回调中做耗时操作，如果需要执行耗时操作，请切换线程进行
 
 @param trafficControlInfo  流控参数，详见ChuangTrafficControlInfo
 @param channelIndex  预留参数，目前默认0；
*/
- (void)onEncodedDataTrafficControlInfo:(ChuangTrafficControlInfo *)trafficControlInfo channelIndex:(int)channelIndex;

/*!
 @brief SDK 通知需要一个关键帧
 */
- (void)onRequestKeyFrame;
@end


#pragma mark - 视频自定义渲染代理方法
@protocol ChuangVideoCustomRenderDelegate <NSObject>

/*!
 @brief 本地预览视频帧 CVPixelBuffer 数据回调
 @param buffer 封装为CVPixelBuffer的视频帧数据(需要释放)
 @param streamId 推流的流Id
 */
- (void)onLocalVideoFrameCVPixelBuffer:(CVPixelBufferRef)buffer streamId:(NSString *)streamId;

/*!
 @brief 远端拉流视频帧 CVPixelBuffer 数据回调，通过 streamId 区分不同的流
 @param buffer 封装为 CVPixelBuffer 的视频帧数据(需要释放)
 @param param 视频帧参数，详见：ChuangVideoFrameParam
 @param streamId 拉流的流id
*/
- (void)onRemoteVideoFrameCVPixelBuffer:(CVPixelBufferRef)buffer param:(ChuangVideoFrameParam *)param streamId:(NSString *)streamId;

/*!
 @brief 远端拉流视频帧裸数据回调，通过 streamId区分不同的流
 @param rawData 视频帧的裸数据
 @param param 视频帧参数，详见ChuangVideoFrameParam
 @param streamId 拉流的流id
*/
- (void)onRemoteVideoFrameRawData:(NSData *)rawData param:(ChuangVideoFrameParam *)param streamId:(NSString *)streamId;

/*!
 @brief 远端拉流视频帧解码前的数据回调，通过 streamId 区分不同的流
 @param rawData 视频帧编码数据
 @param param 视频帧参数，详见ChuangEncodedFrameParam
 @param streamId 拉流的流Id
*/
- (void)onRemoteVideoFrameEncodedRawData:(NSData *)rawData param:(ChuangEncodedFrameParam *)param streamId:(NSString *)streamId;


@end

@protocol ChuangLiveEngineDelegate <NSObject>

#pragma mark - 房间回调
/*!
 @brief 房间连接状态
 @param roomId 房间ID
 @param state 房间状态，详见ChuangRoomState
 @param errorCode 异常码
 */
- (void)onRoomStateUpdate:(NSString *)roomId state:(ChuangRoomState)state errorCode:(int)errorCode;
/*!
 @brief 房间流更新回调（不包含自己流）
 @param roomId 房间ID
 @param updateType 当前流的状态类型，区分流离开和加入，详见ChuangStreamUpdateType
 @param streamList 发生更新的流信息列表
 */
- (void)onRoomStreamUpdate:(NSString *)roomId updateType:(ChuangStreamUpdateType)updateType streamList:(NSArray<ChuangStreamInfo *>*)streamList;

#pragma mark - RTC流回调
#pragma mark - 推流回调
/*!
 @brief 推流状态变化回调
 @param streamId 流ID
 @param state 推流状态，详见ChuangPublishState
 @param code 异常码
 */
- (void)onPublishStreamStateUpdate:(NSString *)streamId state:(ChuangPublishState)state errorCode:(int)code;

/*!
 @brief 推流视频大小变化回调
 @param streamId 流ID
 @param size 视频大小
 */
- (void)onPublishStreamVideoSizeChanged:(NSString *)streamId size:(CGSize)size;

/*!
 @brief 推流质量变化回调
 @param streamId 流ID
 @param quality 流质量，详见ChuangPublishStreamQuality
 */
- (void)onPublishStreamQualityUpdate:(NSString *)streamId quality:(ChuangPublishStreamQuality *)quality;
/*!
@brief 推流音量大小变化回调 当开始推流后按照设定频率进行回调，如果没有推流，则不回调
@param soundLevel 音量变化信息，详见ChuangSoundLevel
*/
- (void)onCaptureSoundLevelUpdate:(ChuangSoundLevel *)soundLevel;

#pragma mark - 播流回调
/*!
 @brief 播流状态变化回调
 @param streamId 流ID
 @param state 播流状态，详见ChuangPlayState
 @param code 异常码
 */
- (void)onPlayStreamStateUpdate:(NSString *)streamId state:(ChuangPlayState)state errorCode:(int)code;
/*!
 @brief 播流质量回调
 @param streamId 流ID
 @param quality 流质量，详见ChuangPlayStreamQuality
 */
- (void)onPlayStreamQualityUpdate:(NSString *)streamId quality:(ChuangPlayStreamQuality *)quality;
/*!
 @brief 播流音量大小回调
 @param soundLevels 音量变化信息，详见ChuangSoundLevel
 */
- (void)onRemoteSoundLevelUpdate:(NSArray <ChuangSoundLevel *>*)soundLevels;
/*!
 @brief 收到推流附加消息
 @param streamId 流ID
 @param msg 消息
 */
- (void)onReceiveStreamAttchedMessage:(NSString *)streamId msg:(NSString *)msg;

#pragma mark - 播流媒体事件回调
/*!
 @brief 播流媒体事件回调
 @param streamId 流ID
 @param event 事件，详见ChuangPlayStreamEvent
 */
- (void)onPlayStreamEvent:(NSString *)streamId event:(ChuangPlayStreamEvent)event;
/*!
 @brief 播流首帧视频回调
 @param streamId 流ID
 */
- (void)onPlayStreamFirstVideo:(NSString *)streamId;
/*!
 @brief 播流首帧音频回调
 @param streamId 流ID
 */
- (void)onPlayStreamFirstAudio:(NSString *)streamId;

/*!
 @brief 音视频流状态改变回调，例如远端推流静音音视频
 @param streamId 流ID
 @param state 状态，详见ChuangStreamState
 */
- (void)onPlayStreamStateChanged:(NSString *)streamId state:(ChuangStreamState)state;
/*!
 @brief 播流视频大小变化回调
 @param streamId 流ID
 @param size 视频大小
 */
- (void)onPlayStreamVideoSizeChanged:(NSString *)streamId size:(CGSize)size;

/*!
 @brief 播流视频方向发生变化
 @param streamId 流ID
 @param rotation 视频方向，详见ChuangStreamRotation
 */
- (void)onPlayStreamVideoRotationChanged:(NSString *)streamId rotation:(ChuangStreamRotation)rotation;

#pragma mark - 混流回调
/*!
 @brief 混流结果回调
 @param code 异常码
 */
- (void)onMixStreamResult:(int)code;

#pragma mark - 网络测速回调
/*!
 @brief 网络测速回调
 @param quality 网络质量，详见ChuangNetworkSpeedQuality
 @param type 网络类型，详见：ChuangNetworkType
 */
- (void)onNetworkSpeedTestQualityUpdate:(ChuangNetworkSpeedQuality *)quality type:(ChuangNetworkType)type;

#pragma mark - 网络状态变化回调

/*!
 @brief 网络状态变化回调
 @param type  当前网络类型，详见：ChuangNetworkType
 */
- (void)onNetworkTypeChanged:(ChuangNetworkType)type;
#pragma mark -
/*!
 @brief (可选)采集音量变化的回调，可以用来实现音量条效果

 @param level 相对值，表现 mic 输入音量的高低 -10~10之间
 */
- (void)onMicrophoneVolumeLevelChangedCallBack:(float)level;

/*!
 @brief 麦克风未授权成功回调
 */
- (void)onInitMicrophoneFaildCallBack;

@end


@interface ChuangLiveEngine : NSObject
/*!
 @brief 设置麦克风音量增益，0.0 ～ 3.0 之间，默认 1.0
 */
@property (nonatomic, assign) float micVolume;

#pragma mark - 引擎相关
/*!
@brief 初始化

@param appId  【必传】 当前 App申请被分配到的 AppID，从官网管理后台获取
@param appKey  【必传】当前APP注册后与app ID一起获取的APP验证标示，也是从官网管理后台获取
@param delegate 回调对象，代理方法详见：ChuangLiveEngineDelegate
@return 返回 ChuangLiveEngine 对象
*/
+ (nullable instancetype)initEngine:(NSString *)appId andAppKey:(NSString *)appKey delegate:(nullable id <ChuangLiveEngineDelegate>)delegate;

/*!
 @brief 设置事件通知回调方法接收对象，传 [null] 则清空已设置的回调
 @param delegate 回调对象，代理方法详见：ChuangLiveEngineDelegate
 */
- (void)setEventHandler:(id <ChuangLiveEngineDelegate>)delegate;

/*!
@brief 销毁SDK
 
 该方法主要用于释放 SDK 使用的所有对象资源。帮助 App 在无需使用SDK时释放资源。
 一旦 App 调用了 uninitEngine 接口销毁创建的ChuangLiveEngine实例，将无法调用 SDK 内的任何方法也不再会有任何回调产生。如需使用SDK，请调用初始化方法 initSDKWithAppId:andAppKey:delegate: 创建一个新的 ChuangLiveEngine 实例。
 
 注意：不得在 SDK 生成的回调中调用该方法，不然 SDK只能等候该回调返回才能重新获取相应的对象资源造成死锁。
*/
+ (void)uninitEngine;

/*!
 @brief 获取引擎对象
 @return 返回 ChuangLiveEngine 对象
 */
+ (ChuangLiveEngine *)sharedEngine;

/*!
 @brief 获取sdk版本号
 */
+ (NSString *)getSDKVersion;

/*!
 @brief 设置日志级别。
 @param level 日志级别。详见：ChuangLogLevel
 */
+ (void)setLogLevel:(ChuangLogLevel)level;
/*!
 @brief 设置日志文件大小。
 @param fileSize 单位KB, 取值范围为 [0, 10240], 当设置值为0时，sdk会关闭日志记录功能，默认为1024KB。
 */
+ (void)setLogFileSize:(NSInteger)fileSize;
/*!
 @brief 设置日志文件路径
 @param filePath 日志文件保存的绝对路径, 请确保sdk对该路径具有写权限。
 */
+ (void)setLogFilePath:(NSString *)filePath;

#pragma mark - 房间相关
/*!
@brief 登录房间，初始化后需要先登录房间，登录成功后才可以推流或播流、混流

@param roomId  要登录的房间号
@param userId 当前用户的 UID
@param userRole 用户的角色，详情见：ChuangUserRole   
@return 返回 0 表示成功发送登录请求，其他值均为发送失败
@return 调用结果  0：成功，非0：失败
*/
- (int)loginRoom:(NSString *)roomId userId:(NSString *)userId role:(ChuangUserRole)userRole;

/*!
 @brief 获取当前房间连接状态
 @return 返回 房间连接状态 ChuangRoomState
 */
- (ChuangRoomState)getRoomConnectState;
/*!
 @brief 退出房间
 */
- (void)logoutRoom;
#pragma mark - 本地预览相关
/*!
@brief 设置本地视频预览视图
 
 该方法设置本地用户视频显示信息，只影响本地用户看到的视频画面，不影响本地发布视频。调用该方法绑定本地视频流的显示视窗(view)，并设置本地用户视图的渲染模式和镜像模式。在 App开发中 开发中，通常在调用该方法进行本地视频设置，然后再登录房间。登出房间后，绑定仍然有效，如果需要解除绑定，可以指定空 (nil) view 调用本方法。
 该方法在登录房间前后都能调用。
 
@param videoCanvas   本地视图对象，详情参照ChuangVideoCanvas
@return 调用结果 0：成功，非0：失败
 */
- (int)setPreview:(ChuangVideoCanvas *)videoCanvas;
/*!
 @brief 开始预览本地视图，需要在setPreview后调用有效。
 @return 调用结果 0：成功，非0：失败
 */
- (int)startPreview;

/*!
@brief 停止预览本地视图
*/
- (void)stopPreview;

/*!
@brief 前/后置摄像头切换
@param  cameraType  摄像头类型，详情参照：ChuangCameraType   0:前置摄像像头  1：后置摄像头，默认前置摄像头
*/
- (BOOL)switchCamera:(ChuangCameraType)cameraType;

/*!
 @brief 设置视频推流配置
 @param videoConfig 视频推流配置，详见ChuangVideoConfig
 @return 返回 0 表示成功调用接口成功
 @return 调用结果 0：成功，非0：失败
 */
- (int)setVideoConfig:(ChuangVideoConfig *)videoConfig;

/*!
 @brief 获取视频推流配置，详见ChuangVideoConfig
 */
- (ChuangVideoConfig *)getVideoConfig;

/*!
 @brief 设置音频配置
 @param audioConfig 音频配置，详见ChuangAudioConfig
 @return 返回 0 表示成功调用接口成功
 @return 调用结果  0：成功，非0：失败
 */
- (int)setAudioConfig:(ChuangAudioConfig *)audioConfig;

#pragma mark - 推流相关
/*!
 @brief 开始推流
 @param streamConfig 推流配置参数对象，详情查看ChuangStreamConfig
 @return 返回 0 表示推流请求成功，其他值均为失败
 @return 调用结果 0：成功，非0：失败
 */
- (int)startPublishStream:(ChuangStreamConfig *)streamConfig;

/*!
 @brief 停止推流
 */
- (void)stopPublishStream;

/*!
 @brief 发送推流附加消息。推流成功后可调用此函数，所有通过SDK播放此流者会收到此消息。此消息为不可靠消息，每秒最大发送带宽 8192字节。
 @param message 消息内容
 @return 调用结果 0：成功，非0：失败
 */
- (int)sendStreamAttachedMessage:(NSString *)message;

#pragma mark - 自定义采集
#pragma mark - 自定义采集音频
/*!
 @brief 是否启用自定义采集音频
 @param enable YES：启用自定义采集 NO：不启用自定义采集。(默认：NO 不启用自定义采集)
 @param config 自定义采集音频配置，详见ChuangCustomAudioCaptureConfig
 @return 调用结果  0：成功，非0：失败
 */
- (int)enableCustomAudioCapture:(BOOL)enable config:(ChuangCustomAudioCaptureConfig *)config;
/*!
 @brief 自定义采集的音频pcm数据
 @param data pcm数据
 @return 调用结果
 */
- (int)sendCustomAudioCapturePCMData:(NSData *)data;

#pragma mark - 自定义采集视频相关
/*!
 @brief 是否启用自定义采集视频
 @param enable YES：启用自定义采集 NO：不启用自定义采集。(默认：NO 不启用自定义采集)
 @param config 自定义采集视频配置，详见ChuangCustomVideoCaptureConfig
 @return 调用结果
 */
- (int)enableCustomVideoCapture:(BOOL)enable config:(ChuangCustomVideoCaptureConfig *)config;

/*!
 @brief 设置自定义采集视频回调
 @param delegate 自定义采集视频回调代理，代理方法见ChuangVideoCustomCaptureDelegate
 @return 调用结果
 */
- (int)setCustomVideoCaptureHandler:(id<ChuangVideoCustomCaptureDelegate>)delegate;

/*!
 @brief 传入自定义视频帧  (CVPixelBufferRef类型)

 @param pixelBuffer 视频帧
 @param rotation 屏幕方向。详见ChuangStreamRotation
 @param timeStamp 时间戳
 @return 调用结果
 */
- (int)sendCustomVideoCapturePixelBuffer:(CVPixelBufferRef)pixelBuffer videoRoration:(ChuangStreamRotation)rotation timeStamp:(uint64_t)timeStamp;

/*!
 @brief 传入自定义视频帧  (rawData裸数据)

 @param rawData raw data ，要向 SDK 发送的视频帧数据
 @param videFrame 视频帧参数，详见ChuangVideoRawDataFrameParam
 @param timeStamp 时间戳
 @return 调用结果
 */
- (int)sendCustomVideoCaptureRawData:(NSData *)rawData param:(ChuangVideoRawDataFrameParam*)videFrame  timeStamp:(uint64_t)timeStamp;

/*!
 @brief 发送自定义采集的视频帧编码后的数据(默认支持H.264编码)
 @param data 发送的编码后的视频帧数据
 @param param 视频帧的参数，详见ChuangEncodedFrameParam
 @param timestamp 视频帧的索引时间
 @return 调用结果
 */
- (int)sendCustomVideoCaptureEncodedData:(NSData *)data param:(ChuangEncodedFrameParam *)param timestamp:(uint64_t)timestamp;

#pragma mark - 获取推流视频截图
/*!
@brief 获取推流视频截图
@param imageCallback 截图回调  详情见ChuangTakeSnapshotCallback
@return 调用结果 0：成功，非0：失败
*/
- (int)takePublishStreamSnapshot:(ChuangTakeSnapshotCallback)imageCallback;

#pragma mark - 获取播流视频截图
/*!
@brief 获取播流视频截图
@param streamId 流ID
@param imageCallback 截图回调  详情见ChuangTakeSnapshotCallback
@return 调用结果 0：成功，非0：失败
*/
- (int)takePlayStreamSnapshot:(NSString *)streamId imgCallBack:(ChuangTakeSnapshotCallback)imageCallback;

/*!
@brief 获取跨房间播流视频截图
@param roomId   房间ID
@param streamId 流ID
@param imageCallback 截图回调  详情见ChuangTakeSnapshotCallback
@return 调用结果 0：成功，非0：失败
*/
- (int)takePlayStreamSnapshotWithRoomId:(NSString *)roomId streamId:(NSString *)streamId imgCallBack:(ChuangTakeSnapshotCallback)imageCallback;

#pragma mark - 3A开关
/*!
 @brief 开/关回声消除
 @param enable   是否开启回声消除，YES：开启回声消除   NO:关闭回声消除，默认YES
 
 开启回声消除， 会对SDK采集到的音频数据进行过滤以降低音频中的回音成分，使声音更干净
 */
- (void)enableAEC:(BOOL)enable;
/*!
 @brief 开/关自动增益
 @param enable  是否开启自动增益  YES：开启自动增益   NO:关闭自动增益    默认YES
 
 开启自动增益后声音会被放大，但会一定程度上影响音质
 */
- (void)enableAGC:(BOOL)enable;

/*!
 @brief 开/关噪声抑制
 @param enable  是否开启噪声抑制  YES：开启噪声抑制   NO:关闭噪声抑制    默认YES
 
 开启噪声抑制可以使人声更加清晰
 */
- (void)enableANS:(BOOL)enable;

#pragma mark - 混音

/*!
 @brief 是否启用混音
 @param enable  是否开启混音，YES：开启混音，NO：不开启混音，默认NO.
 @return 调用结果 0：成功，非0：失败
 */
- (int)enableAudioMixing:(BOOL)enable;

/*!
 @brief 设置混音回调
 @param delegate 自定义混音回调代理，详细代理方法见ChuangAudioMixingDelegate
 @return 调用结果  0：成功，非0：失败
 */
- (int)setAudioMixingHandler:(nullable id<ChuangAudioMixingDelegate>)delegate;

#pragma mark - 播流相关
/*!
 @brief 开始播放指定流(所在房间内的流)
 @param streamId 流ID
 @param videoCanvas  视频显示信息，修改videoCanvas属性值后再次调用该方法可以实现修改播流填充模式、镜像模式等， 详见ChuangVideoCanvas
 @return 调用结果 0：成功，非0：失败
 */
- (int)startPlayStream:(NSString *)streamId withCanvas:(ChuangVideoCanvas *)videoCanvas;

/*!
 @brief 停止播放指定用户
 @param streamId  需要停止播放的流ID
 */
- (void)stopPlayStream:(NSString *)streamId;

#pragma mark - 跨房间播流

/*!
 @brief 开始跨房间播流
 @param roomId 要播的流所在的房间ID
 @param streamId 流ID
 @param videoCanvas  视频显示信息， 详见ChuangVideoCanvas
 @return 调用结果 0：成功，非0：失败
 */
- (int)startPlayStreamWithRoomId:(NSString *)roomId streamId:(NSString *)streamId withCanvas:(ChuangVideoCanvas*)videoCanvas;

/*!
@brief 停止跨房间播流
@param roomId  房间名
@param streamId  流ID
*/
- (void)stopPlayStreamWithRoomId:(NSString *)roomId andStreamId:(NSString *)streamId;


#pragma mark - 自定义渲染
#pragma mark - 自定义渲染音频
/*!
 @brief 是否启用自定义渲染音频
 @param enable YES：启用自定义渲染 NO：不启用自定义渲染。(默认：NO 不启用自定义渲染)
 @param config 自定义渲染音频配置，详见ChuangCustomAudioRenderConfig
 @return 调用结果 0：成功，非0：失败
 */
- (int)enableCustomAudioRender:(BOOL)enable config:(ChuangCustomAudioRenderConfig *)config;

/*!
 @brief 获取自定义渲染音频播放数据
 @param data 数据
 @param dataLength 数据长度 （单位字节）
 @param streamId 播流ID
 @return 调用结果  0：成功，非0：失败
 */
- (int)fetchCustomAudioRenderPCMData:(int16_t *)data dataLength:(uint32_t)dataLength streamId:(NSString *)streamId;

#pragma mark - 自定义渲染视频
/*!
 @brief 是否启用远端视频自定义渲染
 @param enable YES：启用自定义渲染 NO：不启用自定义渲染。(默认：NO 不启用自定义渲染)
 @param config 自定义渲染视频配置 , 详见ChuangCustomVideoRenderConfig
 @return 调用结果  0：成功，非0：失败
 */
- (int)enableCustomRemoteVideoRender:(BOOL)enable config:(ChuangCustomVideoRenderConfig *)config;
/*!
 @brief 是否启用本地视频自定义渲染
 @param enable YES：启用自定义渲染 NO：不启用自定义渲染。(默认：NO 不启用自定义渲染)
 @param config 自定义渲染视频配置 , 详见ChuangCustomVideoRenderConfig
 @return 调用结果  0：成功，非0：失败
 */
- (int)enableCustomLocalVideoRender:(BOOL)enable config:(ChuangCustomVideoRenderConfig *)config;
/*!
 @brief 设置自定义渲染视频回调
 @param delegate 自定义渲染视频回调代理，代理方法详见ChuangVideoCustomRenderDelegate
 */
- (void)setCustomVideoRenderHandler:(id<ChuangVideoCustomRenderDelegate>)delegate;

#pragma mark - 设置流音量大小回调
/*!
 @brief 开启音量监听
 */
- (void)startSoundLevelMonitor;
/*!
 @brief 停止音量监听
 */
- (void)stopSoundLevelMonitor;
/*!
 @brief 设置音量回调间隔
 @param intervalMs 间隔，单位毫秒，10-5000, 默认200
 @return 调用结果  0：成功，非0：失败
 */
- (int)setSoundLevelMonitorInterval:(int)intervalMs;

#pragma mark - 静音
#pragma mark - 静音音频
/*!
 @brief 静音本地指定流的音频

 @param streamId 流ID
 @param mute 是否静音 YES:静音 NO:取消静音
 @return 调用结果  0：成功，非0：失败
 */
- (int)muteLocalAudio:(NSString *)streamId mute:(BOOL)mute;

/*!
 @brief 静音远端指定流的音频

 @param streamId 流ID
 @param mute 是否静音 YES:静音 NO:取消静音
 @return 调用结果  0：成功，非0：失败
 */
- (int)muteRemoteAudio:(NSString *)streamId mute:(BOOL)mute;

#pragma mark - 静音视频
/*!
 @brief 关闭展示本地指定流的视频

 @param streamId 流ID
 @param mute 是否关闭展示 YES:关闭  NO:取消关闭
 @return 调用结果  0：成功，非0：失败
 */
- (int)muteLocalVideo:(NSString *)streamId mute:(BOOL)mute;

/*!
 @brief 关闭展示远端指定流的视频
 @param streamId 流ID
 @param mute 是否关闭展示 YES:关闭  NO:取消关闭
 @return 调用结果  0：成功，非0：失败
 */
- (int)muteRemoteVideo:(NSString *)streamId mute:(BOOL)mute;

#pragma mark - 混流

/*!
@brief 开始混流
@param mixConfig  混流配置 ，详情查看ChuangMixStreamConfig
@return 返回 0 代表混流请求发送成功
*/
- (int)startMixStream:(ChuangMixStreamConfig *)mixConfig;

/*!
 @brief 停止混流
 */
- (void)stopMixStream;

#pragma mark - 网络测速
/*!
 @brief 开始网络测速
 @param config 测速配置，详见ChuangNetworkSpeedTestConfig
 @return 调用结果  0：成功，非0：失败
 */
- (int)startNetworkSpeedTest:(ChuangNetworkSpeedTestConfig *)config;
/*!
 @brief 停止网络测速
 */
- (void)stopNetworkSpeedTest;


/*!
@brief 设置摄像头采集方向，默认是竖屏采集，不调用会默认竖屏
@param orientation   详情参照ChuangAppOrientation，内部默认竖屏采集，当需要指定横屏采集的时候，如果需要横屏采集需要在开始预览和推流前设置
*/
- (void)setAppOrientation:(ChuangAppOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
