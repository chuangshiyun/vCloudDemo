//
//  CYChooseRolesCell.h
//  ChuangRtcDemo
//

#import <UIKit/UIKit.h>
#import "CYRoleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CYChooseRolesCell : UITableViewCell

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *roomIdLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) CYRoleModel *roleModel;

@end

NS_ASSUME_NONNULL_END
