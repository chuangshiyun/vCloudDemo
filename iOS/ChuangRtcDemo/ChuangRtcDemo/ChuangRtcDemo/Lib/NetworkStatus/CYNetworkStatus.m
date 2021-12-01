//
//  CYNetworkStatus.m
//  ChuangRtcDemo
//


#import "CYNetworkStatus.h"

@interface CYNetworkStatus ()

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;

@end

@implementation CYNetworkStatus

+ (instancetype)sharedSingleton {
    static CYNetworkStatus *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedSingleton = [[super allocWithZone:NULL] init];
    });
    return _sharedSingleton;
}

// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [CYNetworkStatus sharedSingleton];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [CYNetworkStatus sharedSingleton];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [CYNetworkStatus sharedSingleton];
}


- (void)startListenNetWorkingStatus {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
     // 设置网络检测的站点
     NSString *remoteHostName = @"www.apple.com";
 
     self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
     [self.hostReachability startNotifier];
     [self updateInterfaceWithReachability:self.hostReachability];
 
     self.internetReachability = [Reachability reachabilityForInternetConnection];
     [self.internetReachability startNotifier];
     [self updateInterfaceWithReachability:self.internetReachability];
}

- (void)reachabilityChanged:(NSNotification *)note
 {
     Reachability* curReach = [note object];
     [self updateInterfaceWithReachability:curReach];
 }
 
 - (void)updateInterfaceWithReachability:(Reachability *)reachability
 {
 
     self.netStatus = [reachability currentReachabilityStatus];
     switch (self.netStatus) {
       case 0:
//         NSLog(@"NotReachable----无网络");
         break;
 
       case 1:
//         NSLog(@"ReachableViaWiFi----WIFI");
         break;
 
       case 2:
//         NSLog(@"ReachableViaWWAN----蜂窝网络");
         break;
 
       default:
         break;
 }
 
 }
 - (void)dealloc
 {
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
 }

@end
