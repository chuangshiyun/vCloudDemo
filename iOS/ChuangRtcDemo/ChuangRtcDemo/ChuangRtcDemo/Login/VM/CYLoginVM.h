//
//  CYLoginVM.h
//  ChuangRtcDemo
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface CYLoginVM : NSObject

@property (nonatomic, weak) UIViewController *VC;
@property (nonatomic, strong) UIView *mainView;

- (void)layoutSubViews;

@end

NS_ASSUME_NONNULL_END
