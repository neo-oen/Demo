//
//  HB_MergerHeaderCollectionItemCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/9/11.
//
//

#import "HB_MergerHeaderCollectionItemCell.h"

@implementation HB_MergerHeaderCollectionItemCell

- (void)awakeFromNib {

}

- (void)dealloc {
    [_headerImageView release];
    [_bgImageView release];
    [super dealloc];
}
@end
