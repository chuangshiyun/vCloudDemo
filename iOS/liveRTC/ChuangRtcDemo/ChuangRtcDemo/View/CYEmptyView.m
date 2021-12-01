//
//  CYEmptyView.m
//  ChuangRtcDemo
//


#import "CYEmptyView.h"

@implementation CYEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromHex(0xf9fbfa);
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"logo_empt"];
    [self addSubview:logoImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = K_REGULAR_FONT(12);
    titleLabel.textColor = UIColorFromHex(0xb7b7b7);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"会议马上开始，请稍等~";
    [self addSubview:titleLabel];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(81);
        make.height.mas_equalTo(80);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
