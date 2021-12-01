//
//  RtcViewController.m
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/17.
//

#import "CYRtcViewController.h"
#import "PlayContentView.h"
#import "PlayModel.h"
#import "BottomBar.h"
#import "LogView.h"
#import "CYPublishTopicConfigManager.h"
#import "CYVideoRenderModeSelectView.h"
#import "UIView+CY.h"
#import "CYKeyCenter.h"
#import "CYLiveRoomSetingController.h"
#import "CYBaseNaviViewController.h"
#import "CYLiveRoomStatusConfig.h"
#import "CYInteractionSetView.h"
#import "CYInteractionStatusConfig.h"
#import "CYEmptyView.h"
#import "CYNetworkStatus.h"

#define kAudioReadCount  2048

typedef NS_ENUM(NSInteger,ChuangMixState) {
    ChuangMixState_Uninit = 0,   ///混流未发启
    ChuangMixState_Connecting,  ///混流发起中
    ChuangMixState_Connected,   ///混流成功
    ChuangMixState_DisConnected,///混流失败
};


@interface CYRtcViewController ()<ChuangLiveEngineDelegate, PlayContentViewDataSource, PlayContentViewDelegate, ChuangVideoCustomCaptureDelegate, ChuangVideoCustomRenderDelegate, PlaySubViewDelegate,ChuangAudioMixingDelegate,CYLiveRoomSetingControllerDelegate,CYInteractionSetViewDelegate>

@property (nonatomic, weak) ChuangLiveEngine *liveEngine;
/// 本地预览视图
@property (nonatomic, strong) PlaySubView *localView;
/// 大小视图切换，大视图标记
@property (nonatomic, weak) PlaySubView *bigView;
/// 大视图坐标
@property (nonatomic, assign) CGRect bigFrame;

@property (nonatomic, strong) NSMutableArray<PlayModel *> *playStreamInfoArray;
@property (nonatomic, weak) LogView *logView;
@property (nonatomic, weak) PlayContentView *playContentView;
@property (nonatomic, weak) BottomBar *bottomBar;
/// 推流音量展示
@property (nonatomic, weak) UILabel *soundLevelLabel;
/// 混音
@property (nonatomic, strong) NSMutableData *mixAudioData;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImageView *snapShowView;

///推流窗口设置配置
@property (nonatomic, strong) CYLiveRoomStatusConfig *roomStatusConfig;
///互动窗口设置
@property (nonatomic, strong) CYInteractionSetView *interactionView;
///用于维护互动窗口设置，保存设置信息
@property (nonatomic, strong) NSMutableDictionary *interactionSetInfo;
///推流播流预览设置
@property (nonatomic, strong) NSMutableDictionary *canvasInfo;
///推流状态
@property (nonatomic, assign) ChuangPublishState publishState;
///混流状态
@property (nonatomic, assign) ChuangMixState  mixState;

///会议未开始占位图
@property (nonatomic, strong) CYEmptyView *emptyView;
///观众角色，第一个播流视图
@property (nonatomic, strong) PlaySubView *audiencePlayView;
///推流音量
@property (nonatomic, assign) int publishVolume;
///网络速度
@property (nonatomic, assign) int availableBndWidthKbps;


@end

@implementation CYRtcViewController
#pragma mark - lazy
- (NSMutableArray<PlayModel *> *)playStreamInfoArray {
    if (!_playStreamInfoArray) {
        _playStreamInfoArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _playStreamInfoArray;
}
#pragma mark - 退出此页面
/// 退出页面
- (void)exitRtcVc {
    [self.liveEngine logoutRoom];
    [ChuangLiveEngine uninitEngine];
}

#pragma mark - 初始化相关方法
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    // 初始化UI
    [self setupUI];
    
    // 初始化RTC
    [self setupRtc];
    
    // 登录房间
    [self loginRoom];
    
    //监听网络状态
    [self showNetworkStatus];
    
}

