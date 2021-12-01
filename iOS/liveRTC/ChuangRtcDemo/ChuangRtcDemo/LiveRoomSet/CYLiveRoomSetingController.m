//
//  CYLiveRoomSetingController.m
//  ChuangRtcDemo
//


#import "CYLiveRoomSetingController.h"
#import "CYLiveRoomSettingCell.h"
#import "CYCellManager.h"
#import "CYLiveRoomSetTextCell.h"
#import "UIView+CY.h"
#import "CYLiveRoomSettingFootView.h"
#import "CYPublishTopicConfigManager.h"

@interface CYLiveRoomSetingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *sendMessage;
@property (nonatomic, strong) UIImage *screenShot;
@property (nonatomic, strong) CYLiveRoomSettingFootView *footView;
@property (nonatomic, assign) NSInteger messageIndex; ///记录发送消息位置

@end

@implementation CYLiveRoomSetingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"常用功能设置";
    [self initData];
    [self loadTableView];
}

- (void)initData {
    self.dataSource = [[NSMutableArray alloc] init];
    NSArray *titleArray;
    if (self.role == ChuangUserRoleAnchor) {
        //主播和互动
        if (self.roomStatusConfig.cameraType == ChuangCameraTypeFront) {
            //前置摄像头 有镜像
            titleArray = @[@"显示统计数据",@"打开镜像",@"开启测速",@"音量监测",@"日志开关",@"开启混音",@"等比例裁剪",@"等比例缩放",@"拉伸",@""];
            self.messageIndex = 9;
        }
        else {
            titleArray = @[@"显示统计数据",@"开启测速",@"音量监测",@"日志开关",@"开启混音",@"等比例裁剪",@"等比例缩放",@"拉伸",@""];
            self.messageIndex = 8;
        }
        
    }
    else if (self.role == ChuangUserRoleInteraction) {
        if (self.roomStatusConfig.cameraType == ChuangCameraTypeFront) {
            NSString *mixRtmpAddress = [[CYPublishTopicConfigManager sharedInstance] mixRtmpAddress];
            if (mixRtmpAddress && mixRtmpAddress.length > 0) {
                titleArray = @[@"显示统计数据",@"打开镜像",@"开启测速",@"音量监测",@"日志开关",@"开启混音",@"开启混流",@"等比例裁剪",@"等比例缩放",@"拉伸",@""];
                self.messageIndex = 10;
            }
            else {
                titleArray = @[@"显示统计数据",@"打开镜像",@"开启测速",@"音量监测",@"日志开关",@"开启混音",@"等比例裁剪",@"等比例缩放",@"拉伸",@""];
                self.messageIndex = 9;
            }
            
        }
        else {
            NSString *mixRtmpAddress = [[CYPublishTopicConfigManager sharedInstance] mixRtmpAddress];
            if (mixRtmpAddress && mixRtmpAddress.length > 0) {
                titleArray = @[@"显示统计数据",@"开启测速",@"音量监测",@"日志开关",@"开启混音",@"开启混流",@"等比例裁剪",@"等比例缩放",@"拉伸",@""];
                self.messageIndex = 9;
            }
            else {
                titleArray = @[@"显示统计数据",@"开启测速",@"音量监测",@"日志开关",@"开启混音",@"等比例裁剪",@"等比例缩放",@"拉伸",@""];
                self.messageIndex = 8;
            }
            
        }
        
    }
    else {
        //观众
        titleArray = @[@"显示统计数据",@"开启测速",@"音量监测",@"日志开关"];
        self.messageIndex = 0;
    }
    
    for (int i = 0; i < titleArray.count; i ++) {
        if (self.role == ChuangUserRoleAudience) {
            //观众
            CYCellManager *manager = [[CYCellManager alloc] initWithIdentifier:@"CYLiveRoomSettingCell" data:titleArray[i] type:titleArray[i]];
            [self.dataSource addObject:manager];
        }
        else {
            if (i == titleArray.count - 1) {
                if (self.roomStatusConfig.publishState == ChuangPublishStateConnected) {
                    CYCellManager *manager = [[CYCellManager alloc] initWithIdentifier:@"CYLiveRoomSetTextCell" data:titleArray[i] type:titleArray[i]];
                    [self.dataSource addObject:manager];
                }
                
            }
            else {
                CYCellManager *manager = [[CYCellManager alloc] initWithIdentifier:@"CYLiveRoomSettingCell" data:titleArray[i] type:titleArray[i]];
                [self.dataSource addObject:manager];
            }
        }
        
    }
}

