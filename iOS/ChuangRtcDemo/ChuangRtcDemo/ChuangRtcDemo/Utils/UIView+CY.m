//
//  UIView+CY.m
//  vClass
//
//  Created by wzh on 2021/2/20.
//

#import "UIView+CY.h"

#define K_Hud_Tag 9090901
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height




@implementation UIView (CY)
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    //    self.width = size.width;
    //    self.height = size.height;
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

#pragma mark - hud
- (void)CY_showHudText:(NSString *)text duration:(CGFloat)duration
{
    [self CY_showHudText:text isHiddenCoverView:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self CY_hiddenHud];
    });

}
- (void)CY_showHudText:(NSString *)text {
    [self CY_showHudText:text isHiddenCoverView:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self CY_hiddenHud];
    });
}
- (void)CY_showHudText:(NSString *)text isHiddenCoverView:(BOOL)isHidden
{
    [self CY_hiddenHud];
    UIView *coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    coverView.tag = K_Hud_Tag;
    coverView.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.25];
    coverView.hidden = isHidden;
    CGFloat height = 45;
    CGFloat width = 220;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    if(size.height > height){
        height = size.height;
    }else{
        width = size.width + 60;
    }
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    contentView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2 - height);
    contentView.layer.cornerRadius = 7;
    contentView.layer.masksToBounds = YES;
    contentView.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.8];;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.textColor = [UIColor whiteColor];
    [contentView addSubview:label];
    
    if (coverView.isHidden) {
        contentView.tag = K_Hud_Tag;
        [self addSubview:contentView];
    }else{
        [coverView addSubview:contentView];
        [self addSubview:coverView];
    }

}
- (void)CY_hiddenHud
{
    UIView *coverView = [self viewWithTag:K_Hud_Tag];
    [UIView animateWithDuration:0.25 animations:^{
        [coverView removeFromSuperview];
    }];
}


@end
