//
//  CYPublishTopicConfigManager.m
//  LiveVieoDemo
//
//  Created by zyh on 2019/11/14.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYPublishTopicConfigManager.h"
#import "CYAPIHeader.h"
#import "Define.h"
#import "CYKeyCenter.h"

static CYPublishTopicConfigManager *manager = nil;
 
@implementation CYPublishTopicConfigManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    return [CYPublishTopicConfigManager sharedInstance];
}
- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (void)updateEnvironMentIndex:(NSInteger)environmentIndex{
    NSNumber *index = @(environmentIndex);
    [[NSUserDefaults standardUserDefaults] setObject:index forKey:CYPublishConfigEnvIndexKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate,changeEnvIndex,environmentIndex);
}
- (NSInteger)environmentIndex{
    NSInteger index = 0;
    NSInteger oldIndex = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigEnvIndexKey] integerValue] ;
    if (oldIndex > 0) {
        index = oldIndex;
    }
    return index;
}
- (void)updateResolution:(CGSize)resoloution{
    NSArray *sizeArr = @[@(resoloution.width),@(resoloution.height)];
    [[NSUserDefaults standardUserDefaults] setObject:sizeArr forKey:CYPublishConfigResolutionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate,changePublishResolution, resoloution);
}
- (CGSize)resolution{
    CGSize rs = CGSizeZero;
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigResolutionKey];
   if (arr && arr.count == 2) {
       rs = CGSizeMake(((NSNumber*)arr[0]).integerValue, ((NSNumber*)arr[1]).integerValue);
   } else {
       // 设置默认
       rs = CGSizeMake(540, 960);
   }
    return rs;
    
}
- (ChuangVideoConfigPreset)getConfigPresetFromSize:(CGSize)resolution{
    CGFloat width = resolution.width;
    if (width == 180) {
        return ChuangVideoConfigPreset180X320_15_300;
    }else if (width == 270){
        return ChuangVideoConfigPreset270X480_15_400;
    }else if (width == 360){
        return ChuangVideoConfigPreset360X640_15_600;
    }else if (width == 540){
        return ChuangVideoConfigPreset540X960_15_1200;
    }else if (width == 720){
        return ChuangVideoConfigPreset720X1280_15_1500;
    }else if (width == 1080){
        return ChuangVideoConfigPreset1080X1920_15_3000;
    }else{
        return ChuangVideoConfigPreset540X960_15_1200;
    }
}

- (void)updateBitrate:(NSInteger)bitrate{
    NSNumber *bit = @(bitrate);
    [[NSUserDefaults standardUserDefaults] setObject:bit forKey:CYPublishConfigBitrateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate, changePublishBitrate, bitrate);
    
}
//
- (NSInteger)bitrate{
    NSInteger bits = 0;
    NSInteger oldBit = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigBitrateKey] integerValue] ;
    if ( oldBit > 0) {
        bits = oldBit;
    }else{
        bits = 1200;
    }
    return bits;
}

- (void)updateFps:(NSInteger)fps{
    NSNumber *fpss = @(fps);
    [[NSUserDefaults standardUserDefaults] setObject:fpss forKey:CYPublishConfigFpsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate, changePublishFps, fps);
    
}
//
- (NSInteger)fps{
    NSInteger fps = 0;
    NSInteger oldfps = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigFpsKey] integerValue];
    if (oldfps > 0) {
        fps = oldfps;
    }else{
        fps = 15;//默认
    }
    return fps;
}

