//
//  HB_netMsgSearchCell.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/12/13.
//

#import "HB_netMsgSearchCell.h"
#import "AreaQuery.h"
@implementation HB_netMsgSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"netMsgSearchCell";
    HB_netMsgSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
//        cell=[[[self alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str] autorelease];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HB_netMsgSearchCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

-(void)setModel:(HB_ContactSimpleModel *)model
{
    self.namelabel.text = model.name;
    NSMutableAttributedString * phonestr = [[NSMutableAttributedString alloc] initWithString:model.showNumber];
    if (model.colorRange.length) {
        [phonestr addAttribute:NSForegroundColorAttributeName value:COLOR_A   range:model.colorRange];
    }
    self.numberLabel.attributedText = phonestr;
    
    self.QcellCorelabel.text = [[AreaQuery getInstance]queryAreaByNumber:model.showNumber];
    
}
- (void)dealloc {
    [_namelabel release];
    [_numberLabel release];
    [_QcellCorelabel release];
    [super dealloc];
}
@end
