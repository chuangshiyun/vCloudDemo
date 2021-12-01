//
//  CYCellManager.m
//  ChuangRtcDemo
//


#import "CYCellManager.h"

@implementation CYCellManager

- (instancetype)initWithIdentifier:(NSString *)cellIdentifier data:(id)data type:(NSString *)type {
    self = [super init];
    if (self) {
        self.cellIdentifier = cellIdentifier;
        self.data = data;
        self.type = type;
    }
    return self;
}

@end
