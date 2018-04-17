//
//  HB_MoreVCCollectionCell.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/4/13.
//
//

#import "HB_MoreVCCollectionCell.h"
@implementation HB_MoreVCCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HB_MoreCellModel *)model{
    _model=model;
    //图标
    if (model.icon) {
        self.leftImageView.image=model.icon;
    }
    //name
    self.titleLabel.text=model.nameStr;
}

- (void)dealloc {
    [_leftImageView release];
    [_titleLabel release];
    [super dealloc];
}
@end
