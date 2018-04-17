//
//  HB_ContactDetailGroupManageCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/9/17.
//
//

#import "HB_ContactDetailGroupManageCell.h"

@interface HB_ContactDetailGroupManageCell ()
/** 底部细线 */
@property(nonatomic,retain)UILabel *line;

@end

@implementation HB_ContactDetailGroupManageCell

#pragma mark - life cycle
- (void)dealloc {
    [_groupNameLabel release];
    [_selectedImageView release];
    [super dealloc];
}
-(void)awakeFromNib{
    [self.contentView addSubview:self.line];
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    //设置右侧选中按钮是否隐藏
    self.selectedImageView.hidden=!selected;
    //保持contentView永远在最前面，对一些不必要的控件进行遮挡
    [self bringSubviewToFront:self.contentView];
}
-(BOOL)shouldIndentWhileEditing{
    //编辑状态禁止压缩，也就是禁止cell的contentView的右移动
    return NO;
}
/**
 *  快速创建cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_ContactDetailGroupManageCell";
    HB_ContactDetailGroupManageCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[[[NSBundle mainBundle]loadNibNamed:@"HB_ContactDetailGroupManageCell" owner:self options:nil]lastObject] autorelease];
    }
    return cell;
}
#pragma mark - setter and getter 
-(UILabel *)line{
    if (!_line) {
        _line=[[UILabel alloc]init];
        _line.frame=CGRectMake(15, self.bounds.size.height-0.5, self.bounds.size.width-30, 0.5);
        _line.backgroundColor=COLOR_H;
    }
    return _line;
}
@end
