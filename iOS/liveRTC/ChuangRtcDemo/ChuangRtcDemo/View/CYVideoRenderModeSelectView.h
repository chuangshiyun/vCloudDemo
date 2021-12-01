//
//  CYVideoRenderModeSelectView.h
//  LiveVieoDemo
//
//  Created by wzh on 2021/3/18.
//  Copyright © 2021 CY. All rights reserved.
// 视频渲染模式选择视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 视频渲染模式选择视图
@interface CYVideoRenderModeSelectView : UIView
@property (nonatomic, strong) NSArray<NSString *> *dataArray;
@property (nonatomic, copy) void(^renderModeDidSelectBlock)(NSUInteger index);
@end

NS_ASSUME_NONNULL_END
