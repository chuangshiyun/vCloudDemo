//
//  CYDefaultSetTableViewCell.m
//  LiveVieoDemo
//
//  Created by zyh on 2019/11/19.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYDefaultSetTableViewCell.h"
#import "Masonry.h"
#import "Define.h"

@interface CYDefaultSetTableViewCell ()
@property (nonatomic, strong) UILabel *titleName;
//@property (nonatomic, strong) UILabel *subTitleName;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UIView *lineView;


@end

@implementation CYDefaultSetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _titleName = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleName.backgroundColor = [UIColor clearColor];
    _titleName.font = [UIFont systemFontOfSize:14];
    _titleName.textColor = [UIColor blackColor];
    _titleName.text = _infoDic[@"title"]?:@"";
    _titleName.textColor = UIColorFromHex(0x1b1b1b);
    _titleName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleName];
    
    _content = [[UILabel alloc] initWithFrame:CGRectZero];
    _content.backgroundColor = [UIColor clearColor];
    _content.font = [UIFont systemFontOfSize:13];
    _content.textColor = UIColorFromHex(0x989898);
    _content.text = _infoDic[@"content"]?:@"";
    _content.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_content];
    
    _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    _arrow.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_arrow];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = UIColorFromHex(0x999999);
    [self.contentView addSubview:_lineView];
    
    [self.titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.titleName.mas_right).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(18);
        make.bottom.equalTo(self.contentView).offset(-18);
        make.left.equalTo(self.content.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    _lineView.hidden = YES;
}

- (void)setInfoDic:(NSMutableDictionary *)infoDic{
    _infoDic = infoDic;
    _titleName.text = _infoDic[@"title"]?:@"";
   // _subTitleName.text = _infoDic[@"subTitle"]?:@"";
    _content.text = _infoDic[@"content"]?:@"";
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
