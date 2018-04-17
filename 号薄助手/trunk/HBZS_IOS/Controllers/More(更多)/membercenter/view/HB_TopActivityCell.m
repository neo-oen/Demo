//
//  HB_TopActivityCell.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/19.
//
//

#import "HB_TopActivityCell.h"
#import "GetSysMsgProto.pb.h"
#import "UIImageView+WebCache.h"

@implementation HB_TopActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    // Initialization code
}
- (IBAction)moreClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(TopActivityCell:clickwithIndex:)]) {
        [self.delegate TopActivityCell:self clickwithIndex:0];
    }
}

-(void)setdataWith:(SysMsg *)msg
{
    if (msg) {
        [self.topimageView setImageWithURL:[NSURL URLWithString:msg.imgContentUrl1]];
        self.infoLabel.text = msg.content;
        
    }
    else
    {
        self.topimageView.image = [UIImage imageNamed:@"NoHotActivity"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_topimageView release];
    [_infoLabel release];
    [super dealloc];
}
@end
