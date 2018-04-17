//
//  HB_ContactDetailPhoneEmailTypeCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/10/14.
//
//

#import "HB_ContactDetailPhoneEmailTypeCell.h"

@implementation HB_ContactDetailPhoneEmailTypeCell
-(void)dealloc{
    [_typeNameLabel release];
    [_selectedImageView release];
    [super dealloc];
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    //设置右侧选中按钮是否隐藏
    self.selectedImageView.hidden=!selected;
}
-(BOOL)shouldIndentWhileEditing{
    //编辑状态禁止压缩，也就是禁止cell的contentView的右移动
    return NO;
}

/**
 *  快速创建cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_ContactDetailPhoneEmailTypeCell";
    HB_ContactDetailPhoneEmailTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[[[NSBundle mainBundle]loadNibNamed:@"HB_ContactDetailPhoneEmailTypeCell" owner:self options:nil]lastObject] autorelease];
        //设置背景为透明无色的
        UIView * selectedBackgroundView=[[UIView alloc]init];
        selectedBackgroundView.backgroundColor=[UIColor clearColor];
        [cell setSelectedBackgroundView:selectedBackgroundView];
        [selectedBackgroundView release];
    }
    return cell;
}


@end
