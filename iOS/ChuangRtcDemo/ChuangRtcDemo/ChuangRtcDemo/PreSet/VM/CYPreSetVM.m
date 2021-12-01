//
//  CYPreSetVM.m
//  ChuangRtcDemo
//


#import "CYPreSetVM.h"
#import "CYCellManager.h"
#import "CYPreSetHeadView.h"
#import "CYDefaultSetTableViewCell.h"
#import "CYSetTextInfoTableViewCell.h"
#import "CYPublishTopicConfigManager.h"
#import "CYKeyCenter.h"
#import "CYAPIHeader.h"
#import "UIView+CY.h"
#import "CYVersionViewController.h"
#import "CYPreSetRTCCell.h"
#import <objc/runtime.h>

@interface CYPreSetVM ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sectionsArray;
///是否开启纯音频模式
@property (nonatomic, assign) BOOL isAudioOnly;
///是否显示视频统计
@property (nonatomic, assign) BOOL isShowVideoData;
///是否开启RTMP推流
@property (nonatomic, assign) BOOL isRtmpEnable;
///是否开启RTMP混流
@property (nonatomic, assign) BOOL isMixRtmpEnable;
///混流是否同步到Rtc
@property (nonatomic, assign) BOOL isMixRtcEnable;

@end

@implementation CYPreSetVM

static NSArray<NSValue*> *CYPublishTopicCommonResolutionList;
static NSArray<NSNumber*> *CYPublishTopicCommonBitrateList;
static NSArray<NSNumber*> *CYMixPublishTopicCommonBitrateList;
static NSArray<NSNumber*> *CYPublishTopicCommonFpsList;
static NSArray<NSNumber*> *CYPublishTopicCommonVideoViewModeList;
static NSArray<NSNumber*> *CYCVPixelBufferPixelFormatTypeKeyList;
static NSArray<NSValue*>  *CYMixStreamTopicCommonResolutionList;

#pragma mark -- lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = SMViewBGColor;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 88, 0);
    }
    return _tableView;
}

#pragma mark -- init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
        [self loadData];
    }
    return self;
}

- (void)initData {
    //分辨率
    CYPublishTopicCommonResolutionList =
        @[@(CGSizeMake(1080, 1920)),
          @(CGSizeMake(720, 1280)),
          @(CGSizeMake(540, 960)),
          @(CGSizeMake(360, 640)),
          @(CGSizeMake(270, 480)),
          @(CGSizeMake(180, 320))];
   //码率
    CYPublishTopicCommonBitrateList =
        @[@(3000),
          @(1500),
          @(1200),
          @(600),
          @(400),
          @(300)];
    //混流码率
    CYMixPublishTopicCommonBitrateList =
         @[@(1500),
           @(1000),
           @(800),
           @(600),
           @(400),
           @(300)];
    //混流输出视频分辨率
    CYMixStreamTopicCommonResolutionList =
        @[@(CGSizeMake(720, 1280)),
        @(CGSizeMake(1280, 720)),
        @(CGSizeMake(800, 600)),
        @(CGSizeMake(432,768)),
        @(CGSizeMake(768,432))];
    
    //帧率
    CYPublishTopicCommonFpsList = @[@(10),@(15),@(20),@(25),@(30)];

    //渲染视图模式
    CYPublishTopicCommonVideoViewModeList = @[@(ChuangVideoRenderModePerfectFill),
          @(ChuangVideoRenderModePerfectFit)];
    
}

