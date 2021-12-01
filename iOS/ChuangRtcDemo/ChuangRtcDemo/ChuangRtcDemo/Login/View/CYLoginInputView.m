//
//  CYLoginInputView.m
//  ChuangRtcDemo
//

#import "CYLoginInputView.h"

@interface CYLoginInputView ()

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation CYLoginInputView


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = K_REGULAR_FONT(13);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textAlignment = NSTextAlignmentCenter;
    }
    return _textField;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromHex(0xCBCBCB);
    }
    return _bottomLine;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.textField];
        [self addSubview:self.bottomLine];
    }
    return self;
}

#pragma mark - seter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (placeholder) {
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:K_REGULAR_FONT(13), NSForegroundColorAttributeName: UIColorFromHex(0x888a8a)}];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
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
