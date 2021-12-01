//
//  CYPreSetVM.h
//  ChuangRtcDemo
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYPreSetVM : NSObject

@property (nonatomic, weak) UIViewController *VC;
@property (nonatomic, strong) UITableView *tableView;

- (void)backBtnClick; 

@end

NS_ASSUME_NONNULL_END
