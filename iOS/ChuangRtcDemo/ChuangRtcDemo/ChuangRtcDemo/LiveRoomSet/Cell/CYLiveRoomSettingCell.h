//
//  CYLiveRoomSettingCell.h
//  ChuangRtcDemo
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OpenCallBlock)(BOOL isOpen);

@interface CYLiveRoomSettingCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *rigthSwitch;

@property (nonatomic, copy) OpenCallBlock openCallBlock;

@end

NS_ASSUME_NONNULL_END
