//
//  CYSetTextInfoTableViewCell.m
//  LiveVieoDemo
//
//  Created by zyh on 2019/12/5.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYSetTextInfoTableViewCell.h"
#import "Masonry.h"
#import "Define.h"



@interface CYSetTextInfoTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleName;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CYSetTextInfoTableViewCell

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
    _titleName.font = [UIFont systemFontOfSize:15];
    _titleName.textColor = [UIColor blackColor];
    _titleName.text = _infoDic[@"title"]?:@"";
    _titleName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titleName];
    
    
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.placeholder = _infoDic[@"subTitle"]?:@"";
    _textField.textColor = UIColorFromHex(0x989898);
    _textField.delegate = self;
    _textField.text = _infoDic[@"content"]?:@"";
    _textField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_textField];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = UIColorFromHex(0x999999);
    [self.contentView addSubview:_lineView];
    
    [self.titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(15);
//        make.height.mas_equalTo(20);
        make.width.mas_equalTo(110);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.titleName.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-20);
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
    _textField.text = _infoDic[@"content"]?:@"";
    _textField.placeholder = _infoDic[@"subTitle"]?:@"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *content = textField.text;
    NSString *key = _infoDic[@"key"]?:@"";
    BLOCK_EXEC(self.changeTextBlock, content, key);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
