//
//  CYLiveRoomSetTextCell.m
//  ChuangRtcDemo
//


#import "CYLiveRoomSetTextCell.h"

@implementation CYLiveRoomSetTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = SMViewBGColor;
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.sendBtn];
    [self.backView addSubview:self.textfield];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-15);
        make.centerY.equalTo(self.backView);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(35);
    }];
    
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(15);
        make.centerY.equalTo(self.backView);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.sendBtn.mas_left).offset(-15);
    }];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = K_REGULAR_FONT(13);
        _sendBtn.backgroundColor = UIColorFromHex(0x0061ff);
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 2.5;
    }
    return _sendBtn;
}

- (UITextField *)textfield {
    if (!_textfield) {
        _textfield = [[UITextField alloc] init];
        _textfield.placeholder = @"请输入内容";
        _textfield.font = K_REGULAR_FONT(13);
    }
    return _textfield;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
