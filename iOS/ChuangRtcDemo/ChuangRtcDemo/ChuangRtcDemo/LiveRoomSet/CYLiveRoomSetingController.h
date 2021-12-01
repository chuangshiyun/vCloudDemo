//
//  CYLiveRoomSetingController.h
//  ChuangRtcDemo
//


#import "CYBaseViewController.h"
#import "CYLiveRoomStatusConfig.h"
#import <ChuangRtcKit/ChuangRtcKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CYLiveRoomSetingControllerDelegate <NSObject>

///是否开启视频统计
- (void)updateVideoDataState:(BOOL)isShowVideoData;

///是否开启镜像
- (void)updateVideoMirrorState:(BOOL)isOpenMirror;

///是否开启测速
- (void)updateSpeedTestState:(BOOL)isOpenSpeedTest;

///是否开启音量监测
- (void)updateSoundLevelState:(BOOL)isOpenSoundLevel;

///是否开启日志
- (void)updateLogState:(BOOL)isOpenLog;

///是否开启混音
- (void)updateMixAudioState:(BOOL)isOpenMixAudio;

///发送消息
- (void)sendStreamMessage:(NSString *)mesage;

///开始混流
- (void)updateMixStreamState:(BOOL)isMixStream;

///视频模式
- (void)renderWithModel:(ChuangVideoRenderMode)renderModel;


@end

@interface CYLiveRoomSetingController : CYBaseViewController

@property (nonatomic, weak) id <CYLiveRoomSetingControllerDelegate> delegate;
@property (nonatomic, strong) CYLiveRoomStatusConfig *roomStatusConfig;
@property (nonatomic, assign) ChuangUserRole role;
@property (nonatomic, weak) ChuangLiveEngine *liveEngine;

@end

NS_ASSUME_NONNULL_END
