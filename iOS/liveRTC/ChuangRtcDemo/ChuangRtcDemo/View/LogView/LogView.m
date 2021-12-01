//
//  LogView.m
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/24.
//

#import "LogView.h"
#import "CYPublishTopicConfigManager.h"
#import "CYKeyCenter.h"

@interface LogView ()<UITableViewDataSource>
@property (nonatomic, strong) UIButton *logSwichBtn;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIButton *clearButton;
/// 是否输出日志
@property (nonatomic, assign) BOOL isOutputLog;
@property (nonatomic, strong) NSMutableArray *dataArray;



@end

@implementation LogView
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews {
    
    self.isOutputLog = YES;
    UIButton *logSwichBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    logSwichBtn.selected = YES;
    [logSwichBtn setTitle:@"日志开关" forState:UIControlStateNormal];
    [logSwichBtn addTarget:self action:@selector(logSwichBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:logSwichBtn];
    self.logSwichBtn = logSwichBtn;
    logSwichBtn.hidden = YES;
    

    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithRed:236/255 green:237/255 blue:226/255 alpha:0.4];
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 20;
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.hidden = YES;
    
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [clearButton setTitle:@"清空日志" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearButton];
    self.clearButton = clearButton;
    clearButton.hidden = YES;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnW = 80;
    CGFloat btnH = 30;
    CGFloat btnX = self.bounds.size.width - btnW;
    self.logSwichBtn.frame = CGRectMake(btnX, 0, btnW, btnH);
    
    
    CGFloat textViewY = CGRectGetMaxY(self.logSwichBtn.frame);
    CGFloat textViewW = self.bounds.size.width;
    CGFloat textViewH = self.bounds.size.height - btnH;
    
    self.tableView.frame = CGRectMake(0, 0, textViewW, textViewH);
    
    CGFloat clearY = CGRectGetMaxY(self.tableView.frame) - btnH;
    self.clearButton.frame = CGRectMake(btnX, clearY, btnW, btnH);
    
}


#pragma mark - 按钮点击事件监听
- (void)logSwichBtnClick:(UIButton *)btn {
    
    btn.selected = !btn.isSelected;
    self.tableView.hidden = !btn.isSelected;
    self.isOutputLog = btn.isSelected;
}
- (void)clearButtonClick:(UIButton *)btn {
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)updateLogState:(BOOL)isOpen {
    self.tableView.hidden = !isOpen;
    self.isOutputLog = isOpen;
    self.clearButton.hidden = !isOpen;
}

- (void)appendProcessTipAndMakeVisible:(NSString *)tipText {
    
    if (!tipText || tipText.length == 0 || !self.isOutputLog) {
        return;
    }
    
#if DEBUG
    NSLog(@"%@",tipText);
#else

#endif
    [self.dataArray addObject:[NSString stringWithFormat:@"%@ %@",[self currentdateInterval], tipText]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];

    });
    
}


- (NSString *)currentdateInterval
{
    NSDate *nowdate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *strDate = [dateFormatter stringFromDate:nowdate];
    return strDate;
}
/// 滚动到底部
- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger section = [self.tableView numberOfSections];
    if (section < 1) return; //无数据时不执行 要不会crash
    
    NSInteger row = [self.tableView numberOfRowsInSection:section - 1];
    if (row < 1) return; //无数据时不执行 要不会crash
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row - 1 inSection:section - 1];
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }];
    }else{
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:10];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
@end
