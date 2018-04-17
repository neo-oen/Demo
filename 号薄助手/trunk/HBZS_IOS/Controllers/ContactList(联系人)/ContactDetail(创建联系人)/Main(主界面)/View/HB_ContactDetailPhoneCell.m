//
//  HB_ContactDetailPhoneCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/15.
//
//
#import "HB_ContactDetailPhoneCell.h"

@interface HB_ContactDetailPhoneCell ()<UITextFieldDelegate>

/** 图标 */
@property(nonatomic,retain)UIImageView *iconImageView;
/** 中间细线 */
@property(nonatomic,retain)UILabel *middleLine;
/** 右侧细线 */
@property(nonatomic,retain)UILabel *rightLine;
/** 类型选择按钮下面的细线上的下拉箭头 */
@property(nonatomic,retain)UIImageView *pullDownImage;
/** cell最右侧的删除按钮 */
@property(nonatomic,retain)UIButton *deleteBtnRight;
/** textField的每一次输入的字符（长度为0表示是正在删除，长度为1表示正在添加） */
@property(nonatomic,copy)NSString *textFieldString;

@end

@implementation HB_ContactDetailPhoneCell

#pragma mark - life cycle
-(void)dealloc{
    [_textField release];
    [_model release];
    [_iconImageView release];
    [_middleLine release];
    [_rightLine release];
    [_pullDownImage release];
    [_textFieldString release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identify = @"HB_ContactDetailPhoneCell";
    HB_ContactDetailPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell setupSubViews];
    }
    return cell;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviewsFrame];
}
-(void)setupSubViews{
    //图标
    [self.contentView addSubview:self.iconImageView];
    //选项名字
    [self.contentView addSubview:self.textField];
    //分类按钮
    [self.contentView addSubview:self.typeButton];
    //中间细线
    [self.contentView addSubview:self.middleLine];
    //右侧细线
    [self.contentView addSubview:self.rightLine];
    //下拉小箭头
    [self.contentView addSubview:self.pullDownImage];
    //添加cell右侧的删除按钮
    [self addSubview:self.deleteBtnRight];
    [self sendSubviewToBack:self.deleteBtnRight];
}
-(void)setupSubviewsFrame{
    CGFloat padding = 15;
    //图标
    CGFloat iconImageView_H=20;
    CGFloat iconImageView_W=iconImageView_H;
    CGFloat iconImageView_X=15;
    CGFloat iconImageView_Y=self.contentView.bounds.size.height * 0.5 - iconImageView_H*0.5;
    _iconImageView.frame=CGRectMake(iconImageView_X, iconImageView_Y, iconImageView_W, iconImageView_H);
    //分类按钮
    CGFloat typeButton_H=iconImageView_H;
    CGFloat typeButton_W=80;
    CGFloat typeButton_X=self.contentView.bounds.size.width-typeButton_W-padding;
    CGFloat typeButton_Y=self.contentView.bounds.size.height * 0.5 - typeButton_H*0.5;
    _typeButton.frame=CGRectMake(typeButton_X, typeButton_Y, typeButton_W, typeButton_H);
    //选项名字
    CGFloat textFiled_H=self.contentView.bounds.size.height;
    CGFloat textFiled_X=CGRectGetMaxX(_iconImageView.frame) + padding;
    CGFloat textFiled_Y=0;
    CGFloat textFiled_W=CGRectGetMinX(_typeButton.frame)-padding - textFiled_X;
    self.textField.frame=CGRectMake(textFiled_X, textFiled_Y, textFiled_W, textFiled_H);
    //左侧删除按钮
    if (_textField.editing) {//当处于编辑状态
        if (self.textField.text.length) {//如果输入框有值
            if (_textField.text.length==1 && _textFieldString.length==0) {
                [self hidenLeftDeleteBtn];
            }else{
                [self showLeftDeleteBtn];
            }
        }else{//如果输入框没有值
            if (self.textFieldString.length) {
                [self showLeftDeleteBtn];
            }else{
                [self hidenLeftDeleteBtn];
            }
        }
    }else{//非编辑状态
        if (self.textField.text.length) {
            [self showLeftDeleteBtn];
        }
    }
    
    //中间细线
    CGFloat middleLine_X = textFiled_X;
    CGFloat middleLine_H = 0.5;
    CGFloat middleLine_Y = self.contentView.bounds.size.height-middleLine_H;
    CGFloat middleLine_W = textFiled_W;
    self.middleLine.frame = CGRectMake(middleLine_X, middleLine_Y, middleLine_W, middleLine_H);
    //右侧细线
    CGFloat rightLine_W = typeButton_W;
    CGFloat rightLine_H = middleLine_H;
    CGFloat rightLine_X = typeButton_X;
    CGFloat rightLine_Y = middleLine_Y;
    self.rightLine.frame = CGRectMake(rightLine_X, rightLine_Y, rightLine_W, rightLine_H);
    //下拉小箭头
    CGFloat pullDownImage_W = 6;
    CGFloat pullDownImage_H = pullDownImage_W;
    CGFloat pullDownImage_X = CGRectGetMaxX(self.rightLine.frame)-pullDownImage_W;
    CGFloat pullDownImage_Y = CGRectGetMinY(self.rightLine.frame)-pullDownImage_H;
    self.pullDownImage.frame = CGRectMake(pullDownImage_X, pullDownImage_Y, pullDownImage_W, pullDownImage_H);
    //cell右侧删除按钮
    CGFloat deleteBtn_W = 60;
    CGFloat deleteBtn_H = 60;
    CGFloat deleteBtn_X = self.bounds.size.width-deleteBtn_W;
    CGFloat deleteBtn_Y = 0;
    self.deleteBtnRight.frame = CGRectMake(deleteBtn_X, deleteBtn_Y, deleteBtn_W, deleteBtn_H);
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.middleLine.backgroundColor = COLOR_A;
    self.rightLine.backgroundColor = COLOR_A;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@" "]) {
        return  NO;
    }
    //赋值，用于判断是否显示左侧删除小按钮
    self.textFieldString = string;

    NSString * textString=[textField.text stringByAppendingString:string];
    NSArray * strArr=[textString componentsSeparatedByString:@" "];
    NSMutableArray * mutableArr=[strArr mutableCopy];
    [mutableArr removeObject:@""];
    NSString * text=[mutableArr componentsJoinedByString:@""];
    if (string.length==1) {
        //有内容输入，就要展示删除按钮
        [self showLeftDeleteBtn];
        if (text.length==1) {
            //证明textfield里面输入内容了(并且是第一次输入内容)，则要增加一个cell
            if ([self.delegate respondsToSelector:@selector(contactDetailPhoneCellBeginInsert:)]) {
                [self.delegate contactDetailPhoneCellBeginInsert:self];
            }
        }
    }else if (text.length==1 && string.length==0){
        //证明textfield里面数据清空了，则要删除一个cell
        self.textField.text = nil;
        if ([self.delegate respondsToSelector:@selector(contactDetailPhoneCellBeginClear:)]) {
            [self.delegate contactDetailPhoneCellBeginClear:self];
        }
    }
    [mutableArr release];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.middleLine.backgroundColor=COLOR_H;
    self.rightLine.backgroundColor=COLOR_H;
    if ([self.delegate respondsToSelector:@selector(contactDetailPhoneCell:didEndEditingWithText:)]) {
        [self.delegate contactDetailPhoneCell:self didEndEditingWithText:textField.text];
    }
}
#pragma mark - private methods
/**
 *  隐藏textField左侧删除按钮
 */
