//
//  HB_ContactDetailArrowCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//
#define Padding 15  //控件之间的间距

#import "HB_ContactDetailArrowCell.h"

@interface HB_ContactDetailArrowCell()
/** 图标 */
@property(nonatomic,retain)UIImageView *iconImageView;
/** 底部细线 */
@property(nonatomic,retain)UILabel *bottomLineLabel;
/** 选项名称 */
@property(nonatomic,retain)UITextField *nameTextField;
/** 右侧箭头 */
@property(nonatomic,retain)UIImageView *arrowImageView;
@end

@implementation HB_ContactDetailArrowCell
-(void)dealloc{
    [_model release];
    [_iconImageView release];
    [_bottomLineLabel release];
    [_nameTextField release];
    [_arrowImageView release];
    [super dealloc];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * identify=@"HB_ContactDetailArrowCell";
    HB_ContactDetailArrowCell * cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setupSubViews];
    }
    return cell;
}

-(void)setModel:(HB_ContactDetailArrowCellModel *)model{
    if(_model != model){
        [_model release];
        _model = [model retain];
    }
    //图标
    _iconImageView.image = _model.icon;
    //属性名字
    _nameTextField.placeholder = _model.placeHolder;
    //属性值
    _nameTextField.text = _model.listModel.groupsName;
}
/**
 *  添加子控件
 */
-(void)setupSubViews{
    //图标
    _iconImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:_iconImageView];
    //选项名字
    _nameTextField=[[UITextField alloc]init];
    _nameTextField.userInteractionEnabled=NO;
    _nameTextField.textColor=COLOR_D;
    _nameTextField.font=[UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameTextField];
    //底部细线
    _bottomLineLabel=[[UILabel alloc]init];
    _bottomLineLabel.backgroundColor=COLOR_H;
    _bottomLineLabel.textColor=[UIColor clearColor];
    [self.contentView addSubview:_bottomLineLabel];
    //右侧箭头
    _arrowImageView=[[UIImageView alloc]init];
    _arrowImageView.image=[UIImage imageNamed:@"右箭头"];
    [self.contentView addSubview:_arrowImageView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //图标
    CGFloat iconImageView_H=20;
    CGFloat iconImageView_W=iconImageView_H;
    CGFloat iconImageView_X=15;
    CGFloat iconImageView_Y=self.contentView.bounds.size.height * 0.5 - iconImageView_H*0.5;
    _iconImageView.frame=CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);
    //右侧箭头
    CGFloat arrowImageView_H=20;
    CGFloat arrowImageView_W=arrowImageView_H;
    CGFloat arrowImageView_X=self.contentView.bounds.size.width - Padding - arrowImageView_W;
    CGFloat arrowImageView_Y=self.contentView.bounds.size.height * 0.5 - arrowImageView_H*0.5;
    _arrowImageView.frame=CGRectMake(arrowImageView_X, arrowImageView_Y, arrowImageView_W, arrowImageView_H);
    
    //选项名字
    CGFloat nameTextField_H=self.contentView.bounds.size.height;
    CGFloat nameTextField_X=CGRectGetMaxX(_iconImageView.frame) + Padding;
    CGFloat nameTextField_Y=0;
    CGFloat nameTextField_W=CGRectGetMinX(_arrowImageView.frame) - nameTextField_X - Padding;
    _nameTextField.frame=CGRectMake(nameTextField_X, nameTextField_Y, nameTextField_W, nameTextField_H);
    //底部细线
    CGFloat bottomLineLabel_X=iconImageView_X ;
    CGFloat bottomLineLabel_W=self.contentView.bounds.size.width - bottomLineLabel_X * 2;
    CGFloat bottomLineLabel_H=0.5;
    CGFloat bottomLineLabel_Y=self.contentView.bounds.size.height - bottomLineLabel_H;
    _bottomLineLabel.frame=CGRectMake(bottomLineLabel_X, bottomLineLabel_Y, bottomLineLabel_W, bottomLineLabel_H);
}
@end
