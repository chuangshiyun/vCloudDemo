//
//  CYInteractionSetView.m
//  ChuangRtcDemo
//


#import "CYInteractionSetView.h"
#import "CYCellManager.h"
#import "CYLiveRoomSettingCell.h"

@interface CYInteractionSetView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIImage *screenShotImage;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIImageView *screenShotImageView;

@end

@implementation CYInteractionSetView

- (instancetype)init {
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        tap.delegate = self;
        self.userInteractionEnabled = YES;
        [self initData];
    }
    return self;
}

- (void)initData {
    self.dataSource = [[NSMutableArray alloc] init];
    NSArray *titleArray = @[@"麦克风开关",@"摄像头开关",@"等比例裁剪",@"等比例缩放",@"拉伸",@"截图"];
    for (int i = 0; i < titleArray.count; i ++) {
        CYCellManager *manager = [[CYCellManager alloc] initWithIdentifier:@"CYLiveRoomSettingCell" data:titleArray[i] type:titleArray[i]];
        [self.dataSource addObject:manager];
    }
}

- (void)setInteractionConfig:(CYInteractionStatusConfig *)interactionConfig {
    _interactionConfig = interactionConfig;
    [self.tableView reloadData];
}

- (void)loadTableView {
    [self.alertView addSubview:self.tableView];
    self.tableView.frame = self.alertView.bounds;
}