/// 初始化UI
- (void)setupUI {
    //初始化视频统计开关
    self.roomStatusConfig = [[CYLiveRoomStatusConfig alloc] init];
    CYPublishTopicConfigManager *manager = [CYPublishTopicConfigManager sharedInstance];
    NSInteger showDataState = [manager showDataState];
    if (showDataState > 0) {
        self.roomStatusConfig.isShowVideoLog = YES;
    }else{
        self.roomStatusConfig.isShowVideoLog = NO;
    }
    self.roomStatusConfig.isMixStream = [manager mixRtmpEanble];
    self.canvasInfo = [[NSMutableDictionary alloc] init];
    self.view.backgroundColor = self.role == ChuangUserRoleAudience? [UIColor whiteColor]:[UIColor blackColor];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        appearance.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    } else {
        // Fallback on earlier versions
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"n_set"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 48, 44);
    [backButton setImage:[[UIImage imageNamed:@"login_return"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    CGSize viewSize = self.view.bounds.size;
    CGFloat navigationBarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    // 初始化本地预览视图
    self.bigFrame = CGRectMake(0, navigationBarH, viewSize.width, viewSize.height-navigationBarH);
    self.localView = [[PlaySubView alloc] initWithFrame:self.bigFrame];
    self.localView.isLocal = YES;
    self.localView.nameLabel.text = self.userId;
    self.localView.modeView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    self.localView.modeView.renderModeDidSelectBlock = ^(NSUInteger index) {
        ChuangVideoCanvas *canvas = [[ChuangVideoCanvas alloc] init];
        canvas.view = weakSelf.localView.renderView;
        canvas.renderMode = index;
        [weakSelf.liveEngine setPreview:canvas];//更新本地预览填充模式
    };
    self.localView.delegate = self;
    self.localView.showBig = YES;
    self.bigView = self.localView;
    [self.view addSubview:self.localView];
    
    if (self.role == ChuangUserRoleAudience) {
        //观众
        [_localView removeFromSuperview];
        _localView = nil;
        [self.view addSubview:self.audiencePlayView];
    }
    
    [self showEmptyView];

    LogView *logView = [[LogView alloc] initWithFrame:CGRectMake(0, navigationBarH + 30, self.view.bounds.size.width, self.view.bounds.size.height/3)];
    [self.view addSubview:logView];
    self.logView = logView;
    
    if (self.role == ChuangUserRoleAudience || self.role == ChuangUserRoleInteraction) { // 观众，互动模式下需要初始化播流控件
        CGFloat smallWidth = (SCREEN_WIDTH - 40) / 4;
        CGFloat height = smallWidth/2*3;//self.view.bounds.size.height/5;
        CGFloat y = self.view.bounds.size.height - height - 34 - 50 - 8;
        CGFloat width = self.view.bounds.size.width;
        PlayContentView *playContentView = [[PlayContentView alloc] initWithFrame:CGRectMake(0, y, width, height)];
        playContentView.dataSource = self;
        playContentView.delegate = self;
        [self.view addSubview:playContentView];
        self.playContentView = playContentView;
        
        ///初始化互动窗口记录
        self.interactionSetInfo = [[NSMutableDictionary alloc] init];
        
    }
    
    if (self.role == ChuangUserRoleAnchor || self.role == ChuangUserRoleInteraction) { // 主播、互动模式下
        
        self.localView.modeView.hidden = NO; // 显示本地预览视图模式选择控件
        
        UILabel *soundLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, navigationBarH, viewSize.width, 30)];
        soundLevelLabel.textColor = [UIColor systemBlueColor];
        [self.view addSubview:soundLevelLabel];
        self.soundLevelLabel = soundLevelLabel;
        
        CGFloat height = 50;
        CGFloat y = self.view.bounds.size.height - height - 34;
        CGFloat left = 20;
        CGFloat width = self.view.bounds.size.width - left * 2;
        BottomBar *bottomBar = [[BottomBar alloc] initWithFrame:CGRectMake(left, y, width, height)];
        [bottomBar.muteVideoButton addTarget:self action:@selector(muteVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBar.muteAudioButton addTarget:self action:@selector(muteAudioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBar.switchCameraButton addTarget:self action:@selector(switchCameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBar.hangupButton addTarget:self action:@selector(hangupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:bottomBar];
        self.bottomBar = bottomBar;
        [self resetBottomBarCamreaStatus];
        bottomBar.interactionCount = 0;
    }
    
    if (self.role == ChuangUserRoleAnchor || self.role == ChuangUserRoleInteraction) { // 主播、互动模式下
        
        self.localView.modeView.hidden = NO; // 显示本地预览视图模式选择控件
        
        UILabel *soundLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, navigationBarH, viewSize.width, 30)];
        soundLevelLabel.textColor = [UIColor systemBlueColor];
        [self.view addSubview:soundLevelLabel];
        self.soundLevelLabel = soundLevelLabel;
        
        CGFloat height = 50;
        CGFloat y = self.view.bounds.size.height - height - 34;
        CGFloat left = 20;
        CGFloat width = self.view.bounds.size.width - left * 2;
        BottomBar *bottomBar = [[BottomBar alloc] initWithFrame:CGRectMake(left, y, width, height)];
        [bottomBar.muteVideoButton addTarget:self action:@selector(muteVideoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBar.muteAudioButton addTarget:self action:@selector(muteAudioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBar.switchCameraButton addTarget:self action:@selector(switchCameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBar.hangupButton addTarget:self action:@selector(hangupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:bottomBar];
        self.bottomBar = bottomBar;
        [self resetBottomBarCamreaStatus];
        bottomBar.interactionCount = 0;
      
    }
    UIImageView *snapTestView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, 100, 90, 160)];
    snapTestView.backgroundColor = [UIColor clearColor];
    snapTestView.hidden = YES;
    [self.logView addSubview:snapTestView];
    self.snapShowView = snapTestView;
    
}

- (void)resetBottomBarCamreaStatus {
    BOOL isAudioOnly = [[CYPublishTopicConfigManager sharedInstance] audioOnlyState];
    if (isAudioOnly) {
        self.bottomBar.muteVideoButton.selected = YES;
        self.bottomBar.muteVideoButton.userInteractionEnabled = NO;
        self.bottomBar.switchCameraButton.enabled = NO;
        self.roomStatusConfig.isOpenLocalAudio = YES;
        self.roomStatusConfig.isOpenLocalCamera = NO;
    }
}


#pragma mark - ChuangAudioMixingDelegate
- (void)onAudioMixingCopyData:(ChuangAudioMxingData *)audioMixData{
 
    //NSLog(@"灌入混音数据回调");
    [self readPcmFile:audioMixData.pData maxLength:audioMixData.exceptedDataBytes];
    
}
- (NSInteger)readPcmFile:(Byte *)buffer maxLength:(NSInteger)len {
    
    NSInteger currentReadLength = 0;
    
    if (self.index >= self.mixAudioData.length) {
        self.index = 0;
    }
    
    if (self.index + len < self.mixAudioData.length){
        currentReadLength = len;
    }else{
        currentReadLength = (self.mixAudioData.length - self.index);
    }
    
    NSData *subData = [self.mixAudioData subdataWithRange:NSMakeRange(self.index, currentReadLength)];
    Byte *tempByte = (Byte *)[subData bytes];
    memcpy(buffer,tempByte,currentReadLength);
    self.index += len;

    return currentReadLength;
}

- (ChuangMixStreamConfig *)makeMixStreamConfig:(NSMutableArray <ChuangMixStreamInfo *> *)mixStreams{
    
    ChuangMixStreamWatermark *waterMark = [[ChuangMixStreamWatermark alloc] init];
    waterMark.image = @"preset-id://chuang_icon";// 162*43
    waterMark.rect = CGRectMake(0, 0, 162, 43);
    
    CYPublishTopicConfigManager *ptcm = [CYPublishTopicConfigManager sharedInstance];
    CGSize mixSize = [ptcm mixRtmpResolution];
    ChuangMixStreamConfig *mixConfig = [[ChuangMixStreamConfig alloc] init];
    mixConfig.target = [ptcm mixRtmpAddress];
    mixConfig.videoBitrateKbps = (int)[ptcm mixOutputRtmpBitrateKBps];
    mixConfig.width = mixSize.width;
    mixConfig.height = mixSize.height;
    mixConfig.mixStreams = mixStreams;
    mixConfig.noticeStream = [ptcm mixRtcEnbale];
    mixConfig.backgroundImage = @"preset-id://chuang_01";
    mixConfig.mixStreamWatermark = waterMark;
    
    return mixConfig;
}


/// 初始化RTC
- (void)setupRtc {
    // 设置日志打印级别
    [ChuangLiveEngine setLogLevel:ChuangLogLevelNone];//ChuangLogLevelInfo
    
    self.liveEngine = [ChuangLiveEngine initEngine:[CYKeyCenter appId] andAppKey:[CYKeyCenter appKey] delegate:self];
    
    NSString *roleStr = @"";
    switch (self.role) {
        case ChuangUserRoleAnchor:
            
            roleStr = @"主播";
            [self setupPublishStream];
            
            break;
        case ChuangUserRoleInteraction:
            
            roleStr = @"互动";
            [self setupPublishStream];
            
            break;
        case ChuangUserRoleAudience:
            roleStr = @"观众";
            break;
        default:
            break;
    }
    self.title = [NSString stringWithFormat:@"房间ID: %@ 身份: %@",self.roomId,roleStr];

    BOOL isAudioOnly = [[CYPublishTopicConfigManager sharedInstance] audioOnlyState];
    if (isAudioOnly) {
        self.localView.placcholdImageview.hidden = NO;
    }
    else {
        self.localView.placcholdImageview.hidden = YES;
    }
}

- (void)loginRoom {
    
    // 登录房间
    [self.liveEngine loginRoom:self.roomId userId:self.userId role:self.role];
}

/// 设置推流相关配置
- (void)setupPublishStream {
    
    // 设置视频推流配置
    CYPublishTopicConfigManager *ptcm = [CYPublishTopicConfigManager sharedInstance];
    ChuangVideoConfigPreset preset = [ptcm getConfigPresetFromSize:ptcm.resolution];
    ChuangVideoConfig *config = [ChuangVideoConfig configWithPreset:preset];
    [self.liveEngine setVideoConfig:config];
    
    // 初始化本地视频视图
    ChuangVideoCanvas *canvas = [[ChuangVideoCanvas alloc] init];
    canvas.renderMode = ChuangVideoRenderModePerfectFill;
    canvas.view = self.localView.renderView;
    BOOL isAudioOnly = [[CYPublishTopicConfigManager sharedInstance] audioOnlyState];
    if (!isAudioOnly) {
        [self.liveEngine setPreview:canvas];
        // 开始预览本地视图
        [self.liveEngine startPreview];
    }
    [self.canvasInfo setObject:canvas forKey:self.localStreamId];
}

/// 开始推流
- (void)startPublishStream {
    
    CYPublishTopicConfigManager *manager = [CYPublishTopicConfigManager sharedInstance];
    ChuangStreamConfig *config = [[ChuangStreamConfig alloc] init];
    config.streamId = self.localStreamId;
    BOOL isAudioOnly = [[CYPublishTopicConfigManager sharedInstance] audioOnlyState];
    if (isAudioOnly) {
        config.streamMode = ChuangStreamModeAudioOnly;
        self.localView.placcholdImageview.hidden = NO;
    }
    else {
        config.streamMode = ChuangStreamModeVideo;
        self.localView.placcholdImageview.hidden = YES;
    }
    if ([manager publishRtmpEanble]) {
        config.rtmpAddress = [manager rtmpAddress];
    }
    [self.liveEngine startPublishStream:config];
}
#pragma mark - 混流相关
// 开始混流
- (void)startMixStream {
    if (self.role == ChuangUserRoleAnchor) {
        //主播不发起混流
        return;
    }
    ChuangMixStreamConfig *mixConfig = [self makeMixStreamConfig:[self mixReactStreams]];
    self.mixState = ChuangMixState_Connecting;
    ChuangErrorCode code = [self.liveEngine startMixStream:mixConfig];
    if (code == ChuangErrorCodeMixStreamBeforePublish) {
        [self.view CY_showHudText:@"发起混流失败，未推流成功就发起混流!"];
    }else if(code == ChuangErrorCodeSuccess){
        [self.view CY_showHudText:@"发起混流成功"];
        [self.logView appendProcessTipAndMakeVisible:@"---开始混流---"];
    }
}
/// 混流输入流的布局配置构建
- (NSMutableArray <ChuangMixStreamInfo *>*)mixReactStreams{
    
    NSUInteger maxColumn = 3;
    NSMutableArray *mixStreams = [[NSMutableArray alloc] init];
    //设置当前自己推流的混流配置
    ChuangMixStreamInfo *mainMixItem = [[ChuangMixStreamInfo alloc] init];
    mainMixItem.streamId = self.localStreamId;
    mainMixItem.zlevel = 0;//当前流传0
    mainMixItem.mixVideo = YES;//yes:参与混入视频。no:不参与混入视频，默认YES；注：发起混流者必须参与混流
    CGSize mixOutputSize = [[CYPublishTopicConfigManager sharedInstance] mixRtmpResolution];
    CGFloat width = (mixOutputSize.width>0)? mixOutputSize.width : 432.0;
    CGFloat height = (mixOutputSize.height>0)? mixOutputSize.height : 768.0;
    mainMixItem.dstRect = CGRectMake(width - width/maxColumn,0, width/maxColumn, height/maxColumn);
    if (mainMixItem) {
       [mixStreams addObject:mainMixItem];
    }
    
    
    NSMutableArray *mixArray = [NSMutableArray arrayWithCapacity:self.playStreamInfoArray.count];
    for (PlayModel *model in self.playStreamInfoArray) {
        ChuangStreamInfo *itemInfo = model.streamInfo;
        if (itemInfo.streamType == ChuangStreamTypeRTC) {// 排除混流
            [mixArray addObject:itemInfo];
        }
    }
    
    //设置房间除当前推流以外的其他流的混流配置 （自定义坐标布局）
    CGFloat itemWidth = width/maxColumn;
    CGFloat itemHeight = height/maxColumn;
    
    for (int i = 0; i < mixArray.count; i ++) {
        
        ChuangStreamInfo *itemInfo = mixArray[i];
        ChuangMixStreamInfo *mixItem = [[ChuangMixStreamInfo alloc] init];
        mixItem.width = itemInfo.width;
        mixItem.height = itemInfo.height;
        mixItem.streamId = itemInfo.streamId;
        mixItem.zlevel = i + 1;
        mixItem.mixVideo = YES;//yes:参与混入视频。no:不参与混入视频 ；默认YES
        
        NSUInteger row = i/maxColumn;
        NSInteger col = i % maxColumn;
        CGFloat x = col * itemWidth;
        CGFloat y = height - (row+1) * itemHeight;
        mixItem.dstRect = CGRectMake(x, y, itemWidth,itemHeight);

        [mixStreams addObject:mixItem];
    }
    return mixStreams;
}
/// 停止混流
- (void)stopMixStream {
    self.mixState = ChuangMixState_Uninit;
    [self.liveEngine stopMixStream];
    [self.logView appendProcessTipAndMakeVisible:@"---停止混流---"];
}
#pragma mark - 播流信息处理相关方法
- (PlayModel *)playModelWithStreamId:(NSString *)streamId {
    
    for (PlayModel *model in self.playStreamInfoArray) {
        if ([model.streamInfo.streamId isEqualToString:streamId]) {
            return model;
        }
    }
    return nil;
}

- (NSInteger)playModelIndexWithStreamId:(NSString *)streamId {
    for (int i = 0; i < self.playStreamInfoArray.count; i ++) {
        PlayModel *model = self.playStreamInfoArray[i];
        if ([model.streamInfo.streamId isEqualToString:streamId]) {
            return i;
            break;
        }
    }
    return 0;
}

- (void)addPlayStreamInfo:(ChuangStreamInfo *)info {
    
    PlayModel *model = [self playModelWithStreamId:info.streamId];
    if (model == nil) {
        PlaySubView *playSubViews;
        if (self.role == ChuangUserRoleAudience) {
            //观众
            if (self.playStreamInfoArray.count == 0) {
                if (!_audiencePlayView) {
                    [self.view insertSubview:self.audiencePlayView belowSubview:self.logView];
                }
                self.audiencePlayView.streamInfo = info;
                playSubViews = self.audiencePlayView;
                [self initPlayViews:info subView:playSubViews];
            }
            else {
                PlaySubView *subView = [[PlaySubView alloc] init];
                //subView.hidden = YES;
                subView.streamInfo = info;
                playSubViews = subView;
                [self initPlayViews:info subView:playSubViews];
            }
        }
        else {
            PlaySubView *subView = [[PlaySubView alloc] init];
           // subView.hidden = YES;
            subView.streamInfo = info;
            playSubViews = subView;
            [self initPlayViews:info subView:playSubViews];
        }
        
        
        
    }else{
//        NSLog(@"已经存在了");
    }
    
    [self reloadStreamCount];
   // [self updataBottomBarInteractionCount];
   
}

- (void)initPlayViews:(ChuangStreamInfo *)info subView:(PlaySubView *)subView {
    CYInteractionStatusConfig *config = [[CYInteractionStatusConfig alloc] init];
    config.renderMode = ChuangVideoRenderModePerfectFill;
    config.muteAudioStatus = AudioStatus_Normal;
    __weak typeof(self) weakSelf = self;
    subView.modeView.renderModeDidSelectBlock = ^(NSUInteger index) {
        ChuangVideoCanvas *playCanvas = [[ChuangVideoCanvas alloc] init];
        playCanvas.renderMode = index;
        playCanvas.view = subView.renderView;
        [weakSelf.liveEngine startPlayStream:info.streamId withCanvas:playCanvas];
    };
    PlayModel *playModel = [[PlayModel alloc] init];
    playModel.playView = subView;
    playModel.streamInfo = info;
    
    [self.playStreamInfoArray addObject:playModel];
   
    //开始播流
    ChuangVideoCanvas *playCanvas = [[ChuangVideoCanvas alloc] init];
    playCanvas.view = subView.renderView;
    [self.liveEngine startPlayStream:info.streamId withCanvas:playCanvas];
    if (info.streamMode == ChuangStreamModeAudioOnly) {
        //纯音频模式
        config.muteVideoStatus = VideoStatus_RemoteClosed;
        subView.placcholdImageview.hidden = NO;
    }
    else {
        config.muteVideoStatus = VideoStatus_Normal;
        subView.placcholdImageview.hidden = YES;
    }
    
    config.streamId = info.streamId;
    [self.interactionSetInfo setObject:config forKey:info.streamId];
    
    [self.canvasInfo setObject:playCanvas forKey:info.streamId];
}

- (void)updataBottomBarInteractionCount{
    
    if (self.role == ChuangUserRoleInteraction) {
       
        if (self.publishState == ChuangPublishStateConnected) {
            self.bottomBar.interactionCount = self.playStreamInfoArray.count + 1;
        }else{
            self.bottomBar.interactionCount = self.playStreamInfoArray.count;
        }
        
    }else if(self.role == ChuangUserRoleAnchor){
        if (self.publishState == ChuangPublishStateConnected) {
            self.bottomBar.interactionCount = 1;
        }else{
            self.bottomBar.interactionCount = 0;
        }
        
    }
}

- (void)removePlayStreamInfo:(ChuangStreamInfo *)info {
    PlayModel *model = [self playModelWithStreamId:info.streamId];
    if (model) {
        // 停止播流
        [self.liveEngine stopPlayStream:info.streamId];
        if(model.playView.showBig){
            if (self.role == ChuangUserRoleAudience) {
                if (self.playStreamInfoArray.count > 1) {
                    PlayModel *playModel = [self.playStreamInfoArray objectAtIndex:1];
                    PlaySubView *playView = playModel.playView;
                    if (playView) {
                        [self changPlaySubViewFrame:playView];
                    }
                }
                
            }
            else {
                [self changPlaySubViewFrame:self.localView];
            }
            
        }
        if ([model.playView isEqual:_audiencePlayView]) {
            [_audiencePlayView removeFromSuperview];
            _audiencePlayView = nil;
            [model.playView removeFromSuperview];
        }
        else {
            [model.playView removeFromSuperview];
        }
        
        [self.playStreamInfoArray removeObject:model];
        [self.interactionSetInfo removeObjectForKey:info.streamId];
        [self reloadStreamCount];
    }
}

#pragma mark - 流数量

- (void)reloadStreamCount {
    if (self.publishState == ChuangPublishStateConnected) {
        self.bottomBar.interactionCount = self.playStreamInfoArray.count + 1;
    }
    else {
        self.bottomBar.interactionCount = self.playStreamInfoArray.count;
        
       // [self updataBottomBarInteractionCount];
            
    }
}

#pragma mark - 按钮点击事件
- (void)rightButtonClick {
    CYLiveRoomSetingController *setVc = [[CYLiveRoomSetingController alloc] init];
    setVc.delegate = self;
    setVc.roomStatusConfig = self.roomStatusConfig;
    setVc.liveEngine = self.liveEngine;
    setVc.role = self.role;
    CYBaseNaviViewController *naVc = [[CYBaseNaviViewController alloc] initWithRootViewController:setVc];
    if (K_IS_PAD) {
        naVc.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:naVc animated:YES completion:nil];

    
}
- (void)leftButtonClick {
    
    if (self.navigationController.viewControllers.count >= 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self exitRtcVc];
}
- (void)muteVideoButtonClick:(UIButton *)btn {
    
    BOOL ismute = !btn.isSelected;
    int muteResult = [self.liveEngine muteLocalVideo:self.localStreamId mute:ismute];
    if (muteResult == 0) {
        btn.selected = ismute;
    }
    self.localView.placcholdImageview.hidden = !ismute;
    self.bottomBar.switchCameraButton.enabled = !ismute;
    self.roomStatusConfig.isOpenLocalCamera = !ismute;
    
}

- (void)muteAudioButtonClick:(UIButton *)btn {
    BOOL ismute = !btn.isSelected;
    int muteResult = [self.liveEngine muteLocalAudio:self.localStreamId mute:ismute];
    if (muteResult == 0) {
        btn.selected = ismute;
    }
    self.roomStatusConfig.isOpenLocalAudio = !ismute;
}
- (void)hangupButtonClick:(UIButton *)btn {
 
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        if (self.mixState == ChuangMixState_Connected) {
            [self.liveEngine stopMixStream];
        }
        [self.liveEngine stopPublishStream];
        [self.liveEngine stopPreview];
       
    }else{
        [self.liveEngine startPreview];
        [self startPublishStream];
    }
}
- (void)switchCameraButtonClick:(UIButton *)btn {
    
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        self.roomStatusConfig.cameraType = ChuangCameraTypeBack;
        [self.liveEngine switchCamera:ChuangCameraTypeBack];
        
    }else{
        [self.liveEngine switchCamera:ChuangCameraTypeFront];
        self.roomStatusConfig.cameraType = ChuangCameraTypeFront;
    }
}


- (void)soundLevelButtonClick:(UIButton *)btn {
    btn.selected = !btn.isSelected;
    if (btn.isSelected) {
        [self.liveEngine startSoundLevelMonitor];
    }else{
        [self.liveEngine stopSoundLevelMonitor];
        self.soundLevelLabel.text = @"";
        for (PlayModel *model in self.playStreamInfoArray) {
            model.soundLevel = 0;
        }
        [self.playContentView reloadData];
    }
}

#pragma mark - PlaySubViewDelegate
- (void)playSubView:(PlaySubView *)playSubView muteVideoButtonDidClick:(UIButton *)btn {
    
    BOOL isMute = !btn.isSelected;
    btn.userInteractionEnabled = NO;
    int muteResult = [self.liveEngine muteRemoteVideo:playSubView.streamInfo.streamId mute:isMute];
    if (muteResult == 0) {
        btn.selected = isMute;
    }
    playSubView.placcholdImageview.hidden = !isMute;
    btn.userInteractionEnabled = YES;
}

- (void)playSubView:(PlaySubView *)playSubView muteAudioButtonDidClick:(nonnull UIButton *)btn {
    
    BOOL isMute = !btn.isSelected;
    btn.userInteractionEnabled = NO;
    int muteResult = [self.liveEngine muteRemoteAudio:playSubView.streamInfo.streamId mute:isMute];
    if (muteResult == 0) {
        btn.selected = isMute;
    }
    btn.userInteractionEnabled = YES;
}
- (void)switchSubView:(PlaySubView *)playSubView{
    [self changPlaySubViewFrame:playSubView];
}
- (void)screenShotRemoteImg:(NSString *)streamId{

    [self.liveEngine takePlayStreamSnapshot:streamId imgCallBack:^(NSString * _Nullable streamId, int errorCode, UIImage * _Nullable image) {
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.snapShowView.image = image;
                self.snapShowView.hidden = NO;
            });
        }else{
//            NSLog(@"截图为空");
        }
    }];
    
}

