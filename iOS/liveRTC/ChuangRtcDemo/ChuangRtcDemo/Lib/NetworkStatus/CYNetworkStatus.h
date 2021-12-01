//
//  CYNetworkStatus.h
//  ChuangRtcDemo
//


#import <Foundation/Foundation.h>
#import "Reachability.h"
NS_ASSUME_NONNULL_BEGIN

@interface CYNetworkStatus : NSObject

@property (nonatomic, assign) NetworkStatus netStatus;

+ (instancetype)sharedSingleton;

- (void)startListenNetWorkingStatus;

@end

NS_ASSUME_NONNULL_END
