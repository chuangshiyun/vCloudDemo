//
//  CYInteractionSetView.h
//  ChuangRtcDemo
//


#import <UIKit/UIKit.h>
#import "CYInteractionStatusConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CYInteractionSetViewDelegate <NSObject>

///麦克风状态
- (void)muteAudioWithStreamId:(NSString *)streamId isMute:(BOOL)mute;

///摄像头状态 
- (void)muteVideoWithStreamId:(NSString *)streamId isMute:(BOOL)mute isLocal:(BOOL)isLocal;

///视频模式
- (void)renderModelWithStreamId:(NSString *)streamId model:(ChuangVideoRenderMode)renderModel;

@end

@interface CYInteractionSetView : UIView

@property (nonatomic, weak) id <CYInteractionSetViewDelegate> delegate;
@property (nonatomic, weak) CYInteractionStatusConfig *interactionConfig;
@property (nonatomic, weak) ChuangLiveEngine *liveEngine;

- (void)show;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