- (void)loadTableView {
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    if (self.role != ChuangUserRoleAudience) {
        if (self.roomStatusConfig.publishState == ChuangPublishStateConnected) {
            self.tableView.tableFooterView = self.footView;
        }
    }
    
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
    if ([manager.cellIdentifier isEqualToString:@"CYLiveRoomSetTextCell"]) {
        CYLiveRoomSetTextCell *cell = [tableView dequeueReusableCellWithIdentifier:manager.cellIdentifier];
        if (!cell) {
            cell = [[CYLiveRoomSetTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:manager.cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    else {
        CYLiveRoomSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:manager.cellIdentifier];
        if (!cell) {
            cell = [[CYLiveRoomSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:manager.cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        __weak typeof(self) weakSelf = self;
        cell.titleLabel.text = manager.data;
        if ([manager.type isEqualToString:@"显示统计数据"]) {
            cell.rigthSwitch.on = self.roomStatusConfig.isShowVideoLog;
            cell.openCallBlock = ^(BOOL isOpen) {
                if ([weakSelf.delegate respondsToSelector:@selector(updateVideoDataState:)]) {
                    [weakSelf.delegate updateVideoDataState:isOpen];
                }
            };
        }
        else if ([manager.type isEqualToString:@"打开镜像"]) {
            cell.rigthSwitch.on = self.roomStatusConfig.isOpenMirror;
            cell.openCallBlock = ^(BOOL isOpen) {
                if ([weakSelf.delegate respondsToSelector:@selector(updateVideoMirrorState:)]) {
                    [weakSelf.delegate updateVideoMirrorState:isOpen];
                }
            };
        }
        else if ([manager.type isEqualToString:@"开启测速"]) {
            cell.rigthSwitch.on = self.roomStatusConfig.isOpenSpeedTest;
            cell.openCallBlock = ^(BOOL isOpen) {
                if ([weakSelf.delegate respondsToSelector:@selector(updateSpeedTestState:)]) {
                    [weakSelf.delegate updateSpeedTestState:isOpen];
                }
            };
        }
        else if ([manager.type isEqualToString:@"音量监测"]) {
            cell.rigthSwitch.on = self.roomStatusConfig.isOpenSoundLevel;
            cell.openCallBlock = ^(BOOL isOpen) {
                if ([weakSelf.delegate respondsToSelector:@selector(updateSoundLevelState:)]) {
                    [weakSelf.delegate updateSoundLevelState:isOpen];
                }
            };
        }
        else if ([manager.type isEqualToString:@"日志开关"]) {
            cell.rigthSwitch.on = self.roomStatusConfig.isOpenLog;
            cell.openCallBlock = ^(BOOL isOpen) {
                if ([weakSelf.delegate respondsToSelector:@selector(updateLogState:)]) {
                    [weakSelf.delegate updateLogState:isOpen];
                }
            };
        }
        else if ([manager.type isEqualToString:@"开启混音"]) {
            cell.rigthSwitch.on = self.roomStatusConfig.isOpenMixAudio;
            cell.openCallBlock = ^(BOOL isOpen) {
                if ([weakSelf.delegate respondsToSelector:@selector(updateMixAudioState:)]) {
                    [weakSelf.delegate updateMixAudioState:isOpen];
                }
            };
        }
        else if ([manager.type isEqualToString:@"开启混流"]) {
            cell.rigthSwitch.on = self.roomStatusConfig.isMixStream;
            NSString *mixRtmpAddress = [[CYPublishTopicConfigManager sharedInstance] mixRtmpAddress];
            if (!mixRtmpAddress || mixRtmpAddress.length == 0) {
                cell.rigthSwitch.on = NO;
                cell.rigthSwitch.enabled = NO;
                self.roomStatusConfig.isMixStream = NO;
            }
            cell.openCallBlock = ^(BOOL isOpen) {
                if ([weakSelf.delegate respondsToSelector:@selector(updateMixStreamState:)]) {
                    [weakSelf.delegate updateMixStreamState:isOpen];
                }
            };
        }
        else if ([manager.type isEqualToString:@"等比例裁剪"]) {
            cell.rigthSwitch.hidden = YES;
            if (self.roomStatusConfig.renderMode == ChuangVideoRenderModePerfectFill) {
                cell.titleLabel.textColor = UIColorFromHex(0x0061ff);
            }
            else {
                cell.titleLabel.textColor = UIColorFromHex(0x010101);
            }
        }
        else if ([manager.type isEqualToString:@"等比例缩放"]) {
            cell.rigthSwitch.hidden = YES;
            if (self.roomStatusConfig.renderMode == ChuangVideoRenderModePerfectFit) {
                cell.titleLabel.textColor = UIColorFromHex(0x0061ff);
            }
            else {
                cell.titleLabel.textColor = UIColorFromHex(0x010101);
            }
        }
        else if ([manager.type isEqualToString:@"拉伸"]) {
            cell.rigthSwitch.hidden = YES;
            if (self.roomStatusConfig.renderMode == ChuangVideoRenderModeScaleFill) {
                cell.titleLabel.textColor = UIColorFromHex(0x0061ff);
            }
            else {
                cell.titleLabel.textColor = UIColorFromHex(0x010101);
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CYCellManager *manager = self.dataSource[indexPath.row];
    if ([manager.type isEqualToString:@"等比例裁剪"]) {
        if ([self.delegate respondsToSelector:@selector(renderWithModel:)]) {
            [self.delegate renderWithModel:ChuangVideoRenderModePerfectFill];
            self.roomStatusConfig.renderMode = ChuangVideoRenderModePerfectFill;
        }
        [self.tableView reloadData];
    }
    else if ([manager.type isEqualToString:@"等比例缩放"]) {
        if ([self.delegate respondsToSelector:@selector(renderWithModel:)]) {
            [self.delegate renderWithModel:ChuangVideoRenderModePerfectFit];
            self.roomStatusConfig.renderMode = ChuangVideoRenderModePerfectFit;
        }
        [self.tableView reloadData];
    }
    else if ([manager.type isEqualToString:@"拉伸"]) {
        if ([self.delegate respondsToSelector:@selector(renderWithModel:)]) {
            [self.delegate renderWithModel:ChuangVideoRenderModeScaleFill];
            self.roomStatusConfig.renderMode = ChuangVideoRenderModeScaleFill;
        }
        [self.tableView reloadData];
    }
}

#pragma mark -- UIScrollviewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark -- action

- (void)backBtnClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 发送
- (void)sendBtnClick {
    [self.view endEditing:YES];
    CYLiveRoomSetTextCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageIndex inSection:0]];
    self.sendMessage = cell.textfield.text;
    if (!self.sendMessage || self.sendMessage.length == 0) {
        [self.view CY_showHudText:@"请输入发送内容"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(sendStreamMessage:)]) {
        [self.delegate sendStreamMessage:self.sendMessage];
        cell.textfield.text = @"";
        self.sendMessage = @"";
        [self.view CY_showHudText:@"已发送"];
    }
}

#pragma mark - 推流截图
-(void)screenShotBtnClick:(UIButton *)sender{
    [self.liveEngine takePublishStreamSnapshot:^(NSString * _Nullable streamId, int errorCode, UIImage * _Nullable image) {
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.screenShot = image;
                self.footView.screenShotImageView.image = image;
            });
        }
    }];
}

#pragma mark -- lazy

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

- (CYLiveRoomSettingFootView *)footView {
    if (!_footView) {
        _footView = [[CYLiveRoomSettingFootView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190)];
        [_footView.screenShotBtn addTarget:self action:@selector(screenShotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
