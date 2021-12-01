//
//  RtcViewController.h
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/17.
//

#import <UIKit/UIKit.h>
#import <ChuangRtcKit/ChuangRtcKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYRtcViewController : UIViewController
@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *localStreamId;
@property (nonatomic, assign) ChuangUserRole role;
@end

NS_ASSUME_NONNULL_END
