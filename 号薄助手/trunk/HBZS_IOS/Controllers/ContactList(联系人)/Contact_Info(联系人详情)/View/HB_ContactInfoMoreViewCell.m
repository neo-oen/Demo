//
//  HB_ContactInfoMoreViewCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/29.
//
//

#import "HB_ContactInfoMoreViewCell.h"

@interface HB_ContactInfoMoreViewCell ()

/**
 *  细线
 */
@property(nonatomic,retain)UILabel *lineLabel;


@end

@implementation HB_ContactInfoMoreViewCell
-(void)dealloc{
    [_nameLabel release];
    [_lineLabel release];
    [super dealloc];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * identifyStr=@"HB_ContactInfoMoreViewCell";
    HB_ContactInfoMoreViewCell * cell=[tableView dequeueReusableCellWithIdentifier:identifyStr];
    if (cell==nil) {
        cell=[[[HB_ContactInfoMoreViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyStr]autorelease];
        [cell setupSubViews];
    }
    return cell;
}
/**
 *  添加子控件
 */
-(void)setupSubViews{
    //1.添加label
    _nameLabel=[[UILabel alloc]init];
    _nameLabel.font=[UIFont systemFontOfSize:14];
    _nameLabel.textColor=COLOR_D;
    [self.contentView addSubview:_nameLabel];
    //2.添加细线
    _lineLabel=[[UILabel alloc]init];
    _lineLabel.textColor=[UIColor clearColor];
    _lineLabel.backgroundColor=COLOR_H;
    [self.contentView addSubview:_lineLabel];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //1.nameLabel
    CGFloat nameLabel_X=15;
    CGFloat nameLabel_Y=0;
    CGFloat nameLabel_W=self.bounds.size.width-nameLabel_X*2;
    CGFloat nameLabel_H=self.bounds.size.height;
    _nameLabel.frame=CGRectMake(nameLabel_X, nameLabel_Y, nameLabel_W, nameLabel_H);
    //2.细线
    CGFloat lineLabel_W=self.bounds.size.width;
    CGFloat lineLabel_H=0.5;
    CGFloat lineLabel_X=0;
    CGFloat lineLabel_Y=self.bounds.size.height-lineLabel_H;
    _lineLabel.frame=CGRectMake(lineLabel_X, lineLabel_Y, lineLabel_W, lineLabel_H);
}

@end
