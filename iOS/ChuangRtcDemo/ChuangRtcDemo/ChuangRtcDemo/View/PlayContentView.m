//
//  PlayContentView.m
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/18.
//

#import "PlayContentView.h"

@interface PlayContentView ()
@property (nonatomic, strong) NSMutableArray<PlaySubView *> *subViewArray;
@end

@implementation PlayContentView
#pragma mark - lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.backgroundColor = [UIColor blueColor];
    }
    
    return _scrollView;
}
- (NSMutableArray<PlaySubView *> *)subViewArray {
    if (!_subViewArray) {
        _subViewArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _subViewArray;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.scrollView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
}

- (void)reloadData {
    
    if ([self.dataSource respondsToSelector:@selector(numberOfIndexInPlayContentView:)]) {
        NSUInteger subViewCount = [self.dataSource numberOfIndexInPlayContentView:self];
        
        for (PlaySubView *subView in self.subViewArray) {
            [subView removeFromSuperview];
        }
        [self.subViewArray removeAllObjects];
        
        CGFloat contentWidth = 8;
        CGFloat height = self.bounds.size.height;
        CGRect frame = CGRectZero;
        for (int i = 0; i < subViewCount; i++) {
            if ([self.dataSource respondsToSelector:@selector(playContentView:subViewForIndex:)]) {
                PlaySubView *subView = [self.dataSource playContentView:self subViewForIndex:i];
                
                if ([self.delegate respondsToSelector:@selector(playContentView:widthForIndexPath:)]) {
                    CGFloat width = [self.delegate playContentView:self widthForIndexPath:i];
                    frame = CGRectMake(contentWidth, 0, width, height);
                    contentWidth += width  + 8;
                }
                
                if (subView.showBig == NO) {
                    [self.scrollView addSubview:subView];
                    [self.subViewArray addObject:subView];
                    subView.frame = frame;
                }else{
                    [self.subViewArray removeObject:subView];
                    self.localView.frame = frame;
                }
            }
        }
        self.scrollView.contentSize = CGSizeMake(contentWidth, height);
    }
    
}
- (void)removeSubViewFromArray:(PlaySubView *)subView {
    [self.subViewArray removeObject:subView];
}

- (PlaySubView *)getFirstPlayView {
    if (self.subViewArray.count > 0) {
        return self.subViewArray[0];
    }
    else {
        return nil;
    }
}

@end
