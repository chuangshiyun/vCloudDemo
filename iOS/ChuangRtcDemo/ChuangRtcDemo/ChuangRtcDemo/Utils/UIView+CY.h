//
//  UIView+CY.h
//  vClass
//
//  Created by wzh on 2021/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CY)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
#pragma mark - hud
/// 显示提示语
/// @param text 文本
/// @param isHidden 是否隐藏底部遮盖
- (void)CY_showHudText:(NSString *)text isHiddenCoverView:(BOOL)isHidden;

/// 显示提示语
/// @param text 文本
/// @param duration 显示时长
- (void)CY_showHudText:(NSString *)text duration:(CGFloat)duration;

/// 显示提示语
/// @param text 文本
- (void)CY_showHudText:(NSString *)text;

/// 隐藏提示语
- (void)CY_hiddenHud;

#pragma mark - 拖拽手势

/// 添加拖拽手势
/// @param endBlock 拖拽结束的位置
- (void)addDragableActionWithEnd:(nullable void (^)(CGRect endFrame))endBlock;
@end

NS_ASSUME_NONNULL_END
