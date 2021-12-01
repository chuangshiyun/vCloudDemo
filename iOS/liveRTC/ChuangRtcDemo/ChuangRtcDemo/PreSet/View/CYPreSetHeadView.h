//
//  CYPreSetHeadView.h
//  ChuangRtcDemo
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OpenCallBlock)(BOOL isOpen);

@interface CYPreSetHeadView : UITableViewHeaderFooterView

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy) OpenCallBlock openCallBlock;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UISwitch *rigthSwitch;

@end

NS_ASSUME_NONNULL_END
