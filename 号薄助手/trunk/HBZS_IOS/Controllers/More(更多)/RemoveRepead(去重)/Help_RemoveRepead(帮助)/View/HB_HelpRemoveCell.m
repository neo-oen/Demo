//
//  HB_HelpRemoveCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/17.
//
//

#import "HB_HelpRemoveCell.h"

@interface HB_HelpRemoveCell ()
/**
 *  信息展示label
 */
@property(nonatomic,retain)UILabel * contentlabel;
/**
 *  细线
 */
@property(nonatomic,retain)UILabel * lineLabel;

@end

@implementation HB_HelpRemoveCell
-(void)dealloc{
    [_contentlabel release];
    [_lineLabel release];
    [super dealloc];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_HelpRemoveCell";
    HB_HelpRemoveCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[[HB_HelpRemoveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setupSubViews];
    }
    return cell;
}
/**
 *  添加子控件
 */
-(void)setupSubViews{
    UILabel * contentlabel=[[UILabel alloc]init];
    contentlabel.font=[UIFont systemFontOfSize:15];
    contentlabel.numberOfLines=0;
    contentlabel.textColor=COLOR_D;
    [self.contentView addSubview:contentlabel];
    self.contentlabel=contentlabel;
    [contentlabel release];
    //添加细线
    UILabel * label=[[UILabel alloc]init];
    label.backgroundColor=COLOR_H;
    [self.contentView addSubview:label];
    self.lineLabel=label;
    [label release];
}
-(void)setModel:(HB_HelpGroupModel *)model{
    _model = model;
    self.contentlabel.text=model.answer;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //布局label
    CGFloat label_X=30;
    CGFloat label_Y=0;
    CGFloat label_W=SCREEN_WIDTH - label_X * 2;
    CGFloat label_H=self.contentView.bounds.size.height;    
    self.contentlabel.frame=CGRectMake(label_X, label_Y, label_W, label_H);
    //细线
    CGFloat line_X=15;
    CGFloat line_W=self.contentView.bounds.size.width-line_X*2;
    CGFloat line_H=0.5;
    CGFloat line_Y=self.contentView.bounds.size.height-line_H;
    self.lineLabel.frame=CGRectMake(line_X, line_Y, line_W, line_H);
}
@end
