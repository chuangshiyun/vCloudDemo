//
//  ChuangStreamConfig.h
//  ChuangRtcKit
//
//  Created by wzh on 2021/5/13.
//  Copyright © 2021 chuangcache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangEnumerates.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChuangStreamConfig : NSObject
/*!
 @brief 流的唯一标识
 */
@property (nonatomic, copy) NSString *streamId;
/*!
@brief 流信息类型，详情参照ChuangStreamMode   0:音视频，1:纯音频，默认0音视频
*/
@property (nonatomic, assign) ChuangStreamMode streamMode;

/*!
@brief 【可选】 rtmpAddress 备用 rtmp 推流地址： (备用 rtmp 推流域名 + 备用 rtmp 推流端口+备用 rtmp 推流应用名 +备用 rtmp 推流流名称) ,rtmp推流需要传，不rtmp推流则不用传。
 
 注：如不打算推rtmp流，则只需将 rtmpAddress这 个参数传 nil 或 @"" 即可，
*/
@property (nonatomic, strong) NSString *rtmpAddress;


@end

NS_ASSUME_NONNULL_END
