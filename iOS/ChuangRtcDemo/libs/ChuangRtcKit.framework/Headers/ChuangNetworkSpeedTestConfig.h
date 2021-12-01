//
//  ChuangNetworkSpeedTestConfig.h
//  ChuangRtcKit
//
//  Created by wzh on 2021/5/14.
//  Copyright © 2021 chuangcache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangEnumerates.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChuangNetworkSpeedQuality : NSObject
/*!
 @brief 连接耗时
 */
@property (nonatomic, assign) int connectCost;
/*!
 @brief 往返延迟
 */
@property (nonatomic, assign) int rtt;
/*!
 @brief 延迟抖动
 */
@property (nonatomic, assign) int rttVar;
/*!
 @brief 丢包率
 */
@property (nonatomic, assign) double packetLost;
/*!
 @brief 测速状态
 */
@property (nonatomic, assign) ChuangNetworkSpeedTestState state;
/*!
 @brief 可用带宽, 单位Kbps
 */
@property (nonatomic, assign) int availableBndWidthKbps;
@end

@interface ChuangNetworkSpeedTestConfig : NSObject
/*!
 @brief 上行测速
 */
@property (nonatomic, assign) BOOL testUpLink;
/*!
 @brief 预期的上行网速 单位 Kbps 范围：10-10000
 */
@property (nonatomic, assign) int expectedUpLinkBitrateKbps;
/*!
 @brief 下行测速
 */
@property (nonatomic, assign) BOOL testDownLink;
/*!
 @brief 预期的下行网速 单位 Kbps 范围：10-10000
 */
@property (nonatomic, assign) int exceptedDownLinkBitrateKbps;
@end

NS_ASSUME_NONNULL_END
