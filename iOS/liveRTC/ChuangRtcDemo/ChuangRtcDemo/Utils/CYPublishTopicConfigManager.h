//
//  CYPublishTopicConfigManager.h
//  LiveVieoDemo
//
//  Created by zyh on 2019/11/14.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ChuangRtcKit/ChuangRtcKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CYPublishTopicConfigManager;
@protocol CYPublishTopicConfigManagerDeleaget <NSObject>
//推流设置更新
@optional
- (void)changeEnvIndex:(NSInteger)envIndex;
- (void)changePublishResolution:(CGSize)resolution;
- (void)changePublishFps:(NSInteger)fps;
- (void)changePublishBitrate:(NSInteger)bitrate;
- (void)changeConfigPreset:(NSInteger)configPreset;

- (void)changePublishPreviewViewMode:(ChuangVideoRenderMode)videoViewMode;
- (void)changeHardwareEncode:(BOOL)enableHardwareEncode;
- (void)changePreviewMinnor:(BOOL)isPreviewMinnor;

- (void)changePublishRtmpEnable:(BOOL)publishRtmpEnable;
- (void)changeRtmpAddress:(NSString *)rtmpAddress;
- (void)changeRtmpPort:(NSString *)port;
- (void)changeRtmpAppName:(NSString *)appName;

- (void)changeMixRtmpEnable:(BOOL)MixRtmpEnable;
- (void)changeMixRtmpAddress:(NSString *)mixRtmpAddress;
- (void)changeMixRtmpPort:(NSString *)port;
- (void)changeMixRtmpAppName:(NSString *)mixRtmpAppName;
- (void)changeMixOutputRtmpBitrateKBps:(NSUInteger)mixOutputRtmpBitrateKBps;
- (void)changeMixResolution:(CGSize)mixResolution;

- (void)changeDataTipState:(NSInteger)dataState;


@end

@interface CYPublishTopicConfigManager : NSObject

@property (nonatomic, weak) id <CYPublishTopicConfigManagerDeleaget> delegate;

+ (instancetype)sharedInstance;

- (void)updateEnvironMentIndex:(NSInteger)environmentIndex;
- (NSInteger)environmentIndex;

- (void)updateResolution:(CGSize)resoloution;
- (CGSize)resolution;
- (ChuangVideoConfigPreset)getConfigPresetFromSize:(CGSize)resolution;

- (void)updateBitrate:(NSInteger)bitrate;
- (NSInteger)bitrate;

- (void)updateFps:(NSInteger)fps;
- (NSInteger)fps;

- (void)updateViewMode:(ChuangVideoRenderMode)videoMode;
- (ChuangVideoRenderMode)videoMode;

- (void)updateEnableHardwareEncode:(BOOL)enableHardwareEncode;
- (BOOL)enableHardwareEncode;

- (void)updatePreviewMinnor:(BOOL)previewMinnor;
- (BOOL)previewMinnor;

//推流rtmp开关【可选】
- (void)updatePublishRtmpEnable:(BOOL)rtmpEnable;
- (BOOL)publishRtmpEanble;
//推流rtmp地址等信息配置【可选】
- (void)updateRtmpAddress:(NSString *)rtmpAddress;
- (NSString *)rtmpAddress;

- (void)updateMixRtmpResolution:(CGSize)mixResoloution;
- (CGSize)mixRtmpResolution;

//混流rtmp开关【可选】
- (void)updateMixRtmpEnable:(BOOL)mixRtmpEnable;
- (BOOL)mixRtmpEanble;

//混流rtmp地址等信息配置【可选】
- (void)updateMixRtmpAddress:(NSString *)mixRtmpAddress;
- (NSString *)mixRtmpAddress;

- (void)updateMixOutputRtmpBitrateKBps:(NSUInteger)mixBitrate;
- (NSUInteger)mixOutputRtmpBitrateKBps;

- (void)updataShowDataState:(NSInteger)showDataState;
- (NSInteger)showDataState;

//纯音频开关【可选】
- (void)updataAudioOnleState:(BOOL)isAudioOnly;
- (BOOL)audioOnlyState;

//混流是否同步到Rtc
- (BOOL)mixRtcEnbale;
- (void)updateMixRtcEnable:(BOOL)mixRtcEnable;

@end

NS_ASSUME_NONNULL_END
