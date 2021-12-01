//
//  CYVideoRenderModeSelectView.m
//  LiveVieoDemo
//
//  Created by wzh on 2021/3/18.
//  Copyright © 2021 CY. All rights reserved.
//

#import "CYVideoRenderModeSelectView.h"

@interface CYVideoRenderModeSelectView ()
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, assign) NSInteger selectedRendMode;
@end

@implementation CYVideoRenderModeSelectView
#pragma mark - lazy
- (NSMutableArray<UIButton *> *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _buttonArray;
}
#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = self.buttonArray.count;
    CGFloat btnH = self.bounds.size.height/count;
    CGFloat btnW = self.bounds.size.width;
    
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.buttonArray[i];
        btn.frame = CGRectMake(0, btnH*i, btnW, btnH);
    }
}

#pragma mark - seter
- (void)setDataArray:(NSArray<NSString *> *)dataArray {

    _dataArray = dataArray;
    
    [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.buttonArray removeAllObjects];
    
    for (NSUInteger i = 0; i < dataArray.count; i++) {
        NSString *title = dataArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.tag = i;
        if (i == 0) {
            btn.selected = YES;
            _selectedRendMode = i;
        }else{
            btn.selected = NO;
        }
        [btn addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        [self addSubview:btn];
        [self.buttonArray addObject:btn];
    }
}

#pragma mark - 按钮点击事件监听
- (void)itemButtonClick:(UIButton *)btn {
    _selectedRendMode = btn.tag;
    btn.selected = YES;
    for (UIButton *itemBtn in self.buttonArray ) {
        if (itemBtn.tag != btn.tag) {
            itemBtn.selected = NO;
        }
    }
    if (self.renderModeDidSelectBlock) {
        self.renderModeDidSelectBlock(btn.tag);
    }
}
@end