- (void)showInteractionSetViewWithStreamId:(NSString *)streamId {
    CYInteractionStatusConfig *interactionConfig = [self.interactionSetInfo objectForKey:streamId];
    self.interactionView.interactionConfig = interactionConfig;
    self.interactionView.liveEngine = self.liveEngine;
    [self.interactionView show];
}


#pragma mark - 大小视图切换相关
//大小图切换
- (void)changPlaySubViewFrame:(PlaySubView *)playSubView{
    
    if (CGRectEqualToRect(playSubView.frame, self.bigFrame) == NO){
        if (self.role == ChuangUserRoleAudience) {
            //观众 修改数据源
            NSInteger index = [self playModelIndexWithStreamId:playSubView.streamInfo.streamId];
            if (index != 0) {
                [self.playStreamInfoArray exchangeObjectAtIndex:0 withObjectAtIndex:index];
            }
        }
        [self.playContentView removeSubViewFromArray:playSubView];
        
        // 设置上一次大视图的frame为当前视图的frame
        self.bigView.showBig = NO;
        self.bigView.frame = playSubView.frame;
        // 设置当前视图的frame为大视图
        playSubView.frame = self.bigFrame;
        
        // 父控件互换
        [self.playContentView.scrollView addSubview:self.bigView];
        [self.view insertSubview:playSubView atIndex:0];
        
        // 重新记录大视图
        self.bigView = playSubView;
        self.bigView.showBig = YES;
        
        if ([playSubView isEqual:self.localView]) {
            self.playContentView.localView = self.localView;
        }
        
    }
    
}
// 仅在小视图模式下响应
- (void)customCaptureViewTap:(UITapGestureRecognizer *)tap {
    
    //设置上一次大视图的frame为当前视图的frame
    self.bigView.showBig = NO;
    self.bigView.frame = tap.view.frame;
    
    
    // 设置当前视图的frame为大视图
    tap.view.frame = self.bigFrame;
    tap.view.userInteractionEnabled = NO;
    
    // 父控件互换
    [self.playContentView.scrollView addSubview:self.bigView];
    [self.view insertSubview:tap.view atIndex:0];
}

