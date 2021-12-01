//
//  CYRoleModel.h
//  ChuangRtcDemo
//


#import <Foundation/Foundation.h>
#import <ChuangRtcKit/ChuangRtcKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CYRoleModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *bgImage;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) ChuangUserRole userRole;

@end

NS_ASSUME_NONNULL_END
