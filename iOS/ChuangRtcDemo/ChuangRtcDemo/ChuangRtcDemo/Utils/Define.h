//
//  Define.h
//  ChuangRtcDemo
//
//  Created by wzh on 2021/5/24.
//

#ifndef Define_h
#define Define_h


#define SCREEN_WIDTH            ([UIScreen mainScreen].nativeBounds.size.width / [UIScreen mainScreen].nativeScale)
#define SCREEN_HEIGHT           ([UIScreen mainScreen].nativeBounds.size.height / [UIScreen mainScreen].nativeScale)

//宽高比系数计算(宽高必须是按4.7寸屏给出的)
#define K_Width(width)      (width/(double)375)*SCREEN_WIDTH
#define K_Height(height)    (height /(double)667)*SCREEN_HEIGHT

//16进制颜色转换
#define UIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define MakeRGBColor(r, g, b, a) ([UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a])


// 页面背景色（灰）#F8F9FA  0xf5f5f5
#define SMViewBGColor        UIColorFromHex(0xF9F9F9)
// MakeRGBColor(50, 96, 246, 1.0)
#define SMThemeColor         [UIColor whiteColor]


#define SMThemeBackBtnColor  MakeRGBColor(82, 85, 89, 1.0)
#define SMThemeTitleColor    [UIColor blackColor]

// iPhone X 刘海屏
#define K_IS_IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[[UIApplication sharedApplication] windows] firstObject].safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
// iPhone
#define K_IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
// iPad
#define K_IS_PAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// iPhone  刘海屏状态栏高度
#define K_IPHONE_X_STATUS_BAR_HEIGHT   44

//
#define K_HOME_INDICATOR_HEIGHT     (K_IS_IPHONE_X ? 34 : 0)

#define K_STATUS_BAR_HEIGHT         (K_IS_IPHONE_X ? 44 : 20)

#define K_NAVIGATION_HEIGHT         (K_STATUS_BAR_HEIGHT + 44)

#define  K_TABBAR_HEIGHT            (K_IS_IPHONE_X ? (49.f+34.f) : 49.f)

#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define K_REGULAR_FONT(X) IOS9_OR_LATER ? [UIFont fontWithName:@"PingFangSC-Regular" size:X] : [UIFont systemFontOfSize:X weight:UIFontWeightRegular]

#define BLOCK_EXEC(block, ...) \
if (block) {               \
    block(__VA_ARGS__);    \
};

#define SAFE_CALL(obj, method) \
    ([obj respondsToSelector:@selector(method)] ? [obj method] : nil)
#define SAFE_CALL_OneParam(obj, method, firstParam) \
    ([obj respondsToSelector:@selector(method:)] ? [obj method:firstParam] : nil)
#endif /* Define_h */
