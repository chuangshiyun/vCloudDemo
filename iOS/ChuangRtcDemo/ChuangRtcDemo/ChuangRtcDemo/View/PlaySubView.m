//
//  PlaySubView.m
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/18.
//

#import "PlaySubView.h"

@interface PlaySubView ()
@property (nonatomic, weak) UIView *contentView;
/// 大小屏幕切换
@property (nonatomic, weak) UIButton *switchBtn;
@property (nonatomic, weak) UIButton *setBtn;
@end

@implementation PlaySubView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setupSubViews];
        
    }
    return self;
}

- (void)setupSubViews {
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIView *renderView = [[UIView alloc] init];
    [contentView addSubview:renderView];
    self.renderView = renderView;

    UIImageView *placeholdImageView = [[UIImageView alloc] init];
    placeholdImageView.image = [UIImage imageNamed:@"audioPic"];
    [contentView addSubview:placeholdImageView];
    self.placcholdImageview = placeholdImageView;
    placeholdImageView.hidden = YES;
    
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:10];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    
    UILabel *qualityLabel = [[UILabel alloc] init];
//    qualityLabel.backgroundColor = [UIColor orangeColor];
    qualityLabel.numberOfLines = 0;
    qualityLabel.font = [UIFont systemFontOfSize:8];
    qualityLabel.textColor = UIColorFromHex(0xeb2323);
    [contentView addSubview:qualityLabel];
    self.qualityLabel = qualityLabel;
    
    UILabel *soundLevelLabel = [[UILabel alloc] init];
    soundLevelLabel.numberOfLines = 0;
    soundLevelLabel.font = [UIFont systemFontOfSize:10];
    soundLevelLabel.textColor = [UIColor redColor];
    [contentView addSubview:soundLevelLabel];
    self.soundLevelLabel = soundLevelLabel;
    soundLevelLabel.hidden = YES;
    
    UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [switchBtn addTarget:self action:@selector(switchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:switchBtn];
    self.switchBtn = switchBtn;
    
    UIButton *setBtn = [[UIButton alloc] init];
    [setBtn setImage:[UIImage imageNamed:@"login_set"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:setBtn];
    self.setBtn = setBtn;
    
    [self setupLayoutSubViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupLayoutSubViews];
    
}

- (void)setShowBig:(BOOL)showBig {
    _showBig = showBig;
    self.switchBtn.hidden = showBig;
    [self setupLayoutSubViews];
    
}

- (void)setIsLocal:(BOOL)isLocal {
    _isLocal = isLocal;
    self.setBtn.hidden = YES;
   
}

- (void)setupLayoutSubViews {
    
    CGSize viewSize = self.bounds.size;
    
    self.contentView.frame = self.bounds;
    self.placcholdImageview.frame = self.bounds;
    self.renderView.frame = self.bounds;
    
    CGFloat labelW = viewSize.width;
    CGFloat labelH = 30;
    self.nameLabel.frame = CGRectMake(0, 0, labelW, labelH);
    
    CGFloat btnH = 35;
    CGFloat btnW = 35;
    CGFloat qualityLabelW = viewSize.width - btnW;
    CGFloat qualityLabelH = viewSize.height - labelH - btnH;
    self.qualityLabel.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), qualityLabelW, qualityLabelH);
    
    
    CGFloat btnX = viewSize.width - btnW;
    
    if (self.showBig) {
        btnX = viewSize.width - btnW;
        self.nameLabel.frame = CGRectMake(0, 0, labelW, 13);
        self.setBtn.frame = CGRectMake(btnX, 0, btnW, btnH);
    }else{
        self.nameLabel.frame = CGRectMake(0, 0, labelW, 13);
        self.setBtn.frame = CGRectMake(btnX, 5, btnW, btnH);
    }
    
    
    
    CGFloat soundLevelLabelY = viewSize.height - labelH;
    self.soundLevelLabel.frame = CGRectMake(0, soundLevelLabelY, labelW, labelH);
    
    
//    CGFloat switchBtnX = viewSize.width - btnW;
//    CGFloat switchBtnY = viewSize.height - btnH;
//    self.switchBtn.frame = CGRectMake(switchBtnX, switchBtnY, btnW, btnH);
    self.switchBtn.frame = self.bounds;
    
    [self.renderView.layer.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = self.bounds;
    }];
    
}

- (void)setStreamInfo:(ChuangStreamInfo *)streamInfo {
    _streamInfo = streamInfo;
    
    self.nameLabel.text = streamInfo.streamId;
}

#pragma mark - 按钮点击事件监听
- (void)muteVideoButtonClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(playSubView:muteVideoButtonDidClick:)]) {
        [self.delegate playSubView:self muteVideoButtonDidClick:btn];
    }
}
- (void)muteAudioButtonClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(playSubView:muteAudioButtonDidClick:)]) {
        [self.delegate playSubView:self muteAudioButtonDidClick:btn];
    }
}

- (void)switchBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(switchSubView:)]) {
        [self.delegate switchSubView:self];
    }
}

- (void)setBtnClick {
    if ([self.delegate respondsToSelector:@selector(showInteractionSetViewWithStreamId:)]) {
        [self.delegate showInteractionSetViewWithStreamId:self.streamInfo.streamId];
    }
}

@end