#pragma mark - ChuangLiveEngineDelegate
- (void)onRoomStateUpdate:(NSString *)roomId state:(ChuangRoomState)state errorCode:(int)errorCode {
    
    NSString *stateStr = @"连接中";
    switch (state) {
        case ChuangRoomStateConnecting:
            
            break;
        case ChuangRoomStateConnected:
            stateStr = @"连接成功";
            break;
        case ChuangRoomStateDisconnected:
            stateStr = @"断开连接";
            break;
            
        default:
            break;
    }
    
    NSString *log = [NSString stringWithFormat:@"房间状态变化 roomId: %@ state: %@ %lu errorCode: %d", roomId,stateStr, (unsigned long)state, errorCode];
    
    [self.view CY_showHudText:log duration:2.0];
    
    [self.logView appendProcessTipAndMakeVisible:log];
    
    if (state == ChuangRoomStateConnected && errorCode != ChuangErrorRoomReconnected) {
        if (self.role == ChuangUserRoleAnchor || self.role == ChuangUserRoleInteraction) {
            [self startPublishStream];
        }
    }
 
}

#pragma mark -远端流更新回调
- (void)onRoomStreamUpdate:(NSString *)roomId updateType:(ChuangStreamUpdateType)updateType streamList:(NSArray <ChuangStreamInfo *>*)streamList {
    
    if(updateType == ChuangStreamUpdateTypeAdd){
        NSString *log = [NSString stringWithFormat:@"有流进来"];
        [self.view CY_showHudText:log duration:2.0];
    }else{
        NSString *log = [NSString stringWithFormat:@"有流离开"];
        [self.view CY_showHudText:log duration:2.0];
    }
    
    NSString *log = [NSString stringWithFormat:@"房间流状态变化 roomId: %@ updateType: %lu streamList: %@", roomId, (unsigned long)updateType, streamList];
    [self.logView appendProcessTipAndMakeVisible:log];
    
    if (self.role == ChuangUserRoleAudience || self.role == ChuangUserRoleInteraction) {
        
        if (updateType == ChuangStreamUpdateTypeAdd) {
            
            for (ChuangStreamInfo *object in streamList) {
                [self addPlayStreamInfo:object];
                NSString *log = [NSString stringWithFormat:@"进来流Id:%@",object.streamId];
                [self.logView appendProcessTipAndMakeVisible:log];

            }
            
        }else if(updateType == ChuangStreamUpdateTypeDelete){
            
            for (ChuangStreamInfo *object in streamList) {
                [self removePlayStreamInfo:object];
                NSString *log = [NSString stringWithFormat:@"离开流Id:%@",object.streamId];
                [self.logView appendProcessTipAndMakeVisible:log];

            }
            
        }
        [self.playContentView reloadData];
    }

    if (self.roomStatusConfig.isMixStream  && self.publishState == ChuangPublishStateConnected) {
        ChuangMixStreamConfig *mixConfig = [self makeMixStreamConfig:[self mixReactStreams]];
        [self.liveEngine startMixStream:mixConfig];
    }
    
    if (self.playStreamInfoArray.count == 0) {
        [self showEmptyView];
    }
    else {
        [self dismissEmptyView];
    }
}