///数据源
- (void)loadData {
    self.sectionsArray = [[NSMutableArray alloc] init];
    NSMutableArray <CYCellManager *>*zeroSections = [[NSMutableArray alloc] init];
    CYPublishTopicConfigManager *manager = [CYPublishTopicConfigManager sharedInstance];
    
    CGSize size = [manager resolution];
    NSString *sizeStr = [self textForResolution:size];
    NSMutableDictionary *dic00 = [[NSMutableDictionary alloc] initWithDictionary:@{@"title":@"推流分辨率",@"subTitle":@"推流前设置生效",@"content":[NSString stringWithFormat:@"%@ >",sizeStr]}];
    CYCellManager *cell00 = [[CYCellManager alloc] initWithIdentifier:@"CYDefaultSetTableViewCell" data:dic00 type:@"推流分辨率"];
    
    [zeroSections addObject:cell00];
    
    NSMutableArray <CYCellManager *>*oneSections = [[NSMutableArray alloc] init];
    NSMutableArray <CYCellManager *>*twoSections = [[NSMutableArray alloc] init];
    NSMutableArray <CYCellManager *>*threeSections = [[NSMutableArray alloc] init];
    NSMutableArray <CYCellManager *>*foreSections = [[NSMutableArray alloc] init];
    NSString *rtmpAddress = [manager rtmpAddress];
    NSMutableDictionary *dic30 = [[NSMutableDictionary alloc] initWithDictionary: @{@"title":@"RTMP推流地址",@"subTitle":@"请设置RTMP推流地址",@"content":rtmpAddress,@"key":CYPublishRtmpAddressKey}];
    CYCellManager *cell30 = [[CYCellManager alloc] initWithIdentifier:@"CYSetTextInfoTableViewCell" data:dic30 type:@"RTMP推流地址"];
    [threeSections addObject:cell30];
    
    NSMutableArray <CYCellManager *>*fiveSections = [[NSMutableArray alloc] init];
    NSString *mixRtmpAddress = [manager mixRtmpAddress];
    NSMutableDictionary *dic40 = [[NSMutableDictionary alloc] initWithDictionary: @{@"title":@"RTMP混流地址",@"subTitle":@"请设置RTMP混流地址",@"content":mixRtmpAddress,@"key":CYMixStreamRtmpAddressKey}];
    
    self.isMixRtcEnable = [manager mixRtcEnbale];
    NSMutableDictionary *dic41 = [[NSMutableDictionary alloc] initWithDictionary: @{@"title":@"混流是否同步到RTC",@"subTitle":@"",@"content":[NSNumber numberWithBool:self.isMixRtcEnable]}];
        
    NSInteger mixOutputRtmpBitratekKBps = [manager mixOutputRtmpBitrateKBps];
    NSMutableDictionary *dic42 = [[NSMutableDictionary alloc] initWithDictionary: @{@"title":@"RTMP混流码率",@"subTitle":@"推荐4G:600kbps wifi:1000kbps",@"content":[NSString stringWithFormat:@"%ldkbps >",(long)mixOutputRtmpBitratekKBps],@"key":CYMixOutputRtmpBitrateKBpsKey}];
        
    CGSize mixSize = [manager mixRtmpResolution];
    NSString *mixSizeStr = [self textForResolution:mixSize];
    NSMutableDictionary *dic43 = [[NSMutableDictionary alloc] initWithDictionary: @{@"title":@"RTMP混流分辨率",@"subTitle":@"默认432*768",@"content":[NSString stringWithFormat:@"%@ >",mixSizeStr]}];
    
    CYCellManager *cell40 = [[CYCellManager alloc] initWithIdentifier:@"CYSetTextInfoTableViewCell" data:dic40 type:@"RTMP混流地址"];
    CYCellManager *cell41 = [[CYCellManager alloc] initWithIdentifier:@"CYPreSetRTCCell" data:dic41 type:@"RTMP混流地址"];
    CYCellManager *cell42 = [[CYCellManager alloc] initWithIdentifier:@"CYDefaultSetTableViewCell" data:dic42 type:@"RTMP混流码率"];
    CYCellManager *cell43 = [[CYCellManager alloc] initWithIdentifier:@"CYDefaultSetTableViewCell" data:dic43 type:@"RTMP混流分辨率"];
    [foreSections addObject:cell40];
    [foreSections addObject:cell41];
    [foreSections addObject:cell42];
    [foreSections addObject:cell43];
    
        
    [self.sectionsArray addObject:zeroSections];
    [self.sectionsArray addObject:oneSections];
    [self.sectionsArray addObject:twoSections];
    [self.sectionsArray addObject:threeSections];
    [self.sectionsArray addObject:foreSections];
    [self.sectionsArray addObject:fiveSections];
    
    NSInteger showDataState = [manager showDataState];
    if (showDataState >0) {
        self.isShowVideoData = YES;
    }else{
        self.isShowVideoData = NO;
    }
    self.isRtmpEnable = [manager publishRtmpEanble];
    self.isMixRtmpEnable = [manager mixRtmpEanble];
    self.isAudioOnly = [manager audioOnlyState];
}

