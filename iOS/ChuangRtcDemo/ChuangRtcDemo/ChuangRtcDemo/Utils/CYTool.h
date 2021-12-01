//
//  CYTool.h
//  LiveVieoDemo
//
//  Created by zyh on 2019/11/19.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYTool : NSObject
+ (void)configUserSetInfo;
+ (NSString *)randomStringWithLength:(NSInteger)length;
+ (BOOL)judgeIllegalOfCharacter:(NSString *)string;
+(NSString *)currentdateInterval;

@end

NS_ASSUME_NONNULL_END

#ifdef __cplusplus
extern "C" {
#endif
    BOOL isEmpty(id _Nullable aItem);
#ifdef __cplusplus
}
#endif
