//
//  PlayModel.h
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/18.
//

#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangStreamInfo.h>
#import "PlaySubView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayModel : NSObject
@property (nonatomic, strong) ChuangStreamInfo *streamInfo;
@property (nonatomic, strong) ChuangPlayStreamQuality *quality;
@property (nonatomic, strong) PlaySubView *playView;
/// 音频静音
@property (nonatomic, assign, getter=isAudioMute) BOOL audioMute;
/// 视频静音
@property (nonatomic, assign, getter=isVideoMute) BOOL videoMute;
/// 是否显示视频详情
@property (nonatomic, assign, getter=isShowVideoDetail) BOOL showVideoDetail;
///  音量值 0-100 数值越大，音量越大
@property (nonatomic, assign) int soundLevel;
///  网速
@property (nonatomic, assign) int networkSpeedtest;
/// 是否开启音量监测
@property (nonatomic, assign) BOOL isOpenSoundLevel;
/// 是否开启网络测速
@property (nonatomic, assign) BOOL isOpenSpeedtest;

@end

NS_ASSUME_NONNULL_END