- (NSString *)textForResolution:(CGSize)resolution {
    return [NSString stringWithFormat:@"%@ * %@", @(resolution.width),@(resolution.height)];
}
- (NSString *)textForBitrate:(NSInteger)bitrate {
   return [NSString stringWithFormat:@"%ldkbps",(long)bitrate];;
}

#pragma mark -- UITableViewDelegate  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = self.sectionsArray[section];
    if (section == 3) {
        return self.isRtmpEnable ? sections.count : 0;
    }
    else if (section == 4) {
        return self.isMixRtmpEnable ? sections.count : 0;
    }
    else {
        return sections.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CYCellManager *manager = self.sectionsArray[indexPath.section][indexPath.row];
    if ([manager.cellIdentifier isEqualToString:@"CYDefaultSetTableViewCell"]) {
        CYDefaultSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:manager.cellIdentifier];
        if (!cell) {
            cell = [[CYDefaultSetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:manager.cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.infoDic = manager.data;
        return cell;
    }
    else if ([manager.cellIdentifier isEqualToString:@"CYSetTextInfoTableViewCell"]) {
        CYSetTextInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:manager.cellIdentifier];
        if (!cell) {
            cell = [[CYSetTextInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:manager.cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.infoDic = manager.data;
        __weak __typeof(self)weakSelf = self;
        cell.changeTextBlock = ^(NSString * _Nonnull newText, NSString * _Nonnull key) {
            [weakSelf saveNewContentText:newText withKey:key];
        };
        return cell;
    }
    else if ([manager.cellIdentifier isEqualToString:@"CYPreSetRTCCell"]) {
        CYPreSetRTCCell *cell = [tableView dequeueReusableCellWithIdentifier:manager.cellIdentifier];
        if (!cell) {
            cell = [[CYPreSetRTCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:manager.cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        __weak typeof(self) weakSelf = self;
        cell.titleLabel.text = @"混流是否同步到RTC";
        cell.rigthSwitch.on = self.isMixRtcEnable;
        cell.openCallBlock = ^(BOOL isOpen) {
            weakSelf.isMixRtcEnable = isOpen;
            [[CYPublishTopicConfigManager sharedInstance] updateMixRtcEnable:isOpen];
        };
        return cell;
    }
    else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else {
        return 61;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        static NSString *headIdentifier = @"UITableViewHeaderFooterView";
        UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headIdentifier];
        if (!headView) {
            headView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headIdentifier];
            headView.contentView.backgroundColor = SMViewBGColor;
        }
        return headView;
    }
    else {
        static NSString *headIdentifier = @"CYPreSetHeadView";
        CYPreSetHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headIdentifier];
        if (!headView) {
            headView = [[CYPreSetHeadView alloc] initWithReuseIdentifier:headIdentifier];
            headView.contentView.backgroundColor = SMViewBGColor;
        }
        __weak typeof(self) weakSelf = self;
        headView.rigthSwitch.hidden = NO;
        if (section == 1) {
            headView.titleLabel.text = @"显示统计数据";
            headView.rigthSwitch.on = self.isShowVideoData;
            headView.openCallBlock = ^(BOOL isOpen) {
                weakSelf.isShowVideoData = isOpen;
                NSInteger isShowDataState = 0;
                if (weakSelf.isShowVideoData == YES) {
                    isShowDataState = 1;
                }else{
                    isShowDataState = 0;
                }
                [[CYPublishTopicConfigManager sharedInstance] updataShowDataState:isShowDataState];
            };
        }
       else if (section == 2) {
            headView.titleLabel.text = @"是否开启纯音频推流";
            headView.rigthSwitch.on = self.isAudioOnly;
            headView.openCallBlock = ^(BOOL isOpen) {
                weakSelf.isAudioOnly = isOpen;
                [[CYPublishTopicConfigManager sharedInstance] updataAudioOnleState:weakSelf.isAudioOnly];
            };
        }
        else if (section == 3) {
            headView.titleLabel.text = @"是否开启RTMP推流服务";
            headView.rigthSwitch.on = self.isRtmpEnable;
            headView.openCallBlock = ^(BOOL isOpen) {
                weakSelf.isRtmpEnable = isOpen;
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                [[CYPublishTopicConfigManager sharedInstance] updatePublishRtmpEnable:weakSelf.isRtmpEnable];
            };
        }
        else if (section == 4) {
            headView.titleLabel.text = @"是否开启RTMP混流服务";
            headView.rigthSwitch.on = self.isMixRtmpEnable;
            headView.openCallBlock = ^(BOOL isOpen) {
                weakSelf.isMixRtmpEnable = isOpen;
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                [[CYPublishTopicConfigManager sharedInstance] updateMixRtmpEnable:weakSelf.isMixRtmpEnable];
            };
        }
        else {
            headView.rigthSwitch.hidden = YES;
            headView.titleLabel.text = @"关于";
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAbloutApp)];
            headView.backView.userInteractionEnabled = YES;
            [headView.backView addGestureRecognizer:tap];
        }
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CYCellManager *manager = self.sectionsArray[indexPath.section][indexPath.row];
    if ([manager.type isEqualToString:@"推流分辨率"]) {
        [self showResolutionListPickSheet];
    }
    else if ([manager.type isEqualToString:@"RTMP混流码率"]) {
        [self showMixStreamBitrateSheet];
    }
    else if ([manager.type isEqualToString:@"RTMP混流分辨率"]) {
        [self showMixResolutionListPickSheet];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.VC.view endEditing:YES];
}


#pragma mark - 选择分辨率
- (void)showResolutionListPickSheet {
    NSString *messageTitle = @"选择推流分辨率";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:messageTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageTitle];
    [hogan addAttribute:NSForegroundColorAttributeName
                  value:UIColorFromHex(0x000000)
                  range:NSMakeRange(0, messageTitle.length)];
    [alert setValue:hogan forKey:@"attributedTitle"];
    for (NSValue *sizeObj in CYPublishTopicCommonResolutionList) {
        CGSize size = [sizeObj CGSizeValue];
        NSString *title = [self textForResolution:size];
        UIAlertAction *subAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CYCellManager *manger = self.sectionsArray[0][0];
            NSMutableDictionary *dic = manger.data;
            NSString *content = [self textForResolution:size];
            [dic setObject:[NSString stringWithFormat:@"%@ >",content] forKey:@"content"];
            [[CYPublishTopicConfigManager sharedInstance] updateResolution:size];
            [self.tableView reloadData];
        }];
        [subAction setValue:UIColorFromHex(0x5c5c5c) forKey:@"titleTextColor"];
        [alert addAction:subAction];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:UIColorFromHex(0x666666) forKey:@"_titleTextColor"];
    [alert addAction:cancelAction];
    
    [self.VC presentViewController:alert animated:YES completion:^{
        
    }];
}


