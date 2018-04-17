//
//  HB_HotActivityCell.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/20.
//
//

#import "HB_HotActivityCell.h"
#import "UIImageView+WebCache.h"
@implementation HB_HotActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setdata:(SysMsg *)msg
{
    [self.heardImageView setImageWithURL:[NSURL URLWithString:msg.imgContentUrl1]];
    self.timeLabel.text = [[msg.startDate componentsSeparatedByString:@" "] firstObject];
    self.readcount.text = [NSString stringWithFormat:@"%lu人阅读",msg.readAmount.integerValue];
    self.contectLabel.text = msg.content;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_timeLabel release];
    [_readcount release];
    [_heardImageView release];
    [_contectLabel release];
    [super dealloc];
}
@end