- (void)onPublishStreamStateUpdate:(NSString *)streamId state:(ChuangPublishState)state errorCode:(int)code {
    self.publishState = state;
    self.roomStatusConfig.publishState = state;
    NSString *stateStr = @"连接中";
    switch (state) {
        case ChuangPublishStateConnecting:
           // [self reloadStreamCount];
            break;
        case ChuangPublishStateConnected:
            stateStr = @"连接成功";
            //是否混流
            [self updateMixStreamState:self.roomStatusConfig.isMixStream];
            [self reloadStreamCount];
            [self.liveEngine muteLocalAudio:self.localStreamId mute:!self.roomStatusConfig.isOpenLocalAudio];
            [self.liveEngine muteLocalVideo:self.localStreamId mute:!self.roomStatusConfig.isOpenLocalCamera];
            self.localView.placcholdImageview.hidden = self.roomStatusConfig.isOpenLocalCamera;
            break;
        case ChuangPublishStateDisconnected:
            stateStr = @"断开连接";
            [self reloadStreamCount];
           // [self updataBottomBarInteractionCount];
            break;
            
        default:
            break;
    }
    NSString *log = [NSString stringWithFormat:@"推流状态变化回调 streamId: %@ state: %@ %lu code: %d",streamId, stateStr,(unsigned long)state, code];
    [self.logView appendProcessTipAndMakeVisible:log];
    
   // [self updataBottomBarInteractionCount];
}
- (void)onPlayStreamStateUpdate:(NSString *)streamId state:(ChuangPlayState)state errorCode:(int)code {
    
    NSString *stateStr = @"连接中";
    switch (state) {
        case ChuangPlayStateConnecting:
    
            break;
        case ChuangPlayStateConnected:
            stateStr = @"连接成功";
            break;
        case ChuangPlayStateDisconnected:
            stateStr = @"连接断开";
            break;
            
        default:
            break;
    }
    NSString *log = [NSString stringWithFormat:@"播流状态变化回调 streamId: %@ state: %@ %lu code: %d",streamId, stateStr,(unsigned long)state, code];
    [self.logView appendProcessTipAndMakeVisible:log];
}
/*!
 @brief 播流首帧视频回调
 @param streamId 流ID
 */
