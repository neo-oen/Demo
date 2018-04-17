//
//  HB_ContactDetailCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//
#define Padding 15  //控件之间的间距

#import "HB_ContactDetailCell.h"

@interface HB_ContactDetailCell ()<UITextFieldDelegate>

/** 图标 */
@property(nonatomic,retain)UIImageView *iconImageView;
/** 底部细线 */
@property(nonatomic,retain)UILabel *bottomLineLabel;
/** 右侧箭头 */
@property(nonatomic,retain)UIImageView *arrowImageView;
/** 选项名称 */
@property(nonatomic,retain)UITextField *textField;

@end

@implementation HB_ContactDetailCell

-(void)dealloc{
    [_model release];
    [_iconImageView release];
    [_bottomLineLabel release];
    [_arrowImageView release];
    [_textField release];
    [super dealloc];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubViewsFrame];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * identify=@"HB_ContactDetailCell";
    HB_ContactDetailCell * cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell addSubViews];
    }
    return cell;
}
/**
 *  添加子控件
 */
-(void)addSubViews{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.bottomLineLabel];
}
/**
 *  设置子控件的frame
 */
-(void)setupSubViewsFrame{
    //图标
    CGFloat iconImageView_W=20;
    CGFloat iconImageView_H=iconImageView_W;
    CGFloat iconImageView_X=15;
    CGFloat iconImageView_Y=self.contentView.bounds.size.height * 0.5 - iconImageView_H*0.5;
    self.iconImageView.frame=CGRectMake(iconImageView_X,
                                        iconImageView_Y,
                                        iconImageView_W,
                                        iconImageView_H);
    //右侧箭头
    CGFloat arrowImageView_H=20;
    CGFloat arrowImageView_W=arrowImageView_H;
    CGFloat arrowImageView_X=self.contentView.bounds.size.width - Padding - arrowImageView_W;
    CGFloat arrowImageView_Y=self.contentView.bounds.size.height * 0.5 - arrowImageView_H*0.5;
    self.arrowImageView.frame=CGRectMake(arrowImageView_X,
                                         arrowImageView_Y,
                                         arrowImageView_W,
                                         arrowImageView_H);
    //选项名字
    CGFloat textField_X=CGRectGetMaxX(_iconImageView.frame) + Padding;
    CGFloat textField_Y=0;
    CGFloat textField_W=self.contentView.bounds.size.width - textField_X - Padding;
    CGFloat textField_H=self.contentView.bounds.size.height;
    self.textField.frame=CGRectMake(textField_X,
                                    textField_Y,
                                    textField_W,
                                    textField_H);
    //底部细线
    CGFloat bottomLineLabel_X=iconImageView_X ;
    CGFloat bottomLineLabel_W=self.contentView.bounds.size.width - bottomLineLabel_X * 2;
    CGFloat bottomLineLabel_H=0.5;
    CGFloat bottomLineLabel_Y=self.contentView.bounds.size.height - bottomLineLabel_H;
    self.bottomLineLabel.frame=CGRectMake(bottomLineLabel_X,
                                          bottomLineLabel_Y,
                                          bottomLineLabel_W,
                                          bottomLineLabel_H);
}
#pragma mark - 自定义"生日"日期键盘的类型
-(UIView *)datePickerKeyBoard{
    UIDatePicker * datePicker=[[[UIDatePicker alloc]init] autorelease];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    return datePicker;
}
-(void)datePickerValueChanged:(UIDatePicker * )datePicker{
    NSString * dateStr=[NSString stringWithFormat:@"%@",datePicker.date];
    dateStr=[dateStr substringToIndex:11];
    self.textField.text=dateStr;
}
#pragma mark - textfield代理方法
//过滤空格键
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        return NO;
    }else{
        return YES;
    }
}
//停止编辑的时候，要通知代理，存储当前的属性值
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *nameStr = self.model.placeHolder;
    NSString *text = textField.text;
    if ([nameStr isEqualToString:@"姓名"]) {
        self.model.listModel.name=text;
    }else if ([nameStr isEqualToString:@"公司"]){
        self.model.listModel.organization=text;
    }else if ([nameStr isEqualToString:@"职务"]){
        self.model.listModel.jobTitle=text;
    }else if ([nameStr isEqualToString:@"在职部门"]){
        self.model.listModel.department=text;
    }else if ([nameStr isEqualToString:@"称谓"]){
        self.model.listModel.nickName=text;
    }else if ([nameStr isEqualToString:@"QQ"]){
        self.model.listModel.QQ=text;
    }else if ([nameStr isEqualToString:@"易信"]){
        self.model.listModel.yiXin=text;
    }else if ([nameStr isEqualToString:@"微信"]){
        self.model.listModel.weiXin=text;
    }else if ([nameStr isEqualToString:@"公司地址"]){
        self.model.listModel.address_company=text;
    }else if ([nameStr isEqualToString:@"公司邮编"]){
        self.model.listModel.postcode_company=text;
    }else if ([nameStr isEqualToString:@"公司主页"]){
        self.model.listModel.url_company=text;
    }else if ([nameStr isEqualToString:@"家庭地址"]){
        self.model.listModel.address_family=text;
    }else if ([nameStr isEqualToString:@"家庭邮编"]){
        self.model.listModel.postcode_family=text;
    }else if ([nameStr isEqualToString:@"个人主页"]){
        self.model.listModel.url_person=text;
    }else if ([nameStr isEqualToString:@"生日"]){
        self.model.listModel.birthday=text;
    }else if ([nameStr isEqualToString:@"备注"]){
        self.model.listModel.note=text;
    }else if ([nameStr isEqualToString:@"名片别名"]){
        self.model.listModel.cardName = text;
    }
}
#pragma mark - setter and getter
-(void)setModel:(HB_ContactDetailCellModel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    //图标
    _iconImageView.image=model.icon;
    //选项名字
    self.textField.placeholder=model.placeHolder;
    //设置键盘
    if ([model.placeHolder isEqualToString:@"生日"]) {
        _arrowImageView.hidden=NO;
        self.textField.inputView=[self datePickerKeyBoard];
    }else{
        _arrowImageView.hidden=YES;
        self.textField.inputView=UIKeyboardTypeDefault;
    }
    //根据listModel来确定内容
    if ([model.placeHolder isEqualToString:@"姓名"]) {
        self.textField.text = model.listModel.name;
    }else if ([model.placeHolder isEqualToString:@"公司"]){
        self.textField.text = model.listModel.organization;
    }else if ([model.placeHolder isEqualToString:@"职务"]){
        self.textField.text = model.listModel.jobTitle;
    }else if ([model.placeHolder isEqualToString:@"在职部门"]){
        self.textField.text = model.listModel.department;
    }else if ([model.placeHolder isEqualToString:@"称谓"]){
        self.textField.text = model.listModel.nickName;
    }else if ([model.placeHolder isEqualToString:@"QQ"]){
        self.textField.text = model.listModel.QQ;
    }else if ([model.placeHolder isEqualToString:@"易信"]){
        self.textField.text = model.listModel.yiXin;
    }else if ([model.placeHolder isEqualToString:@"微信"]){
        self.textField.text = model.listModel.weiXin;
    }else if ([model.placeHolder isEqualToString:@"公司地址"]){
        self.textField.text = model.listModel.address_company;
    }else if ([model.placeHolder isEqualToString:@"公司邮编"]){
        self.textField.text = model.listModel.postcode_company;
    }else if ([model.placeHolder isEqualToString:@"公司主页"]){
        self.textField.text = model.listModel.url_company;
    }else if ([model.placeHolder isEqualToString:@"家庭地址"]){
        self.textField.text = model.listModel.address_family;
    }else if ([model.placeHolder isEqualToString:@"家庭邮编"]){
        self.textField.text = model.listModel.postcode_family;
    }else if ([model.placeHolder isEqualToString:@"个人主页"]){
        self.textField.text = model.listModel.url_person;
    }else if ([model.placeHolder isEqualToString:@"生日"]){
        self.textField.text = model.listModel.birthday;
    }else if ([model.placeHolder isEqualToString:@"备注"]){
        self.textField.text = model.listModel.note;
    }
    else if ([model.placeHolder isEqualToString:@"名片别名"])
    {
        self.textField.text = model.listModel.cardName;
    }
    //底部细线
}
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc]init];
    }
    return _iconImageView;
}
-(UILabel *)bottomLineLabel{
    if (!_bottomLineLabel) {
        _bottomLineLabel=[[UILabel alloc]init];
        _bottomLineLabel.backgroundColor=COLOR_H;
        _bottomLineLabel.textColor=[UIColor clearColor];
    }
    return _bottomLineLabel;
}
-(UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView=[[UIImageView alloc]init];
        _arrowImageView.hidden=YES;
        _arrowImageView.image=[UIImage imageNamed:@"普通箭头-List"];
    }
    return _arrowImageView;
}
-(UITextField *)textField{
    if (!_textField) {
        _textField=[[UITextField alloc]init];
        _textField.font=[UIFont systemFontOfSize:15];
        _textField.delegate=self;
        _textField.textColor=COLOR_D;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

@end
