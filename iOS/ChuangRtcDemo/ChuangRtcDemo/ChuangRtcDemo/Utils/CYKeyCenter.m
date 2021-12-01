//
//  CYKeyCenter.m
//  LiveVieoDemo
//
//  Created by zyh on 2019/11/28.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYKeyCenter.h"
#import <ChuangRtcKit/ChuangRtcKit.h>
#import "CYTool.h"
#import "CYPublishTopicConfigManager.h"


@implementation CYKeyCenter

//appId：从官网主页申请得到
+ (NSString *)appId {
    return <#请输入您申请的AppId#>;
}
//appKey：从官网主页申请得到
+ (NSString *)appKey{
    return <#请输入您申请的AppKey#>;
}

//以下都是根据自己实际rtmp部署配置地址填写,注：如不打算推rtmp流，则只需传 nil 或 @"" 即可。如果需要推rtmp流，则必须传如下rtmp参数
+ (NSString *)rtmpAddr{
    return @"";
}

//注：如不打算混流，则只需传 nil 或 @"" 即可,如果需要混流，则必须传如混流配置地址等信息
+ (NSString *)mixRtmpAddr{
    return @"";
}

+ (NSInteger)mixOutputResolution{
    return   ChuangMixOutputResolution432X768;
}
//混流码率(kbps)，推荐4G：600，WIFI：1000
+ (NSUInteger)mixOutputRtmpBitrateKBps{
    return  800;
}

@end
