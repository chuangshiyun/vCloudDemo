//
//  PlaySubView.h
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/18.
//

#import <UIKit/UIKit.h>
#import <ChuangRtcKit/ChuangStreamInfo.h>
#import "CYVideoRenderModeSelectView.h"

NS_ASSUME_NONNULL_BEGIN
@class PlaySubView;

@protocol PlaySubViewDelegate <NSObject>

- (void)playSubView:(PlaySubView *)playSubView muteVideoButtonDidClick:(UIButton *)btn;
- (void)playSubView:(PlaySubView *)playSubView muteAudioButtonDidClick:(UIButton *)btn;
/// 大小视图切换回调
- (void)switchSubView:(PlaySubView *)playSubView;
- (void)screenShotRemoteImg:(NSString *)streamId;
///设置
- (void)showInteractionSetViewWithStreamId:(NSString *)streamId;

@end

@interface PlaySubView : UIView
@property (nonatomic, weak) id<PlaySubViewDelegate> delegate;
@property (nonatomic, strong) ChuangStreamInfo *streamInfo;
@property (nonatomic, weak) UIView *renderView;

/// 播流质量
@property (nonatomic, weak) UILabel *qualityLabel;
@property (nonatomic, weak) UIButton *muteVideoButton;
@property (nonatomic, weak) UIButton *muteAudioButton;
/// 模式选择
@property (nonatomic, weak) CYVideoRenderModeSelectView *modeView;
/// 音量大小展示
@property (nonatomic, weak) UILabel *soundLevelLabel;
/// 是否显示大视图
@property (nonatomic, assign) BOOL showBig;
/// 是否是本地预览视图
@property (nonatomic, assign) BOOL isLocal;
///占位图
@property (nonatomic, weak) UIImageView *placcholdImageview;
///用户名
@property (nonatomic, weak) UILabel *nameLabel;
@end

NS_ASSUME_NONNULL_END
