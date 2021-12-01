//
//  CYLiveRoomSettingFootView.m
//  ChuangRtcDemo
//


#import "CYLiveRoomSettingFootView.h"

@implementation CYLiveRoomSettingFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SMViewBGColor;
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    [self addSubview:self.backView];
    [self.backView addSubview:self.screenShotBtn];
    [self.backView addSubview:self.screenShotImageView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(160);
    }];
    
    [self.screenShotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-15);
        make.centerY.equalTo(self.backView);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(35);
    }];
    
    [self.screenShotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.left.equalTo(self.backView.mas_left).offset(15);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(160);
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIButton *)screenShotBtn {
    if (!_screenShotBtn) {
        _screenShotBtn = [[UIButton alloc] init];
        [_screenShotBtn setTitle:@"截图" forState:UIControlStateNormal];
        [_screenShotBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _screenShotBtn.titleLabel.font = K_REGULAR_FONT(13);
        _screenShotBtn.backgroundColor = UIColorFromHex(0x0061ff);
        _screenShotBtn.layer.masksToBounds = YES;
        _screenShotBtn.layer.cornerRadius = 2.5;
    }
    return _screenShotBtn;
}

- (UIImageView *)screenShotImageView {
    if (!_screenShotImageView) {
        _screenShotImageView = [[UIImageView alloc] init];
        _screenShotImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _screenShotImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
