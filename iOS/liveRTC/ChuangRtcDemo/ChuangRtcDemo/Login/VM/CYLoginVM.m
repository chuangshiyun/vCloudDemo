//
//  CYLoginVM.m
//  ChuangRtcDemo
//

#import "CYLoginVM.h"
#import "CYLoginInputView.h"
#import "CYChooseRolesViewController.h"
#import "UIView+CY.h"
#import "CYPreSetViewController.h"

@interface CYLoginVM ()<UITextFieldDelegate>
///背景图
@property (nonatomic, strong) UIImageView *bgImageView;
///logo图
@property (nonatomic, strong) UIImageView *logoImageView;
///标题
@property (nonatomic, strong) UILabel *titleLabel;
///设置
@property (nonatomic, strong) UIButton *setBtn;
///姓名
@property (nonatomic, strong) CYLoginInputView *nameInputView;
///房间号
@property (nonatomic, strong) CYLoginInputView *roomInputView;
///进入直播
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *userId;


@end

@implementation CYLoginVM

#pragma mark -- lazy

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
        [_mainView addSubview:self.bgImageView];
        [_mainView addSubview:self.setBtn];
        [_mainView addSubview:self.logoImageView];
        [_mainView addSubview:self.titleLabel];
        [_mainView addSubview:self.roomInputView];
        [_mainView addSubview:self.nameInputView];
        [_mainView addSubview:self.loginBtn];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *roomId = [userDefault stringForKey:@"roomId"];
        NSString *userId = [userDefault stringForKey:@"userId"];
        
        if (roomId) {
            self.roomId = roomId;
            self.roomInputView.textField.text = roomId;
        }
        if (userId) {
            self.userId = userId;
            self.nameInputView.textField.text = userId;
        }
//        if (roomId && userId) {
//            self.loginBtn.enabled = YES;
//        }
//        else {
//            self.loginBtn.enabled = NO;
//        }
    }
    return _mainView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"bg"];
    }
    return _bgImageView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageNamed:@"logo_icon"];
    }
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColorFromHex(0x0B0B0B);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"vCloud";
    }
    return _titleLabel;
}

- (UIButton *)setBtn {
    if (!_setBtn) {
        _setBtn = [[UIButton alloc] init];
        [_setBtn setImage:[UIImage imageNamed:@"login_set"] forState:UIControlStateNormal];
        [_setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setBtn;
}

- (CYLoginInputView *)nameInputView {
    if (!_nameInputView) {
        _nameInputView = [[CYLoginInputView alloc] init];
        _nameInputView.placeholder = @"请输入用户名";
        _nameInputView.textField.delegate = self;
        [_nameInputView.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameInputView;
}

- (CYLoginInputView *)roomInputView {
    if (!_roomInputView) {
        _roomInputView = [[CYLoginInputView alloc] init];
        _roomInputView.placeholder = @"请输入房间号";
        _roomInputView.textField.delegate = self;
        [_roomInputView.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _roomInputView;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"进入直播" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = K_REGULAR_FONT(15);
        _loginBtn.backgroundColor = UIColorFromHex(0x006FFF);
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

#pragma mark -- layout
- (void)layoutSubViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainView);
    }];
    
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.mas_top).offset(K_STATUS_BAR_HEIGHT);
        make.right.equalTo(self.mainView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(49);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView.mas_top).offset(K_STATUS_BAR_HEIGHT + K_Height(95));
        make.centerX.equalTo(self.mainView);
        make.width.height.mas_equalTo(65);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView.mas_bottom).offset(6);
        make.centerX.equalTo(self.mainView);
    }];
    
    
    [self.roomInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(K_Height(85));
        make.left.equalTo(self.mainView.mas_left).offset(95);
        make.width.mas_equalTo(SCREEN_WIDTH - 190);
        make.height.mas_equalTo(30);
    }];
    
    [self.nameInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.roomInputView.mas_bottom).offset(45);
        make.left.equalTo(self.mainView.mas_left).offset(95);
        make.width.mas_equalTo(SCREEN_WIDTH - 190);
        make.height.mas_equalTo(30);
    }];

    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameInputView.mas_bottom).offset(K_Height(45));
        make.left.equalTo(self.roomInputView.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH - 190);
        make.height.mas_equalTo(42);
    }];
}

#pragma makr UITextFieldDelegate

- (void)textFieldChanged:(UITextField *)textField {
    CGFloat maxLength = 8;
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    
    
    if (textField == self.roomInputView.textField) {
        self.roomId = textField.text;
    }
    else if (textField == self.nameInputView.textField) {
        self.userId = textField.text;
    }
    
//    if (self.roomId && self.roomId.length > 0 && self.userId && self.userId.length > 0) {
//        self.loginBtn.enabled = YES;
//    }
//    else {
//        self.loginBtn.enabled = NO;
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.roomInputView.textField) {
        self.roomId = textField.text;
    }
    else if (textField == self.nameInputView.textField) {
        self.userId = textField.text;
    }
}

#pragma mark -- action

- (void)setBtnClick:(UIButton *)sender {
    CYPreSetViewController *setVc = [[CYPreSetViewController alloc] init];
    [self.VC.navigationController pushViewController:setVc animated:YES];
}

- (void)loginBtnClick {
    [self.nameInputView.textField resignFirstResponder];
    [self.roomInputView.textField resignFirstResponder];
    
    if ((!self.roomInputView.textField.text || self.roomInputView.textField.text.length == 0) && (!self.nameInputView.textField.text || self.nameInputView.textField.text.length == 0)) {
        [self.mainView CY_showHudText:@"房间号用户名不能为空" duration:2.0];
        return;
    }
    else if (!self.roomInputView.textField.text || self.roomInputView.textField.text.length == 0) {
        [self.mainView CY_showHudText:@"房间号不能为空" duration:2.0];
        return;
    }
    else if (!self.nameInputView.textField.text || self.nameInputView.textField.text.length == 0) {
        [self.mainView CY_showHudText:@"用户名不能为空" duration:2.0];
        return;
    }
    else if (self.roomInputView.textField.text.length < 2) {
        [self.mainView CY_showHudText:@"房间号不少于两位" duration:2.0];
        return;
    }
    else if (self.nameInputView.textField.text.length < 2) {
        [self.mainView CY_showHudText:@"用户名不少于两位" duration:2.0];
        return;
    }
    else if ([self judgeIllegalOfCharacter:self.roomInputView.textField.text] || [self judgeIllegalOfCharacter:self.nameInputView.textField.text]) {
        [self.mainView CY_showHudText:@"房间号用户名只支持数字、字母、下划线和-" duration:2.0];
        return;
    }
    
    CYChooseRolesViewController *controller = [[CYChooseRolesViewController alloc] init];
    controller.userId = self.nameInputView.textField.text;
    controller.roomId = self.roomInputView.textField.text;
    [self.VC.navigationController pushViewController:controller animated:YES];
}

- (BOOL)judgeIllegalOfCharacter:(NSString *)string {
   NSString *str =@"^[A-Za-z0-9-_]+$";
   NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
   if (![emailTest evaluateWithObject:string]) {
   return YES;
   }
   return NO;
}

@end
