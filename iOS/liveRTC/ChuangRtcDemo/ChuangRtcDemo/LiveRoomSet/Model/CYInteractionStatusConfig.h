//
//  CYInteractionStatusConfig.h
//  ChuangRtcDemo
//

#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangRtcKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,VideoStatus) {
    VideoStatus_Normal = 0,         ///摄像头开启
    VideoStatus_LocalClosed,        ///本地关闭摄像头
    VideoStatus_RemoteClosed        ///远端关闭摄像头
};

typedef NS_ENUM(NSInteger,AudioStatus) {
    AudioStatus_Normal = 0,         ///麦克风开启
    AudioStatus_LocalClosed,        ///本地关闭麦克风
    AudioStatus_RemoteClosed        ///远端关闭麦克风
};

@interface CYInteractionStatusConfig : NSObject

@property (nonatomic, assign) VideoStatus muteVideoStatus;
@property (nonatomic, assign) AudioStatus muteAudioStatus;
@property (nonatomic, assign) ChuangVideoRenderMode renderMode;
@property (nonatomic, strong) NSString *streamId;

@end

NS_ASSUME_NONNULL_END
