//
//  AppDelegate.m
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/17.
//

#import "AppDelegate.h"
#import "CYBaseNaviViewController.h"
#import "CYLoginViewController.h"
#import "IQKeyboardManager.h"
#import "CYNetworkStatus.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    CYLoginViewController *VC = [[CYLoginViewController alloc] init];
    CYBaseNaviViewController *navi = [[CYBaseNaviViewController alloc] initWithRootViewController:VC];
    self.window.rootViewController = navi;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window makeKeyWindow];
    
    [self initIQKeyboardManager];
    [[CYNetworkStatus sharedSingleton] startListenNetWorkingStatus];
    
    return YES;
}

- (void)initIQKeyboardManager {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}



@end
