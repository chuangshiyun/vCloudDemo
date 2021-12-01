//
//  CYChooseRolesCell.m
//  ChuangRtcDemo
//

#import "CYChooseRolesCell.h"

@implementation CYChooseRolesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.roomIdLabel];
    [self.bgImageView addSubview:self.titleLabel];
    [self.bgImageView addSubview:self.subTitleLabel];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
        make.height.mas_equalTo(K_Width(133.5));
    }];
    
    CGFloat width = (SCREEN_WIDTH - 30)/2;
    [self.roomIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(width + 40);
        make.centerY.equalTo(self.bgImageView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roomIdLabel);
        make.bottom.equalTo(self.roomIdLabel.mas_top).offset(-12);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roomIdLabel);
        make.top.equalTo(self.roomIdLabel.mas_bottom).offset(6);
    }];
}

- (void)setRoleModel:(CYRoleModel *)roleModel {
    _roleModel = roleModel;
    self.bgImageView.image = [UIImage imageNamed:roleModel.bgImage];
    self.roomIdLabel.text = [NSString stringWithFormat:@"房间ID:%@",roleModel.roomId];
    self.titleLabel.text = roleModel.title;
    self.subTitleLabel.text = roleModel.subTitle;
}

#pragma mark -- lazy
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (UILabel *)roomIdLabel {
    if (!_roomIdLabel) {
        _roomIdLabel = [[UILabel alloc] init];
        _roomIdLabel.font = K_REGULAR_FONT(12);
        _roomIdLabel.textColor = [UIColor whiteColor];
    }
    return _roomIdLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = K_REGULAR_FONT(19);
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = K_REGULAR_FONT(12);
        _subTitleLabel.textColor = [UIColor whiteColor];
    }
    return _subTitleLabel;
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
