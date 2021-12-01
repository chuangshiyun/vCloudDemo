//
//  PlayContentView.h
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/18.
//

#import <UIKit/UIKit.h>
#import "PlaySubView.h"

NS_ASSUME_NONNULL_BEGIN

@class PlayContentView;

@protocol PlayContentViewDelegate <NSObject>

- (void)playContentView:(PlayContentView *)playContentView didSelectSubView:(UIView *)subView index:(NSUInteger)index;
- (CGFloat)playContentView:(PlayContentView *)playContentView widthForIndexPath:(NSUInteger)index;
@end

@protocol PlayContentViewDataSource <NSObject>

- (NSUInteger)numberOfIndexInPlayContentView:(PlayContentView *)playContentView;

- (PlaySubView *)playContentView:(PlayContentView *)playContentView subViewForIndex:(NSUInteger)index;
@end

@interface PlayContentView : UIView
@property (nonatomic, weak) id<PlayContentViewDataSource> dataSource;
@property (nonatomic, weak) id<PlayContentViewDelegate> delegate;
/// 本地预览视图
@property (nonatomic, weak) PlaySubView *localView;
@property (nonatomic, strong) UIScrollView *scrollView;

- (void)reloadData;
/// 从数组中移除控件
- (void)removeSubViewFromArray:(PlaySubView *)subView;

- (PlaySubView *)getFirstPlayView;

@end

NS_ASSUME_NONNULL_END