#pragma mark -- 混流码率
- (void)showMixStreamBitrateSheet {
    NSString *messageTitle = @"选择RTMP混流码率";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:messageTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageTitle];
    [hogan addAttribute:NSForegroundColorAttributeName
                  value:UIColorFromHex(0x000000)
                  range:NSMakeRange(0, messageTitle.length)];
    [alert setValue:hogan forKey:@"attributedTitle"];
     for (NSNumber * bitObj in CYMixPublishTopicCommonBitrateList) {
         NSInteger bit = [bitObj integerValue];
         NSString *bitStr = [self textForBitrate:bit];
         UIAlertAction *subAction = [UIAlertAction actionWithTitle:bitStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             NSInteger bit = [bitObj integerValue];
             [[CYPublishTopicConfigManager sharedInstance] updateMixOutputRtmpBitrateKBps:bit];
             CYCellManager *manger = self.sectionsArray[4][2];
             NSMutableDictionary *dic = manger.data;
             NSString *content = [self textForBitrate:bit];
             [dic setObject:[NSString stringWithFormat:@"%@ >",content] forKey:@"content"];
             [self.tableView reloadData];
         }];
         [subAction setValue:UIColorFromHex(0x5c5c5c) forKey:@"titleTextColor"];
         [alert addAction:subAction];
     }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:UIColorFromHex(0x666666) forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
     [self.VC presentViewController:alert animated:YES completion:^{
     }];
}

