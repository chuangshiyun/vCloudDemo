//
//  CYLiveRoomStatusConfig.h
//  ChuangRtcDemo
//


#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangRtcKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYLiveRoomStatusConfig : NSObject

///是否开启视频统计
@property (nonatomic, assign) BOOL isShowVideoLog;
///是否打开镜像
@property (nonatomic, assign) BOOL isOpenMirror;
///是否开启测速
@property (nonatomic, assign) BOOL isOpenSpeedTest;
///是否开启音量监听
@property (nonatomic, assign) BOOL isOpenSoundLevel;
///是否开启日志
@property (nonatomic, assign) BOOL isOpenLog;
///混音
@property (nonatomic, assign) BOOL isOpenMixAudio;
///是否混流
@property (nonatomic, assign) BOOL isMixStream;

@property (nonatomic, assign) NSInteger renderMode;
///摄像头前置后置
@property (nonatomic, assign) NSInteger cameraType;
///本地摄像头是否开启
@property (nonatomic, assign) BOOL isOpenLocalCamera;
///本地麦克风是否开启
@property (nonatomic, assign) BOOL isOpenLocalAudio;

///推流状态
@property (nonatomic, assign) ChuangPublishState publishState;

@end

NS_ASSUME_NONNULL_END
