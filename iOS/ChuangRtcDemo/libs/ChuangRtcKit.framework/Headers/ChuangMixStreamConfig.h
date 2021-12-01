//
//  ChuangMixStreamConfig.h
//  ChuangRtcKit
//
//  Created by wzh on 2021/5/13.
//  Copyright © 2021 chuangcache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangEnumerates.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @brief 混流水印
 */
@interface ChuangMixStreamWatermark : NSObject
/*!
 @brief 水印图片
 */
@property (nonatomic, copy) NSString *image;
/*!
 @brief rect
 */
@property (nonatomic, assign) CGRect rect;
@end


@interface ChuangMixStreamInfo : NSObject
/*!
@brief （混流信息）用户所推的原视频流的流Id
*/
@property (nonatomic, copy) NSString *streamId;
/*!
 @brief 混流宽
 */
@property (nonatomic, assign) int width;
/*!
 @brief 混流高
 */
@property (nonatomic, assign) int height;
/*!
 @brief 图层
 */
@property (nonatomic, assign) int zlevel;
/*!
 @brief 目标rect
 */
@property (nonatomic, assign) CGRect dstRect;

/*!
 @brief 是否混入该路流视频，YES:代表混入该用户所推视频，NO:代表不混入该用户所推视频,默认YES
 */
@property (nonatomic, assign) BOOL mixVideo;

/*!
 @brief 视频显示模式
 */
@property (nonatomic, assign) ChuangVideoRenderMode renderMode;
/*!
 @brief 视频流方向
 */
@property (nonatomic, assign) ChuangStreamRotation rotation;

@end



@interface ChuangMixStreamConfig : NSObject

/*!
 @brief 【必传】混流地址
 */
@property (nonatomic, copy) NSString *target;
/*!
 @brief 【必传】混流宽
 */
@property (nonatomic, assign) int width;
/*!
 @brief 【必传】混流高
 */
@property (nonatomic, assign) int height;
/*!
 @brief 【必传】 混流后的视频比特率（单位：kbps）
 */
@property (nonatomic, assign) int videoBitrateKbps;
/*!
 @brief 背景图
 */
@property (nonatomic, copy) NSString *backgroundImage;
/*!
 @brief 是否通知房间内其他用户此房间内存在一个混流
 */
@property (nonatomic, assign) BOOL noticeStream;
/*!
 @brief 混流水印
 */
@property (nonatomic, strong) ChuangMixStreamWatermark *mixStreamWatermark;

/*!
@brief 【必传】 参与混流的流信息列表  详情参照ChuangMixStreamInfo
*/
@property (nonatomic, strong) NSMutableArray <ChuangMixStreamInfo *> *mixStreams;

@end

NS_ASSUME_NONNULL_END
