//
//  CYPreSetViewController.m
//  ChuangRtcDemo
//


#import "CYPreSetViewController.h"
#import "CYPreSetVM.h"

@interface CYPreSetViewController ()

@property (nonatomic, strong) CYPreSetVM *VM;

@end

@implementation CYPreSetViewController

#pragma mark -- lazy

- (CYPreSetVM *)VM {
    if (!_VM) {
        _VM = [[CYPreSetVM alloc] init];
        _VM.VC = self;
    }
    return _VM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"常用功能设置";
    self.VM.tableView.frame = self.view.bounds;
    [self.view addSubview:self.VM.tableView];

}

- (void)backBtnClick {
    [self.VM backBtnClick];
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
