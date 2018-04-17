//
//  UIButton+Extension.m
//  HBZS_IOS
//
//  Created by zimbean on 14-8-7.
//
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

static char kUITableViewCellIndexPathKey;

@implementation UIButton (Extension)

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, kUITableViewCellIndexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath {
    id obj = objc_getAssociatedObject(self,kUITableViewCellIndexPathKey);
    if([obj isKindOfClass:[NSIndexPath class]]) {
        return (NSIndexPath *)obj;
    }
    return nil;
}


@end
