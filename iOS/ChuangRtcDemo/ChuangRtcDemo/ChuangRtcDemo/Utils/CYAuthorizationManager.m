//
//  CYAuthorizationManager.m
//  CYLiveVideoSDK
//
//  Created by zyh on 2020/1/13.
//  Copyright © 2020 chuangshiyun. All rights reserved.
//

#import "CYAuthorizationManager.h"
#import <UIKit/UIKit.h>

@implementation CYAuthorizationManager
 /**
  检测录制视频的相机是否授权
   */
 + (BOOL)checkVideoCameraAuthorization
 {
      __block BOOL isAvalible = NO;
      __weak __typeof__(self) weakSelf = self;
      AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
      switch (status) {
          case AVAuthorizationStatusAuthorized: //授权
          {
              isAvalible = YES;
          }
          break;
          case AVAuthorizationStatusDenied:   //拒绝，弹框
          {
             [self showWithMessage:@"需要您授权本App打开相机\n设置方法:打开手机设置->隐私->相机"];
             isAvalible = NO;
         }
         break;
         case AVAuthorizationStatusNotDetermined:   //没有决定，第一次启动默认弹框
         {
             dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            //点击弹框授权
             [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                 isAvalible = granted;
                 dispatch_semaphore_signal(sema);
                 if(!granted)  //如果不允许
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                    
                         [weakSelf gotoSetting];
                 });
             }
             }];
             dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
         break;
         case AVAuthorizationStatusRestricted:  //受限制，家长控制器
         isAvalible = NO;
         break;
     }
     
     return isAvalible;
 }
 //弹框提示
 + (void)showWithMessage:(NSString *)tipString
  {
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipString message:nil preferredStyle:UIAlertControllerStyleAlert];
      [alert addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
          [self gotoSetting];
          
      }]];
      
      [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
      
      NSArray *windows = [UIApplication sharedApplication].windows;
      NSInteger windowCount = windows.count;
      UIWindow *keyWindow;
      Class cls = NSClassFromString(@"UITextEffectsWindow");
      if ([windows.lastObject isKindOfClass:cls]) {
          keyWindow = windows[windowCount - 2];
      }else{
          keyWindow = windows.lastObject;
      }
      
      [keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
          
      }];
     
 }
//引导到设置页面去设置
 + (void)gotoSetting
 {
     NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
     if([[UIApplication sharedApplication] canOpenURL:url]){
         if (@available(iOS 10, *)) {
             [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                 
             }];
         } else {
              [[UIApplication sharedApplication] openURL:url];
         }
    
     }
 }

/**
 检测录制视频的麦克风是否授权
 */
+ (BOOL)checkVideoMicrophoneAudioAuthorization
{
    __block BOOL isAvalible = NO;
    __weak __typeof__(self) weakSelf = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusAuthorized: //授权
        isAvalible = YES;
            return YES;
        break;
        case AVAuthorizationStatusDenied:   //拒绝，弹框
        {
            [self showWithMessage:@"需要您授权本App打开麦克风\n设置方法:打开手机设置->隐私->麦克风"];
            isAvalible = NO;
            return NO;
        }
        break;
        case AVAuthorizationStatusNotDetermined:   //没有决定，第一次启动
        {
             dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            //点击弹框授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                isAvalible = granted;
                dispatch_semaphore_signal(sema);
                if(!granted)  //如果不允许
                {
                    //回到主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf gotoSetting];
                    });
                }else{
//                    NSLog(@"点击了允许maikefeng ");
                }
                
            }];
           
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
            break;
        case AVAuthorizationStatusRestricted:  //受限制，家长控制器
            isAvalible = NO;
            break;
    }
    return isAvalible;
}
- (void)requestCaptureAuthorizationByMediaType:(AVMediaType)mediaType successBlock:(void(^)(void))successBlock failture:(void(^)(void))failtureBlock{
     // 监测授权
     switch ([AVCaptureDevice authorizationStatusForMediaType:mediaType]) {
       //已授权，可使用
        case AVAuthorizationStatusAuthorized:{
            if (successBlock) {
                successBlock();
            }
            break;
        }
        //未授权，请选择
        case AVAuthorizationStatusNotDetermined:{
            //再次请求授权
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                //用户授权成功
                if (granted) {
                    if (successBlock) {
                        successBlock();
                    }
                //用户拒绝授权
                }else{
                    if (failtureBlock) {
                        failtureBlock();
                    }
                }
            }];
            break;
        }
        //用户拒绝授权(AVAuthorizationStatusDenied)、未授权
        default:{
            if (failtureBlock) {
                failtureBlock();
            }
        }
        break;
    }
}

@end