-(void)hidenLeftDeleteBtn{
    self.textField.leftView.frame = CGRectZero;
}
/**
 *  显示textField左侧删除按钮
 */
-(void)showLeftDeleteBtn{
    self.textField.leftView.frame = CGRectMake(0, 0, 20, self.textField.bounds.size.height);
}
/**
 *  cell向左滑动，展示右侧的删除按钮
 */
-(void)slideToLeft{
    CGPoint centerPoint = self.contentView.center;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.center = CGPointMake(centerPoint.x-60, centerPoint.y);
    }];
}
/**
 *  cell复原位置
 */
-(void)recoveryCell{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    }];
}
#pragma mark -  event response
-(void)deleteBtnLeftClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(contactDetailPhoneCell:deleteLeftBtnClick:)]) {
        [self.delegate contactDetailPhoneCell:self deleteLeftBtnClick:btn];
    }
    [self slideToLeft];
}
-(void)deleteBtnRightClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(contactDetailPhoneCell:deleteRightBtnClick:)]) {
        [self.delegate contactDetailPhoneCell:self deleteRightBtnClick:btn];
    }
}
-(void)typeSelectBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(contactDetailPhoneCell:typeChooseBtnClick:)]) {
        [self.delegate contactDetailPhoneCell:self typeChooseBtnClick:btn];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(contactDetailPhoneCellTouchBegin:)]) {
        [self.delegate contactDetailPhoneCellTouchBegin:self];
    }
}

