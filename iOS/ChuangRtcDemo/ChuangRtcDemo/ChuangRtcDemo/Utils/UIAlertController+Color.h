//
//  UIAlertController+Color.h
//  liveClassRoomDemo
//
//  Created by 花花 on 2020/9/10.
//  Copyright © 2020 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Color)

@property (nonatomic,strong) UIColor *tintColor; /**< 统一按钮样式 不写系统默认的蓝色 */
@property (nonatomic,strong) UIColor *titleColor; /**< 标题的颜色 */
@property (nonatomic,strong) UIColor *messageColor; /**< 信息的颜色 */

/**
 根据otherActionTitles数组创建UIAlertController

 @param title title
 @param message message
 @param cancelActionTitle 取消Action标题
 @param otherActionTitles 其他Action标题
 @param handle 点击回调 -1 取消Action点击 0~n 其他Action点击
 @return UIAlertController
 */
+(instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message cancelActionTitle:(NSString *)cancelActionTitle otherActionTitles:(NSArray<NSString *> *)otherActionTitles handle:(void (^)(NSInteger index))handle;

@end

NS_ASSUME_NONNULL_END

@interface UIAlertAction (Color)

@property (nonatomic,strong) UIColor * _Nullable textColor; /**< 按钮title字体颜色 */

@end
