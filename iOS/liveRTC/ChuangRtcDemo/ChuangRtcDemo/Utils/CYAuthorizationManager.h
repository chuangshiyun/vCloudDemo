//
//  CYAuthorizationManager.h
//  CYLiveVideoSDK
//
//  Created by zyh on 2020/1/13.
//  Copyright © 2020 chuangshiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYAuthorizationManager : NSObject

 /**
 检测录制视频的相机是否授权
 */
+ (BOOL)checkVideoCameraAuthorization;
  /**
  检测录制视频的麦克风是否授权
  */
+ (BOOL)checkVideoMicrophoneAudioAuthorization;
/**
  请求权限
*/
- (void)requestCaptureAuthorizationByMediaType:(AVMediaType)mediaType successBlock:(void(^)(void))successBlock failture:(void(^)(void))failtureBlock;

@end

NS_ASSUME_NONNULL_END