#pragma mark - setter and getter
-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.delegate = self;
        _textField.textColor = COLOR_D;
        _textField.clearButtonMode = UITextFieldViewModeNever;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        //左侧小删除按钮
        UIButton *leftDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftDeleteBtn setImage:[UIImage imageNamed:@"删除_联系人"] forState:UIControlStateNormal];
        [leftDeleteBtn addTarget:self action:@selector(deleteBtnLeftClick:) forControlEvents:UIControlEventTouchUpInside];
        leftDeleteBtn.imageView.contentMode = UIViewContentModeCenter;
        leftDeleteBtn.frame = CGRectZero;

        _textField.leftView = leftDeleteBtn;
    }
    return _textField;
}
-(UIButton *)typeButton{
    if (!_typeButton) {
        _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_typeButton setTitleColor:COLOR_D forState:UIControlStateNormal];
        [_typeButton addTarget:self action:@selector(typeSelectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _typeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _typeButton;
}
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc]init];
    }
    return _iconImageView;
}
-(UILabel *)middleLine{
    if (!_middleLine) {
        _middleLine = [[UILabel alloc]init];
        _middleLine.backgroundColor = COLOR_H;
        _middleLine.textColor = [UIColor clearColor];
    }
    return _middleLine;
}
-(UILabel *)rightLine{
    if (!_rightLine) {
        _rightLine = [[UILabel alloc]init];
        _rightLine.backgroundColor = COLOR_H;
        _rightLine.textColor = [UIColor clearColor];
    }
    return _rightLine;
}

-(UIImageView *)pullDownImage{
    if (!_pullDownImage) {
        _pullDownImage = [[UIImageView alloc]init];
        _pullDownImage.image = [UIImage imageNamed:@"下拉角标"];
    }
    return _pullDownImage;
}
-(UIButton *)deleteBtnRight{
    if (!_deleteBtnRight) {
        _deleteBtnRight = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtnRight.backgroundColor = [UIColor redColor];
        _deleteBtnRight.titleLabel.font = [UIFont systemFontOfSize:18];
        [_deleteBtnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteBtnRight setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtnRight addTarget:self action:@selector(deleteBtnRightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtnRight;
}
-(void)setModel:(HB_ContactDetailPhoneCellModel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    //1.先把_textFieldString置空
    self.textFieldString = nil;
    //图标
    self.iconImageView.image = model.icon;
    //选项名字
    self.textField.placeholder = model.placeHolder;
    //键盘类型
    if ([model.placeHolder isEqualToString:@"电话号码"]) {
        self.textField.keyboardType = UIKeyboardTypePhonePad;
    }else{
        self.textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    //电话号码or邮件，以及右侧类型
    if (model.phoneModel) {
        //如果是电话号码模型
        self.textField.text = model.phoneModel.phoneNum;
        [self.typeButton setTitle:model.phoneModel.phoneType forState:UIControlStateNormal];
    }else if (model.emailModel){
        //如果是邮件模型
        self.textField.text=model.emailModel.emailAddress;
        [self.typeButton setTitle:model.emailModel.emailType forState:UIControlStateNormal];
    }
    //左侧小删除按钮
    if (self.textField.text.length) {
        [self showLeftDeleteBtn];
    }else{
        [self hidenLeftDeleteBtn];
    }
}
@end
