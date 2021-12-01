//
//  CYSetTextInfoTableViewCell.h
//  LiveVieoDemo
//
//  Created by zyh on 2019/12/5.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CYSetTextInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableDictionary *infoDic;
@property (nonatomic, copy) void(^changeTextBlock)(NSString *newText, NSString *key);

@end

NS_ASSUME_NONNULL_END