- (ChuangVideoRenderMode)videoMode{
    ChuangVideoRenderMode mode = ChuangVideoRenderModePerfectFill;
    NSNumber * m = [[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigPreviewViewModeKey];
    ChuangVideoRenderMode videoMode = [m intValue];
    if (videoMode) {
        mode = videoMode;
    }else{
        mode = ChuangVideoRenderModePerfectFit;//
    }
    return mode;
}
- (void)updateViewMode:(ChuangVideoRenderMode)videoMode{
    NSNumber *mode = @(videoMode);
    [[NSUserDefaults standardUserDefaults] setObject:mode forKey:CYPublishConfigPreviewViewModeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate,changePublishPreviewViewMode, videoMode);
}

- (BOOL)enableHardwareEncode{
    BOOL isEnable = NO;
    NSNumber *n = [[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigEnableHardwareEncodeKey];
    if ([n boolValue] != NO) {
        isEnable = [n boolValue];
    }
    return isEnable;
}
- (void)updateEnableHardwareEncode:(BOOL)enableHardwareEncode{
    NSNumber *hardware = @(enableHardwareEncode);
    [[NSUserDefaults standardUserDefaults] setObject:hardware forKey:CYPublishConfigEnableHardwareEncodeKey];
    SAFE_CALL_OneParam(self.delegate, changeHardwareEncode, enableHardwareEncode);
}


- (BOOL)previewMinnor{
    BOOL isMinnor = NO;
    NSNumber *n = [[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigPreviewMinnorKey];
    if ([n boolValue] != NO) {
        isMinnor = [n boolValue];
    }
    return isMinnor;
}
- (void)updatePreviewMinnor:(BOOL)previewMinnor{
    NSNumber *previewMinn = @(previewMinnor);
    [[NSUserDefaults standardUserDefaults] setObject:previewMinn forKey:CYPublishConfigPreviewMinnorKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate, changePreviewMinnor, previewMinnor);
}


- (BOOL)publishRtmpEanble{
    BOOL rtmpEnable = NO;
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:CYPublishRtmpEnableKey];
    if ([num boolValue] != NO) {
        rtmpEnable = [num boolValue];
    }
    return rtmpEnable;
}
//推流rtmp开关【演示方便】
- (void)updatePublishRtmpEnable:(BOOL)rtmpEnable{
    NSNumber *rtmpEanble = @(rtmpEnable);
    [[NSUserDefaults standardUserDefaults] setObject:rtmpEanble forKey:CYPublishRtmpEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate, changePublishRtmpEnable, rtmpEanble);
}

- (NSString *)rtmpAddress{
    NSString *rtmpaddr = @"";
    rtmpaddr = [[NSUserDefaults standardUserDefaults] objectForKey:CYPublishRtmpAddressKey];
    if (rtmpaddr.length > 0) {
        return rtmpaddr;
    }else {
        return @"";
    }
//    else{
//        return CYKeyCenter.rtmpAddr;
//    }
}
//推流rtmp地址等信息配置【可选】
- (void)updateRtmpAddress:(NSString *)rtmpAddress{
    NSString *rtmpaddr = rtmpAddress;
    [[NSUserDefaults standardUserDefaults] setObject:rtmpaddr forKey:CYPublishRtmpAddressKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate,changeRtmpAddress, rtmpaddr);
}

- (BOOL)mixRtmpEanble{
    BOOL mixRtmpEnable = NO;
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:CYMixStreamRtmpEnableKey];
    if ([num boolValue] != NO) {
        mixRtmpEnable = [num boolValue];
    }
    return mixRtmpEnable;
}
//混流rtmp开关【演示方便】
- (void)updateMixRtmpEnable:(BOOL)mixRtmpEnable{
    NSNumber *mixStreamRtmpEnable = @(mixRtmpEnable);
    [[NSUserDefaults standardUserDefaults] setObject:mixStreamRtmpEnable forKey:CYMixStreamRtmpEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate, changeMixRtmpEnable, mixStreamRtmpEnable);
}

- (BOOL)mixRtcEnbale {
    BOOL mixRtcEnable = NO;
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:CYMixRTCEnableKey];
    if ([num boolValue] != NO) {
        mixRtcEnable = [num boolValue];
    }
    return mixRtcEnable;
}


