//
//  MessageCell.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/9/10.
//
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
    self.headImageView.layer.cornerRadius = RATE*25;
    self.isRead.layer.cornerRadius = 2.5f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(void)setMessageType:(BOOL)isRead
{
    self.isRead.hidden = isRead;
}

- (void)dealloc {
    [_titleLabel release];
    [_contectLabel release];
    [_timeLabel release];
    [_headImageView release];
    [_isRead release];
    [super dealloc];
}
@end
