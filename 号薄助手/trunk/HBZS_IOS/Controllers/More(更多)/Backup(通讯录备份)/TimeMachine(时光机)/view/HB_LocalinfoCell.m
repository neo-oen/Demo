//
//  HB_LocalinfoCell.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/5/16.
//
//

#import "HB_LocalinfoCell.h"

@implementation HB_LocalinfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_localCount release];
    [super dealloc];
}
@end