- (void)onPlayStreamFirstVideo:(NSString *)streamId{
    NSString *log = [NSString stringWithFormat:@"播流首帧回调 streamId: %@",streamId];
    [self.logView appendProcessTipAndMakeVisible:log];
    PlayModel *model = [self playModelWithStreamId:streamId];
    if (model.playView.hidden == YES) {
        model.playView.hidden = NO;
    }
    
}
- (void)onPlayStreamQualityUpdate:(NSString *)streamId quality:(ChuangPlayStreamQuality *)quality {
    
    BOOL showVideoDetail = [[CYPublishTopicConfigManager sharedInstance] showDataState];
    if (showVideoDetail || self.roomStatusConfig.isOpenSoundLevel || self.roomStatusConfig.isOpenSpeedTest) {
        PlayModel *model = [self playModelWithStreamId:streamId];
        model.showVideoDetail = showVideoDetail;
        model.isOpenSoundLevel = self.roomStatusConfig.isOpenSoundLevel;
        model.isOpenSpeedtest = self.roomStatusConfig.isOpenSpeedTest;
        model.networkSpeedtest = self.availableBndWidthKbps;
        model.quality = quality;
        [self.playContentView reloadData];
    }
}
- (void)onPublishStreamQualityUpdate:(NSString *)streamId quality:(ChuangPublishStreamQuality *)quality {
    NSMutableString *muStr = [[NSMutableString alloc] initWithString:@""];
    if ([[CYPublishTopicConfigManager sharedInstance] showDataState]) {
        if ([[CYPublishTopicConfigManager sharedInstance] audioOnlyState]) {
            quality.videoFps = 0;
        }
        NSString *qualityStr = [NSString stringWithFormat:@"bitrate：%d\nvideofps：%d\naudiofps: %d\nlost:%.2f\ndelay：%d\n",quality.videoBitrateKbps,quality.videoFps,0, quality.packetLostRate, quality.rtt];
        [muStr appendString:qualityStr];
      //  self.localView.qualityLabel.text = qualityStr;
        
        
        if (self.roomStatusConfig.isOpenSoundLevel) {
            NSString *volumeStr = [NSString stringWithFormat:@"volume: %d\n",self.publishVolume];
            [muStr appendString:volumeStr];
        }
        if (self.localView.showBig) {
            if (self.roomStatusConfig.isOpenSpeedTest) {
                NSString *SpeedTest = [NSString stringWithFormat:@"network: %d",self.availableBndWidthKbps];
                [muStr appendString:SpeedTest];
            }
        }
    }
    
    self.localView.qualityLabel.text = muStr;
    if ([[CYPublishTopicConfigManager sharedInstance] showDataState] && !self.roomStatusConfig.isOpenSoundLevel && !self.roomStatusConfig.isOpenSpeedTest) {
        for (int i = 0; i < self.playStreamInfoArray.count; i ++) {
            PlayModel *model = self.playStreamInfoArray[i];
            model.playView.qualityLabel.text = @"";
        }
    }
}
- (void)onNetworkSpeedTestQualityUpdate:(ChuangNetworkSpeedQuality *)quality type:(ChuangNetworkType)type {
    self.availableBndWidthKbps = quality.availableBndWidthKbps;
    NSString *log = [NSString stringWithFormat:@"quality: %d Kbps networkType: %ld",quality.availableBndWidthKbps, (long)type];
    [self.logView appendProcessTipAndMakeVisible:log];

}
// 音视频流状态改变回调，例如远端推流静音音视频
- (void)onPlayStreamStateChanged:(NSString *)streamId state:(ChuangStreamState)state {
    
    NSString *stateStr = @"";
    CYInteractionStatusConfig *interactionStatusConfig = [self.interactionSetInfo objectForKey:streamId];
    PlayModel *model = [self playModelWithStreamId:streamId];
    switch (state) {
        case ChuangStreamStateAudioMute:
            stateStr = @"音频静音";
            interactionStatusConfig.muteAudioStatus = AudioStatus_RemoteClosed;
            break;
        case ChuangStreamStateAudioUnmute:
            stateStr = @"音频未静音";
            if (interactionStatusConfig.muteAudioStatus != AudioStatus_LocalClosed) {
                interactionStatusConfig.muteAudioStatus = AudioStatus_Normal;
            }
            break;
        case ChuangStreamStateVideoMute:
            stateStr = @"视频静音";
            model.playView.placcholdImageview.hidden = NO;
            interactionStatusConfig.muteVideoStatus = VideoStatus_RemoteClosed;
            
            break;
        case ChuangStreamStateVideoUnmute: {
            stateStr = @"视频未静音";
            if (interactionStatusConfig.muteVideoStatus != VideoStatus_LocalClosed) {
                model.playView.placcholdImageview.hidden = YES;
                interactionStatusConfig.muteVideoStatus = VideoStatus_Normal;
            }
        }
            break;
            
        default:
            break;
    }
    self.interactionView.interactionConfig = interactionStatusConfig;
    NSString *log = [NSString stringWithFormat:@"音视频流状态改变回调 streamId: %@ state: %@",streamId, stateStr];
    [self.logView appendProcessTipAndMakeVisible:log];
}
- (void)onMixStreamResult:(int)code {
    NSString *log = [NSString stringWithFormat:@"混流结果回调 code: %d",code];
    [self.logView appendProcessTipAndMakeVisible:log];
    if (code == 0) {
        self.mixState = ChuangMixState_Connected;
    }else {
        self.mixState = ChuangMixState_DisConnected;
    }
    
}
- (void)onRemoteSoundLevelUpdate:(NSArray<ChuangSoundLevel *> *)soundLevels {
    for (ChuangSoundLevel *obj in soundLevels) {
        PlayModel *model = [self playModelWithStreamId:obj.streamId];
        model.soundLevel = obj.soundLevel;
    }
    if (soundLevels.count) {
        [self.playContentView reloadData];        
    }
}
- (void)onCaptureSoundLevelUpdate:(ChuangSoundLevel *)soundLevel {
    self.publishVolume = soundLevel.soundLevel;
   // self.soundLevelLabel.text = [NSString stringWithFormat:@"推流音量：%d",soundLevel.soundLevel];
}


