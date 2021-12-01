//
//  BottomBar.m
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/24.
//

#import "BottomBar.h"

@implementation BottomBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.interactionCount = 0;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    
    UIButton *muteAudioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [muteAudioButton setImage:[UIImage imageNamed:@"n_micphone"] forState:UIControlStateNormal];
    [muteAudioButton setImage:[UIImage imageNamed:@"n_micphone_off"] forState:UIControlStateSelected];
    
    UIButton *muteVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [muteVideoButton setImage:[UIImage imageNamed:@"n_camera"] forState:UIControlStateNormal];
    [muteVideoButton setImage:[UIImage imageNamed:@"n_camera_off"] forState:UIControlStateSelected];
    
    
    UIButton *hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hangupButton setImage:[UIImage imageNamed:@"n_hangup"] forState:UIControlStateNormal];
    [hangupButton setImage:[UIImage imageNamed:@"dial"] forState:UIControlStateSelected];
        
    UIButton *switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:[UIImage imageNamed:@"n_changeCamera"] forState:UIControlStateNormal];
    
    
    UIButton *userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [userButton setImage:[UIImage imageNamed:@"n_user"] forState:UIControlStateNormal];
    
    UILabel *interactionCountLabel = [[UILabel alloc] init];
    interactionCountLabel.textColor = UIColorFromHex(0xeb2323);
    interactionCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    
        
    [self addSubview:muteAudioButton];
    [self addSubview:muteVideoButton];
    [self addSubview:hangupButton];
    [self addSubview:switchCameraButton];
    [self addSubview:userButton];
    [self addSubview:interactionCountLabel];
    
    
    self.muteAudioButton = muteAudioButton;
    self.muteVideoButton = muteVideoButton;
    self.hangupButton = hangupButton;
    self.switchCameraButton = switchCameraButton;
    self.userButton = userButton;
    self.interactionCountLabel = interactionCountLabel;
    
}

- (void)setInteractionCount:(NSUInteger)interactionCount {
    _interactionCount = interactionCount;
    self.interactionCountLabel.text = [NSString stringWithFormat:@"%ld",interactionCount];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnW = self.bounds.size.width/5;
    CGFloat btnH = self.bounds.size.height;
    self.layer.cornerRadius = self.bounds.size.height/2;

    
    self.muteAudioButton.frame = CGRectMake(0, 0, btnW, btnH);
    
    CGFloat videoX = CGRectGetMaxX(self.muteAudioButton.frame);
    self.muteVideoButton.frame = CGRectMake(videoX, 0, btnW, btnH);
    
    CGFloat hangupX = CGRectGetMaxX(self.muteVideoButton.frame);
    self.hangupButton.frame = CGRectMake(hangupX, 0, btnW, btnH);
    
    CGFloat switchX = CGRectGetMaxX(self.hangupButton.frame);
    self.switchCameraButton.frame = CGRectMake(switchX, 0, btnW, btnH);
    
    CGFloat userX = CGRectGetMaxX(self.switchCameraButton.frame);
    self.userButton.frame = CGRectMake(userX, 0, btnW, btnH);
    
    CGFloat countX = CGRectGetMaxX(self.userButton.frame);
    self.interactionCountLabel.frame = CGRectMake(countX - 26, 13, 15, 10);
    
}
@end
