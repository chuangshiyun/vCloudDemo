//
//  CYPreSetRTCCell.m
//  ChuangRtcDemo
//


#import "CYPreSetRTCCell.h"

@interface CYPreSetRTCCell ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation CYPreSetRTCCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.rigthSwitch];
    [self.contentView addSubview:self.lineView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(15);
        make.centerY.equalTo(self.backView);
    }];
    
    [self.rigthSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-15);
        make.centerY.equalTo(self.backView);
        make.height.mas_equalTo(31);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    self.lineView.hidden = YES;
}

- (void)swichClick:(UISwitch *)sender {
    if (self.openCallBlock) {
        self.openCallBlock(sender.isOn);
    }
}


#pragma mark -- lazy

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromHex(0x303336);
        _titleLabel.font = K_REGULAR_FONT(15);
    }
    return _titleLabel;
}

- (UISwitch *)rigthSwitch {
    if (!_rigthSwitch) {
        _rigthSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        _rigthSwitch.tintColor = [UIColor grayColor];
        _rigthSwitch.onTintColor = [UIColor blueColor];
        _rigthSwitch.thumbTintColor = [UIColor whiteColor];
        _rigthSwitch.backgroundColor = [UIColor clearColor];
        [_rigthSwitch addTarget:self action:@selector(swichClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rigthSwitch;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromHex(0x999999);
    }
    return _lineView;
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
