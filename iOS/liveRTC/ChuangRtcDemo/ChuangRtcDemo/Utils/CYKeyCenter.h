//
//  CYKeyCenter.h
//  LiveVieoDemo
//
//  Created by zyh on 2019/11/28.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^resultBlock)(NSDictionary * _Nullable rtcId);

NS_ASSUME_NONNULL_BEGIN

@interface CYKeyCenter : NSObject
/**
本示例不提供 CYKeyCenter.m 需要用户自行实现,请提前在官网管理控制台获取 AppId 和appKey
 */
+ (NSString *)appId;
+ (NSString *)appKey;

//注：如不打算推rtmp流，则只需将以下rtmpAddr传nil 或 @"" 即可。【可选】
+ (NSString *)rtmpAddr;
//注：如不打算混流，则只需将mixRtmpAddr这个参数传 nil 或 @"" 即可 【可选】
+ (NSString *)mixRtmpAddr;
+ (NSInteger)mixOutputResolution;
+ (NSUInteger)mixOutputRtmpBitrateKBps;


@end

NS_ASSUME_NONNULL_END
