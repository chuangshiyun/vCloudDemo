//
//  CYLiveRoomStatusConfig.m
//  ChuangRtcDemo
//


#import "CYLiveRoomStatusConfig.h"

@implementation CYLiveRoomStatusConfig
- (instancetype)init {
    self = [super init];
    if (self) {
        self.isOpenMirror = NO;
        self.isOpenSpeedTest = NO;
        self.isOpenSoundLevel = NO;
        self.isOpenLog = NO;
        self.isOpenMixAudio = NO;
        self.isMixStream = NO;
        self.isOpenMirror = YES;
        self.renderMode = 0;
        self.cameraType = 0;
        self.isOpenLocalCamera = YES;
        self.isOpenLocalAudio = YES;
        self.publishState = ChuangPublishStateDisconnected;
    }
    return self;
}

@end