#pragma mark -- UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYCellManager *manager = self.dataSource[indexPath.row];
    CYLiveRoomSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:manager.cellIdentifier];
    if (!cell) {
        cell = [[CYLiveRoomSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:manager.cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    __weak typeof(self) weakSelf = self;
    cell.titleLabel.text = manager.data;
    if ([manager.type isEqualToString:@"麦克风开关"]) {
        cell.rigthSwitch.hidden = NO;
        if (self.interactionConfig.muteAudioStatus == AudioStatus_Normal) {
            cell.rigthSwitch.on = YES;
            cell.rigthSwitch.enabled = YES;
        }
        else if (self.interactionConfig.muteAudioStatus == AudioStatus_LocalClosed) {
            cell.rigthSwitch.on = NO;
            cell.rigthSwitch.enabled = YES;
        }
        else if (self.interactionConfig.muteAudioStatus == AudioStatus_RemoteClosed) {
            cell.rigthSwitch.on = NO;
            cell.rigthSwitch.enabled = NO;
        }
        cell.openCallBlock = ^(BOOL isOpen) {
            if ([weakSelf.delegate respondsToSelector:@selector(muteAudioWithStreamId:isMute:)]) {
                [weakSelf.delegate muteAudioWithStreamId:self.interactionConfig.streamId isMute:isOpen];
                if (isOpen) {
                    weakSelf.interactionConfig.muteAudioStatus = AudioStatus_Normal;
                }
                else {
                    weakSelf.interactionConfig.muteAudioStatus = AudioStatus_LocalClosed;
                }
            }
        };
    }
    else if ([manager.type isEqualToString:@"摄像头开关"]) {
        cell.rigthSwitch.hidden = NO;
        if (self.interactionConfig.muteVideoStatus == VideoStatus_Normal) {
            cell.rigthSwitch.on = YES;
            cell.rigthSwitch.enabled = YES;
        }
        else if (self.interactionConfig.muteVideoStatus == VideoStatus_LocalClosed) {
            cell.rigthSwitch.on = NO;
            cell.rigthSwitch.enabled = YES;
        }
        else if (self.interactionConfig.muteVideoStatus == VideoStatus_RemoteClosed) {
            cell.rigthSwitch.on = NO;
            cell.rigthSwitch.enabled = NO;
        }
        cell.openCallBlock = ^(BOOL isOpen) {
            if ([weakSelf.delegate respondsToSelector:@selector(muteVideoWithStreamId:isMute:isLocal:)]) {
                [weakSelf.delegate muteVideoWithStreamId:self.interactionConfig.streamId isMute:!isOpen isLocal:YES];
                if (isOpen) {
                    weakSelf.interactionConfig.muteVideoStatus = VideoStatus_Normal;
                }
                else {
                    weakSelf.interactionConfig.muteVideoStatus = VideoStatus_LocalClosed;
                }
            }
        };
    }
    else if ([manager.type isEqualToString:@"等比例裁剪"]) {
        cell.rigthSwitch.hidden = YES;
        if (self.interactionConfig.renderMode == ChuangVideoRenderModePerfectFill) {
            cell.titleLabel.textColor = UIColorFromHex(0x0061ff);
        }
        else {
            cell.titleLabel.textColor = UIColorFromHex(0x010101);
        }
    }
    else if ([manager.type isEqualToString:@"等比例缩放"]) {
        cell.rigthSwitch.hidden = YES;
        if (self.interactionConfig.renderMode == ChuangVideoRenderModePerfectFit) {
            cell.titleLabel.textColor = UIColorFromHex(0x0061ff);
        }
        else {
            cell.titleLabel.textColor = UIColorFromHex(0x010101);
        }
    }
    else if ([manager.type isEqualToString:@"拉伸"]) {
        cell.rigthSwitch.hidden = YES;
        if (self.interactionConfig.renderMode == ChuangVideoRenderModeScaleFill) {
            cell.titleLabel.textColor = UIColorFromHex(0x0061ff);
        }
        else {
            cell.titleLabel.textColor = UIColorFromHex(0x010101);
        }
    }
    else if ([manager.type isEqualToString:@"截图"]) {
        cell.rigthSwitch.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CYCellManager *manager = self.dataSource[indexPath.row];
    if ([manager.type isEqualToString:@"等比例裁剪"]) {
        if ([self.delegate respondsToSelector:@selector(renderModelWithStreamId:model:)]) {
            self.interactionConfig.renderMode = ChuangVideoRenderModePerfectFill;
            [self.delegate renderModelWithStreamId:self.interactionConfig.streamId model:ChuangVideoRenderModePerfectFill];
        }
        [self.tableView reloadData];
        [self dismiss];
    }
    else if ([manager.type isEqualToString:@"等比例缩放"]) {
        if ([self.delegate respondsToSelector:@selector(renderModelWithStreamId:model:)]) {
            self.interactionConfig.renderMode = ChuangVideoRenderModePerfectFit;
            [self.delegate renderModelWithStreamId:self.interactionConfig.streamId model:ChuangVideoRenderModePerfectFit];
        }
        [self.tableView reloadData];
        [self dismiss];
    }
    else if ([manager.type isEqualToString:@"拉伸"]) {
        if ([self.delegate respondsToSelector:@selector(renderModelWithStreamId:model:)]) {
            self.interactionConfig.renderMode = ChuangVideoRenderModeScaleFill;
            [self.delegate renderModelWithStreamId:self.interactionConfig.streamId model:ChuangVideoRenderModeScaleFill];
        }
        [self.tableView reloadData];
        [self dismiss];
    }
    else if ([manager.type isEqualToString:@"截图"]) {
        [self screenShot];
    }
}

#pragma mark - 截图
- (void)screenShot {
    if (!self.interactionConfig.streamId) {
        NSLog(@"无效流ID，或流已不存在");
        return;
    }
    self.screenShotImage = nil;
    self.screenShotImageView.image = nil;//清空之前的截图

    [self.footView addSubview:self.screenShotImageView];
    [self.screenShotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.footView.mas_left).offset(15);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(160);
    }];
    
    self.tableView.tableFooterView = self.footView;
    [self.liveEngine takePlayStreamSnapshot:self.interactionConfig.streamId imgCallBack:^(NSString * _Nullable streamId, int errorCode, UIImage * _Nullable image) {
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.screenShotImage = image;
                self.screenShotImageView.image = image;
            });
        }else{
//            NSLog(@"截图为空");
        }
    }];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
    [self addSubview:self.alertView];
    [self loadTableView];
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    }];
    
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.alertView removeFromSuperview];
        self->_alertView = nil;
        [self.tableView removeFromSuperview];
        self->_tableView = nil;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}

#pragma mark -- Lazy

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = SMViewBGColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    }
    return _tableView;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
        _footView.backgroundColor = [UIColor whiteColor];
    }
    return _footView;
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
