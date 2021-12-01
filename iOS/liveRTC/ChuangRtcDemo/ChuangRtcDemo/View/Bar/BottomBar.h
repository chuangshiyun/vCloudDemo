//
//  BottomBar.h
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottomBar : UIView

/// 静音音频按
@property (nonatomic, weak) UIButton *muteAudioButton;
/// 静音视频按钮
@property (nonatomic, weak) UIButton *muteVideoButton;
/// 挂断按钮
@property (nonatomic, weak) UIButton *hangupButton;

/// 前后置摄像头切换按钮
@property (nonatomic, weak) UIButton *switchCameraButton;

/// 用户按钮
@property (nonatomic, weak) UIButton *userButton;

///互动窗口数量
@property (nonatomic, assign) NSUInteger interactionCount;
@property (nonatomic, weak) UILabel *interactionCountLabel;
@end

NS_ASSUME_NONNULL_END