- (void)onReceiveStreamAttchedMessage:(NSString *)streamId msg:(NSString *)msg {
    NSString *log = [NSString stringWithFormat:@"推流附加消息接收: %@",msg];
    [self.logView appendProcessTipAndMakeVisible:log];
}


//网络状态变化
- (void)onNetworkTypeChanged:(ChuangNetworkType)type {
    
}

#pragma mark - PlayContentViewDataSource
- (NSUInteger)numberOfIndexInPlayContentView:(PlayContentView *)playContentView {
    if (self.role == ChuangUserRoleAudience) {
        //观众
        return self.playStreamInfoArray.count >= 1 ? self.playStreamInfoArray.count-1:0;
    }
    return self.playStreamInfoArray.count;
}
- (PlaySubView *)playContentView:(PlayContentView *)playContentView subViewForIndex:(NSUInteger)index {
    if (self.role == ChuangUserRoleAudience) {
        PlayModel *model = self.playStreamInfoArray[index + 1];
        model.playView.delegate = self;
        return model.playView;
    }
    else {
        PlayModel *model = self.playStreamInfoArray[index];
        model.playView.delegate = self;
        return model.playView;
    }
    
}
#pragma mark - PlayContentViewDelegate
- (CGFloat)playContentView:(PlayContentView *)playContentView widthForIndexPath:(NSUInteger)index {
    return (SCREEN_WIDTH - 40) / 4;//playContentView.bounds.size.height/3*2;
}


#pragma mark -- 设置代理

- (void)updateVideoDataState:(BOOL)isShowVideoData {
    NSInteger isShowDataState = 0;
    self.roomStatusConfig.isShowVideoLog = isShowVideoData;
    if (isShowVideoData == YES) {
        isShowDataState = 1;
    }else {
        isShowDataState = 0;
    }
    [[CYPublishTopicConfigManager sharedInstance] updataShowDataState:isShowDataState];
}

- (void)updateVideoMirrorState:(BOOL)isOpenMirror {
    ChuangVideoCanvas *canvas = [self.canvasInfo objectForKey:self.localStreamId];
    if (isOpenMirror) {
        canvas.mirrorMode = ChuangVideoMirrorModeEnabled;
    }
    else {
        canvas.mirrorMode = ChuangVideoMirrorModeDisabled;
    }
    
    [self.liveEngine setPreview:canvas];
    self.roomStatusConfig.isOpenMirror = isOpenMirror;
}