#pragma mark -- 混流后输出分辨率
- (void)showMixResolutionListPickSheet {
    NSString *messageTitle = @"选择RTMP混流分辨率";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:messageTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:messageTitle];
    [hogan addAttribute:NSForegroundColorAttributeName
                  value:UIColorFromHex(0x000000)
                  range:NSMakeRange(0, messageTitle.length)];
    [alert setValue:hogan forKey:@"attributedTitle"];
    for (NSValue *sizeObj in CYMixStreamTopicCommonResolutionList) {
        CGSize size = [sizeObj CGSizeValue];
        NSString *title = [self textForResolution:size];
        UIAlertAction *subAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CYCellManager *manger = self.sectionsArray[4][3];
            NSMutableDictionary *dic = manger.data;
            NSString *content = [self textForResolution:size];
            [dic setObject:[NSString stringWithFormat:@"%@ >",content] forKey:@"content"];
            [[CYPublishTopicConfigManager sharedInstance] updateMixRtmpResolution:size];
            [self.tableView reloadData];
        }];
        [subAction setValue:UIColorFromHex(0x5c5c5c) forKey:@"titleTextColor"];
        [alert addAction:subAction];
    
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:UIColorFromHex(0x666666) forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    [self.VC presentViewController:alert animated:YES completion:^{
           
       }];
}

#pragma mark -- rtmp 推流和混流
- (void)saveNewContentText:(NSString *)newContent withKey:(NSString *)key{
    CYPublishTopicConfigManager *topicManage = [CYPublishTopicConfigManager sharedInstance];
    if ([key isEqualToString:CYPublishRtmpAddressKey]) {
        [topicManage updateRtmpAddress:newContent];
    }
    else if ([key isEqualToString:CYMixStreamRtmpAddressKey]){
        [topicManage updateMixRtmpAddress:newContent];
    }
}



#pragma mark -- 关于

- (void)gotoAbloutApp {
    CYVersionViewController *controller = [[CYVersionViewController alloc] init];
    [self.VC.navigationController pushViewController:controller animated:YES];
}

- (void)backBtnClick {
    [self.VC.view endEditing:YES];
    if (self.isRtmpEnable && self.isMixRtmpEnable) {
        CYSetTextInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        NSString *rtmpAddress = cell.textField.text;
        CYSetTextInfoTableViewCell *mixcell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
        NSString *mixRtmpAddress = mixcell.textField.text;
        if ((!rtmpAddress || rtmpAddress.length == 0) && (!mixRtmpAddress || mixRtmpAddress.length == 0)) {
            [self.VC.view CY_showHudText:@"RTMP推流和RTMP混流地址不能为空"];
            return;
        }
    }
     if (self.isRtmpEnable) {
        CYSetTextInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        NSString *rtmpAddress = cell.textField.text;
        if (!rtmpAddress || rtmpAddress.length == 0) {
            [self.VC.view CY_showHudText:@"RTMP推流地址不能为空"];
            return;
        }
    }
    if (self.isMixRtmpEnable) {
        CYSetTextInfoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
        NSString *mixRtmpAddress = cell.textField.text;
        if (!mixRtmpAddress || mixRtmpAddress.length == 0) {
            [self.VC.view CY_showHudText:@"RTMP混流地址不能为空"];
            return;
        }
    }
    
    [self.VC.navigationController popViewControllerAnimated:YES];
}

@end