- (void)updateMixRtcEnable:(BOOL)mixRtcEnable {
    NSNumber *mixRtcEnableNum = @(mixRtcEnable);
    [[NSUserDefaults standardUserDefaults] setObject:mixRtcEnableNum forKey:CYMixRTCEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString *)mixRtmpAddress{
    NSString *mixRtmpaddr = @"";
    mixRtmpaddr = [[NSUserDefaults standardUserDefaults] objectForKey:CYMixStreamRtmpAddressKey];
    if (mixRtmpaddr.length > 0) {
        return mixRtmpaddr;
    }
    else {
        return @"";
    }
//    else{
//        return CYKeyCenter.mixRtmpAddr;
//    }
}
//混流rtmp地址等信息配置【可选】
- (void)updateMixRtmpAddress:(NSString *)mixRtmpAddress{
    NSString *mixRtmpAddr = mixRtmpAddress;
    [[NSUserDefaults standardUserDefaults] setObject:mixRtmpAddr forKey:CYMixStreamRtmpAddressKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
   SAFE_CALL_OneParam(self.delegate,changeMixRtmpAddress, mixRtmpAddr);
}


- (NSUInteger)mixOutputRtmpBitrateKBps{
    NSUInteger mixBitrate = 0;
    NSUInteger oldmixBitrate = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:CYMixOutputRtmpBitrateKBpsKey] integerValue];
    if (oldmixBitrate > 0) {
       mixBitrate = oldmixBitrate;
    }else{
       mixBitrate = CYKeyCenter.mixOutputRtmpBitrateKBps;
    }
    return mixBitrate;
}
- (void)updateMixOutputRtmpBitrateKBps:(NSUInteger)mixBitrate{
    NSNumber *mixOutputBitrate = @(mixBitrate);
    [[NSUserDefaults standardUserDefaults] setObject:mixOutputBitrate forKey:CYMixOutputRtmpBitrateKBpsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate, changeMixOutputRtmpBitrateKBps, mixBitrate);
}


- (CGSize)mixRtmpResolution{
    CGSize rs = CGSizeZero;
       NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:CYMixOutputRtmpResolutionKey];
      if (arr && arr.count == 2) {
          rs = CGSizeMake(((NSNumber*)arr[0]).integerValue, ((NSNumber*)arr[1]).integerValue);
      } else {
          // 设置默认
          rs = CGSizeMake(432, 768);
      }
       return rs;
    
}
- (void)updateMixRtmpResolution:(CGSize)mixResoloution{
    NSArray *sizeArr = @[@(mixResoloution.width),@(mixResoloution.height)];
    [[NSUserDefaults standardUserDefaults] setObject:sizeArr forKey:CYMixOutputRtmpResolutionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate,changeMixResolution, mixResoloution);
}


- (NSInteger)showDataState{
    NSInteger  dataState = 0;
    NSInteger  oldDataState = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:CYPlayVideoDataStateKey] integerValue];
    if (oldDataState != dataState) {
        dataState = oldDataState;
    }
    return dataState;
}
- (void)updataShowDataState:(NSInteger)showDataState{
    NSNumber *showVideoDataState = @(showDataState);
    [[NSUserDefaults standardUserDefaults] setObject:showVideoDataState forKey:CYPlayVideoDataStateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SAFE_CALL_OneParam(self.delegate, changeDataTipState, showDataState);
}



- (BOOL)audioOnlyState {
    BOOL isAudioOnly = NO;
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:CYAudioOnlyStateKey];
    if ([num boolValue] != NO) {
        isAudioOnly = [num boolValue];
    }
    return isAudioOnly;
}
//纯音频开关【演示方便】
- (void)updataAudioOnleState:(BOOL)isAudioOnly {
    NSNumber *audioOnly = [NSNumber numberWithBool:isAudioOnly];
    [[NSUserDefaults standardUserDefaults] setObject:audioOnly forKey:CYAudioOnlyStateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
