//
//  CYCellManager.h
//  ChuangRtcDemo
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYCellManager : NSObject

@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *type;

- (instancetype)initWithIdentifier:(NSString *)cellIdentifier data:(id)data type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
