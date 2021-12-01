//
//  LogView.h
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogView : UIView
///打开关闭日志
- (void)updateLogState:(BOOL)isOpen;

- (void)appendProcessTipAndMakeVisible:(NSString *)tipText;
@end

NS_ASSUME_NONNULL_END
