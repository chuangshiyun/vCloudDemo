//
//  CYChooseRolesViewController.m
//  ChuangRtcDemo
//


#import "CYChooseRolesViewController.h"
#import "CYRoleModel.h"
#import "CYChooseRolesCell.h"
#import "CYAuthorizationManager.h"
#import "UIView+CY.h"
#import "CYRtcViewController.h"

@interface CYChooseRolesViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation CYChooseRolesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"请选择您的身份";
    [self initData];
    [self loadTableView];

}

- (void)initData {
    CYRoleModel *model1 = [[CYRoleModel alloc] init];
    model1.bgImage = @"host";
    model1.title = @"我是主播";
    model1.roomId = self.roomId;
    model1.subTitle = @"以主播身份进入";
    model1.userRole = ChuangUserRoleAnchor;
    
    CYRoleModel *model2 = [[CYRoleModel alloc] init];
    model2.bgImage = @"audience";
    model2.title = @"我是观众";
    model2.roomId = self.roomId;
    model2.subTitle = @"以观众身份进入";
    model2.userRole = ChuangUserRoleAudience;
    
    CYRoleModel *model3 = [[CYRoleModel alloc] init];
    model3.bgImage = @"interactive";
    model3.title = @"互动视频";
    model3.roomId = self.roomId;
    model3.subTitle = @"进入多人视频";
    model3.userRole = ChuangUserRoleInteraction;
    self.dataSource = @[model1,model2,model3];
}

- (void)loadTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -- UITableViewDelegate  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return K_Width(148.5);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CYChooseRolesCell";
    CYChooseRolesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CYChooseRolesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CYRoleModel *roleModel = self.dataSource[indexPath.row];
    cell.roleModel = roleModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 1) {
        BOOL isCanCamera = [CYAuthorizationManager checkVideoCameraAuthorization];
        BOOL isCanMicrophone = [CYAuthorizationManager checkVideoMicrophoneAudioAuthorization];
        if (!isCanCamera || !isCanMicrophone) {
            return;
        }
    }
    
    CYRoleModel *roleModel = self.dataSource[indexPath.row];
    CYRtcViewController *rtcVc = [[CYRtcViewController alloc] init];
    rtcVc.roomId = self.roomId;
    rtcVc.userId = self.userId;
    rtcVc.localStreamId = self.userId;
    rtcVc.role = roleModel.userRole;
  
    [self.navigationController pushViewController:rtcVc animated:YES];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.roomId forKey:@"roomId"];
    [userDefault setObject:self.userId forKey:@"userId"];
    [userDefault synchronize];
}

#pragma mark -- lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = UIColorFromHex(0xf9fbfa);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