- (void)updateSpeedTestState:(BOOL)isOpenSpeedTest {
    self.roomStatusConfig.isOpenSpeedTest = isOpenSpeedTest;
    if (isOpenSpeedTest) {
        ChuangNetworkSpeedTestConfig *config = [[ChuangNetworkSpeedTestConfig alloc] init];
        config.testDownLink = YES;
        config.exceptedDownLinkBitrateKbps = 1024;
        [self.liveEngine startNetworkSpeedTest:config];
    }else{
        [self.liveEngine stopNetworkSpeedTest];
    }
}

- (void)updateSoundLevelState:(BOOL)isOpenSoundLevel {
    self.roomStatusConfig.isOpenSoundLevel = isOpenSoundLevel;
    if (isOpenSoundLevel) {
        [self.liveEngine startSoundLevelMonitor];
    }else{
        [self.liveEngine stopSoundLevelMonitor];
        self.soundLevelLabel.text = @"";
        for (PlayModel *model in self.playStreamInfoArray) {
            model.soundLevel = 0;
        }
        [self.playContentView reloadData];
    }
}


- (void)updateLogState:(BOOL)isOpenLog {
    self.roomStatusConfig.isOpenLog = isOpenLog;
    [self.logView updateLogState:isOpenLog];
}

- (void)updateMixAudioState:(BOOL)isOpenMixAudio {
    self.roomStatusConfig.isOpenMixAudio = isOpenMixAudio;
    [self.liveEngine enableAudioMixing:isOpenMixAudio];
    if (isOpenMixAudio) {
        [self.liveEngine setAudioMixingHandler:self];
        //采集自定义pcm数据
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"48000-2" ofType:@"pcm"]];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        self.mixAudioData = [[NSMutableData alloc] initWithData:data];
        self.count = data.length/kAudioReadCount + 1;
        self.index = 0;
    }else{
        [self.liveEngine setAudioMixingHandler:nil];
        self.mixAudioData = nil;
        self.count = 0;
        self.index = 0;
    }
}

- (void)sendStreamMessage:(NSString *)mesage {
    [self.liveEngine sendStreamAttachedMessage:mesage];
}

- (void)updateMixStreamState:(BOOL)isMixStream {
    self.roomStatusConfig.isMixStream = isMixStream;

    if (isMixStream) {
        if (self.publishState == ChuangPublishStateConnected) {
            [self startMixStream];
        }
    }else{
        if (self.mixState == ChuangMixState_Connected || self.mixState == ChuangMixState_Connecting) {
            [self stopMixStream];
        }
    }
    [[CYPublishTopicConfigManager sharedInstance] updateMixRtmpEnable:isMixStream];
}

- (void)renderWithModel:(ChuangVideoRenderMode)renderModel {
    ChuangVideoCanvas *canvas = [self.canvasInfo objectForKey:self.localStreamId];
    canvas.renderMode = renderModel;
    [self.liveEngine setPreview:canvas];
    CYLiveRoomStatusConfig *roomStatusConfig = [self.interactionSetInfo objectForKey:self.localStreamId];
    roomStatusConfig.renderMode = renderModel;
}

#pragma mark -- 互动窗口设置

- (void)muteAudioWithStreamId:(NSString *)streamId isMute:(BOOL)mute {
    int muteResult = [self.liveEngine muteRemoteAudio:streamId mute:!mute];
    if (muteResult == 0) {
        CYInteractionStatusConfig *interactionConfig = [self.interactionSetInfo objectForKey:streamId];
        if (!mute) {
            interactionConfig.muteAudioStatus = AudioStatus_Normal;
        }
        else {
            interactionConfig.muteAudioStatus = AudioStatus_LocalClosed;
        }
        
    }
}

- (void)muteVideoWithStreamId:(NSString *)streamId isMute:(BOOL)mute isLocal:(BOOL)isLocal {
    PlayModel *model = [self playModelWithStreamId:streamId];
    int muteResult = [self.liveEngine muteRemoteVideo:streamId mute:mute];
    if (muteResult == 0) {
        CYInteractionStatusConfig *interactionConfig = [self.interactionSetInfo objectForKey:streamId];
        if (!mute) {
            model.playView.placcholdImageview.hidden = YES;
            interactionConfig.muteVideoStatus = VideoStatus_Normal;
        }
        else {
            if (isLocal) {
                interactionConfig.muteVideoStatus = VideoStatus_LocalClosed;
            }
            else {
                interactionConfig.muteVideoStatus = VideoStatus_RemoteClosed;
            }
            
            model.playView.placcholdImageview.hidden = NO;
        }
    }
}

- (void)renderModelWithStreamId:(NSString *)streamId model:(ChuangVideoRenderMode)renderModel {
    ChuangVideoCanvas *canvas = [self.canvasInfo objectForKey:streamId];
    canvas.renderMode = renderModel;
    [self.liveEngine startPlayStream:streamId withCanvas:canvas];
    
    CYInteractionStatusConfig *interactionConfig = [self.interactionSetInfo objectForKey:streamId];
    interactionConfig.renderMode = renderModel;
}

- (void)showEmptyView {
    if (self.role == ChuangUserRoleAudience) {
        [self.view addSubview:self.emptyView];
    }
}

- (void)dismissEmptyView {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
}

- (void)showNetworkStatus {
    if ([CYNetworkStatus sharedSingleton].netStatus == NotReachable) {
        //无网络
        [self.view CY_showHudText:@"当前暂无网络" duration:2.0];
    }
    
}

#pragma mark -- lazy

- (CYInteractionSetView *)interactionView {
    if (!_interactionView) {
        _interactionView = [[CYInteractionSetView alloc] init];
        _interactionView.delegate = self;
    }
    return _interactionView;
}

- (CYEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[CYEmptyView alloc] initWithFrame:self.view.bounds];
    }
    return _emptyView;
}

- (PlaySubView *)audiencePlayView {
    if (!_audiencePlayView) {
        _audiencePlayView = [[PlaySubView alloc] initWithFrame:self.bigFrame];
        _audiencePlayView.showBig = YES;
        _audiencePlayView.delegate = self;
        _audiencePlayView.modeView.hidden = YES;
        _bigView = _audiencePlayView;
    }
    return _audiencePlayView;
}

- (void)dealloc {
 
//    NSLog(@"%@ dealloc", self);
}
@end
