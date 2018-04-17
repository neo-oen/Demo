//
//  HB_SettingOptionCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/12.
//
//

#import "HB_SettingOptionCell.h"

@interface HB_SettingOptionCell ()<UITextFieldDelegate>
/**
 *  右侧箭头
 */
@property(nonatomic,retain)UIImageView * arrowImageView;


@end
@implementation HB_SettingOptionCell
-(void)dealloc{
    [_arrowImageView release];
    [_textfield release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"HB_SettingOptionCell";
    HB_SettingOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[[HB_SettingOptionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str] autorelease];
        [cell setupSubViews];
    }
    return cell;
}
/**
 *  设置子控件
 */
-(void)setupSubViews{
    [super setupSubViews];
    //右侧箭头
    UIImageView * arrow=[[UIImageView alloc]init];
    arrow.image=[UIImage imageNamed:@"普通箭头-List"];
    arrow.contentMode=UIViewContentModeCenter;
    [self.contentView addSubview:arrow];
    self.arrowImageView=arrow;
    [arrow release];
    //右侧tf
    UITextField * textfield=[[UITextField alloc]init];
    textfield.textColor=COLOR_D;
    textfield.delegate=self;
    textfield.textAlignment=NSTextAlignmentRight;
    textfield.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:textfield];
    self.textfield=textfield;
    [textfield release];
}
-(void)setModel:(HB_SettingOptionCellModel *)model{
    _model=model;
    //名字
    self.nameLabel.text=model.name;
    //右侧tf
    self.textfield.text=model.rightString;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //右侧箭头
    CGFloat arrow_W=20;
    CGFloat arrow_H=self.contentView.bounds.size.height;
    CGFloat arrow_X=self.contentView.bounds.size.width-Padding-arrow_W;
    CGFloat arrow_Y=0;
    self.arrowImageView.frame=CGRectMake(arrow_X, arrow_Y, arrow_W, arrow_H);
    //右侧tf
    CGFloat label_W=80;
    CGFloat label_H=self.contentView.bounds.size.height;
    CGFloat label_X=CGRectGetMinX(_arrowImageView.frame)-label_W;
    CGFloat label_Y=0;
    self.textfield.frame=CGRectMake(label_X, label_Y, label_W, label_H);
}
#pragma mark - textfield的代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(settingOptionCell:textFieldBeginEdit:)]) {
        [self.delegate settingOptionCell:self textFieldBeginEdit:textField];
    }
}

@end
