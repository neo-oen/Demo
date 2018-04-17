//
//  HB_GroupNameCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/14.
//
//

#import "HB_GroupNameCell.h"


@interface HB_GroupNameCell ()
/**
 *  分组名字
 */
@property(nonatomic,retain)UILabel * groupNameLabel;
/**
 *  底部细线
 */
@property(nonatomic,retain)UILabel * lineLabel;


@end

@implementation HB_GroupNameCell

-(void)dealloc{
    [_groupNameLabel release];
    [_groupItem release];
    [_lineLabel release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * str=@"HB_GroupNameCell";
    HB_GroupNameCell * cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str]autorelease];
        cell.backgroundColor=[UIColor clearColor];
        [cell setupSubView];
    }
    return cell;
}
/**
 *  添加cell的子控件
 */
-(void)setupSubView{
    //中央的label
    _groupNameLabel=[[UILabel alloc]init];
    _groupNameLabel.font=[UIFont systemFontOfSize:16];
    _groupNameLabel.textColor= COLOR_D;
    _groupNameLabel.textAlignment=NSTextAlignmentCenter;
    [self.contentView addSubview:_groupNameLabel];
    //底部细线
    _lineLabel=[[UILabel alloc]init];
    _lineLabel.textColor=[UIColor clearColor];
    _lineLabel.backgroundColor=COLOR_H;
    [self.contentView addSubview:_lineLabel];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _groupNameLabel.frame = self.bounds;
    _lineLabel.frame = CGRectMake(0, self.contentView.bounds.size.height-0.5, self.contentView.bounds.size.width, 0.5);
}
-(void)setGroupItem:(HB_GroupModel *)groupItem{
    if (_groupItem != groupItem) {
        [_groupItem release];
        _groupItem=[groupItem retain];
    }
    self.groupNameLabel.text=groupItem.groupName;
}


@end
