//
//  CYVersionViewController.m
//  ChuangRtcDemo
//

#import "CYVersionViewController.h"
#import <ChuangRtcKit/ChuangRtcKit.h>

@interface CYVersionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation CYVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于";
    [self initData];
    [self loadTableView];
}

- (void)initData {
    NSString *SDKVersion = [ChuangLiveEngine getSDKVersion];
    NSString *appVersion = [self getIpaBuileTime];
    
    self.dataSource = @[@{@"title":@"SDK版本号:",@"content":SDKVersion},@{@"title":@"APP版本号:",@"content":appVersion}];
}

- (NSString *)getIpaBuileTime {
    NSString *buildDate = [NSString stringWithFormat:@"%@ %@",[NSString stringWithUTF8String:__DATE__], [NSString stringWithUTF8String:__TIME__]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"MMM dd yyyy HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:buildDate];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSDate *bulidDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |                 NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:bulidDate];
    
    int year = (int)[dateComponent year];
    int month = (int)[dateComponent month];
    NSString *monthStr;
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%d",month];
    }
    else {
        monthStr = [NSString stringWithFormat:@"%d",month];
    }
    NSString *dayStr;
    int day = (int)[dateComponent day];
    if (day < 10) {
        dayStr = [NSString stringWithFormat:@"0%d",day];
    }
    else {
        dayStr = [NSString stringWithFormat:@"%d",day];
    }
    int hour = (int)[dateComponent hour];
    NSString *hourStr;
    if (hour < 10) {
        hourStr = [NSString stringWithFormat:@"0%d",hour];
    }
    else {
        hourStr = [NSString stringWithFormat:@"%d",hour];
    }
    int minute = (int)[dateComponent minute];
    NSString *minuteStr;
    if (minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%d",minute];
    }
    else {
        minuteStr = [NSString stringWithFormat:@"%d",minute];
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *time = [NSString stringWithFormat:@"iOS-%@-%d%@%@%@%@",app_Version,year,monthStr,dayStr,hourStr,minuteStr];
    
    return time;
}

- (void)loadTableView {
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
}

#pragma mark -- UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"versionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromHex(0xf9fbfa);
    }
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.textLabel.font = K_REGULAR_FONT(14);
    cell.textLabel.textColor = UIColorFromHex(0x1b1b1b);
    cell.detailTextLabel.text = dict[@"content"];
    cell.detailTextLabel.font = K_REGULAR_FONT(12);
    cell.detailTextLabel.textColor = UIColorFromHex(0x1b1b1b);
    return cell;
}

#pragma mark -- lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColorFromHex(0xf9fbfa);
    }
    return _tableView;
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
