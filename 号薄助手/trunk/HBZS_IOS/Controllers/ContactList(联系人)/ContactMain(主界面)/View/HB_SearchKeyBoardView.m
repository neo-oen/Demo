//
//  HB_SearchKeyBoardView.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/21.
//
//

#define Padding 15 //小按钮之间的间隙


#import "HB_SearchKeyBoardView.h"

@interface HB_SearchKeyBoardView ()
/** 背景图 */
@property(nonatomic,retain)UIImageView * bgImageView;

/** 输入框底部分割线 */
@property(nonatomic,retain)UILabel * lineLabel;
/** 26个字母按钮以及删除按钮 数组 */
@property(nonatomic,retain)NSMutableArray * btnArr;

@end

@implementation HB_SearchKeyBoardView
-(void)dealloc{
    [super dealloc];
    [_bgImageView release];
    [_textField removeObserver:self forKeyPath:@"text"];
    [_textField release];
    [_lineLabel release];
    [_btnArr release];
}
-(instancetype)init{
    self=[super init];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.clipsToBounds=YES;
        [self setupSubViews];
    }
    return self;
}

-(NSMutableArray *)btnArr{
    if (_btnArr==nil) {
        _btnArr=[[NSMutableArray alloc]init];
    }
    return _btnArr;
}
/**
 *  添加子控件
 */
-(void)setupSubViews{
    //1.背景图
    _bgImageView=[[UIImageView alloc]init];
    _bgImageView.userInteractionEnabled=YES;
    [self addSubview:_bgImageView];
    //2.顶部输入框
    _textField=[[UITextField alloc]init];
    _textField.userInteractionEnabled=NO;
    _textField.placeholder=@"输入首字母";
    _textField.font=[UIFont systemFontOfSize:20];
    [_textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
        //2.1textfield左侧视图
    UIView * leftView=[[UIView alloc]init];
    leftView.frame=CGRectMake(0, 0, 20, 20);
    _textField.leftViewMode=UITextFieldViewModeAlways;
    _textField.leftView=leftView;
    [leftView release];
    [_bgImageView addSubview:_textField];
    //3.输入框底部横线
    _lineLabel=[[UILabel alloc]init];
    _lineLabel.textColor=[UIColor clearColor];
    _lineLabel.backgroundColor=COLOR_F;
    [_textField addSubview:_lineLabel];
    //4.添加按钮
    NSMutableArray * titleArr=[[NSMutableArray alloc]init];
    [titleArr addObjectsFromArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@""]];
    for (int i=0; i<27; i++) {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];        
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_F forState:UIControlStateDisabled];
        [btn setTitleColor:COLOR_D forState:UIControlStateNormal];
        if (i==26) {//说明是最后一个删除按钮
            [btn setImage:[UIImage imageNamed:@"删除_search"] forState:UIControlStateNormal];
        }
        btn.tag=i+'A';
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView addSubview:btn];
        [self.btnArr addObject:btn];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //1.背景图frame
    CGFloat bgImageView_W=self.bounds.size.width;
    CGFloat bgImageView_H=self.bounds.size.height;
    CGFloat bgImageView_X=0;
    CGFloat bgImageView_Y=0;
    _bgImageView.frame=CGRectMake(bgImageView_X, bgImageView_Y, bgImageView_W, bgImageView_H);
    
    //2.顶部输入框frame
    CGFloat textField_X=0;
    CGFloat textField_Y=3;
    CGFloat textField_W=bgImageView_W;
    CGFloat textField_H=40;
    _textField.frame=CGRectMake(textField_X, textField_Y, textField_W, textField_H);
    //3.输入框底部分割线
    CGFloat lineLabel_W=textField_W;
    CGFloat lineLabel_H=0.5;
    CGFloat lineLabel_X=0;
    CGFloat lineLabel_Y=textField_H - lineLabel_H;
    _lineLabel.frame=CGRectMake(lineLabel_X, lineLabel_Y, lineLabel_W, lineLabel_H);
    //4.添加按钮frame
    for (int i=0; i<self.btnArr.count; i++) {
        UIButton * btn=self.btnArr[i];
        CGFloat btn_W=30;
        CGFloat btn_H=30;
        CGFloat btn_X=((bgImageView_W - 3*btn_W)/4 + btn_W)* (i%3) + (bgImageView_W - 3*btn_W)/4;
        CGFloat btn_Y=((bgImageView_H - textField_H - 9*btn_H)/10 + btn_H) * (i/3)+((bgImageView_H - textField_H - 9*btn_H)/10) + textField_H;
        btn.frame=CGRectMake(btn_X, btn_Y, btn_W, btn_H);
    }
}
#pragma mark - 点击事件
-(void)btnClick:(UIButton *)btn{
    if (btn.tag== (26+'A') ) {//删除按钮
        NSString * textFieldString=_textField.text;
        if (textFieldString.length) {
            _textField.text=[textFieldString substringToIndex:textFieldString.length-1];
        }
    }else{//其它字母按钮
        NSString * title=[NSString stringWithFormat:@"%c",btn.tag];
        NSString * textFieldString=_textField.text;
        _textField.text=[textFieldString stringByAppendingString:title];
    }
}
/**
 *  textfield输入框变化
 */

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([self.delegate respondsToSelector:@selector(searchKeyBoardView:withSearchText:)]) {
        [self.delegate searchKeyBoardView:self withSearchText:_textField.text];
    }

}


#pragma mark - 控制按钮是否可以被点击（数组的setter方法）
-(void)setCharacterArr:(NSArray *)characterArr{
    //1.所有按钮都先置为不可点击，（删除按钮除外）
    for (int i=0; i<self.btnArr.count; i++) {
        UIButton * btn = self.btnArr[i];
        if (btn.tag==26+'A') {//删除按钮,永远有效
            btn.enabled=YES;
        }else{
            btn.enabled=NO;
        }
    }
    //2.根据返回的数组来确定那些按钮可以点击
    for (int i=0; i<characterArr.count; i++) {
        NSString * titleStr = characterArr[i];
        NSInteger btnTag = [titleStr characterAtIndex:0];
        UIButton * btn = (UIButton *)[_bgImageView viewWithTag:btnTag];
        btn.enabled=YES;
    }
}

@end
