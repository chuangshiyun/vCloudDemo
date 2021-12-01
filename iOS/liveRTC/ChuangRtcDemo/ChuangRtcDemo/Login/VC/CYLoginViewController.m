//
//  CYLoginViewController.m
//  ChuangRtcDemo
//


#import "CYLoginViewController.h"
#import "CYLoginVM.h"


@interface CYLoginViewController ()

@property (nonatomic, strong) CYLoginVM *VM;

@end

@implementation CYLoginViewController

#pragma mark - lazy
- (CYLoginVM *)VM {
    if (!_VM) {
        _VM = [[CYLoginVM alloc] init];
        _VM.VC = self;
    }
    return _VM;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSubViews];
}

- (void)loadSubViews {
    self.VM.mainView.frame = self.view.bounds;
    [self.view addSubview:self.VM.mainView];
    [self.VM layoutSubViews];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
