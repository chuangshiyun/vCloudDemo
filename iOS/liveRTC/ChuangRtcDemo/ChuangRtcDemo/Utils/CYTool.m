//
//  CYTool.m
//  LiveVieoDemo
//
//  Created by zyh on 2019/11/19.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYTool.h"
#import "CYAPIHeader.h"

@implementation CYTool

+ (void)configUserSetInfo{
       NSString *resolution = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigResolutionKey]];
       NSString *fps = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigFpsKey]];
       NSString *bitrate = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigBitrateKey]];
       NSString *previewViewMode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigPreviewViewModeKey]];
       NSString *hardwareEncode = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigEnableHardwareEncodeKey]];
       NSString *PreviewMinnor = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:CYPublishConfigPreviewMinnorKey]];
    if (isEmpty(resolution)) {
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:CYPublishConfigResolutionKey];
    }
    if (isEmpty(fps)) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:CYPublishConfigFpsKey];
    }
    if (isEmpty(bitrate)) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:CYPublishConfigBitrateKey];
    }
    if (isEmpty(previewViewMode)) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:CYPublishConfigPreviewViewModeKey];
    }
    if (isEmpty(hardwareEncode)) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:CYPublishConfigEnableHardwareEncodeKey];
    }
    if (isEmpty(PreviewMinnor)) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:CYPublishConfigPreviewMinnorKey];
    }
    
}
//生成指定长度的随机字符串
+ (NSString *)randomStringWithLength:(NSInteger)length
{
    NSString *letters = @"0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    
    for (NSInteger i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    return randomString;
}
+ (BOOL)judgeIllegalOfCharacter:(NSString *)string{
   NSString *str =@"^[A-Za-z0-9-_]+$";
   NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
   if (![emailTest evaluateWithObject:string]) {
   return YES;
   }
   return NO;
}

+(NSString *)currentdateInterval
{
    NSDate *nowdate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *strDate = [dateFormatter stringFromDate:nowdate];
    return strDate;
}


@end
BOOL isEmpty(id aItem) {
    return aItem == nil || ([aItem isKindOfClass:[NSNull class]]) || (([aItem respondsToSelector:@selector(length)]) && ([aItem length] == 0)) || (([aItem respondsToSelector:@selector(length)]) && ([aItem length] == 0)) || (([aItem respondsToSelector:@selector(count)]) && ([aItem count] == 0));
}
