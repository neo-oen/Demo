//
//  ZBTextField.m
//  ZBAddressBook_iOS
//
//  Created by neo on 2019/3/21.
//  Copyright © 2019 Lee. All rights reserved.
//

#import "ZBTextField.h"



@interface ZBTextField ()

@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIColor *borderNorColor;
@property (nonatomic, strong) UIColor *borderResColor;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, assign) CGSize rightSize;
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id>  *attributeDict;

@end

@implementation ZBTextField

#pragma mark - ============== 懒加载 ==============
- (UIView *)line
{
    if(!_line) {
        _line = ({
            UIView * view = [[UIView alloc] init];
            view.backgroundColor = [UIColor redColor];//默认颜色
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.bottom.equalTo(self.mas_bottom);
                make.height.mas_equalTo(@1);
            }];
            view;
        });
    }
    return _line;
}

- (UIButton *)clearBtn
{
    if(!_clearBtn) {
        _clearBtn = ({
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [btn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            UIView * view = [UIView new];
            self.rightView = view;
            self.rightViewMode = UITextFieldViewModeWhileEditing;
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.left.equalTo(view);
            }];
            btn.hidden = YES;
            
            btn;
        });
    }
    return _clearBtn;
}
- (UIColor *)borderNorColor
{
    if(!_borderNorColor) {
        _borderNorColor = [UIColor blueColor];
    }
    return _borderNorColor;
}

- (UIColor *)borderResColor
{
    if(!_borderResColor) {
        _borderResColor = [UIColor blueColor];
    }
    return _borderResColor;
}

#pragma mark - ============== 初始化 ==============
- (instancetype)init {
    if (self = [super init]) {
        [self setInit];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setInit];
    }
    return self;
}
#pragma mark - ============== 接口 ==============
- (void)setBorderColorWithNormal:(UIColor *)norColor andResponder:(UIColor *)resColor{
    self.borderNorColor = norColor;
    self.borderResColor = resColor;
    [self.line setBackgroundColor:self.borderNorColor];
    
}

- (void)setBorderColor:(UIColor *)color{
    [self setBorderColorWithNormal:color andResponder:color];
}

- (void)setBorderWidth:(float)width{
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(width);
    }];
}

- (void)setborderEdges:(UIEdgeInsets)inset{
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(inset.left);
        make.right.equalTo(self).offset(-inset.right);
        make.bottom.equalTo(self).offset(-inset.bottom);
    }];
}

- (void)setClearButtonWithImage:(NSString *)image{
    [self.clearBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

-(void)setRightSize:(CGSize)rightSize{
    _rightSize = rightSize;
    [self layoutSubviews];
}

- (void)setAttributedDict:(NSDictionary<NSAttributedStringKey, id> *)dict{
    self.attributeDict = dict;
}

#pragma mark - ============== 方法 ==============

- (void)setInit{
    [self notificationObject];
    self.rightSize = CGSizeZero;
    
}

/**
 判断有没有显示clearBtn,没有不用显示
 */
- (void)updateInterface{
    if (_clearBtn) {
        if (self.rightSize.width ==0) {
            [self.rightView setSize:CGSizeMake(self.height, self.height)];
        }else{
            [self.rightView setSize:self.rightSize];
        }
    }
    
    
}

- (void)textFielChangeData{
    if (_clearBtn) {
        self.clearBtn.hidden = self.text.length > 0 ? NO : YES;
    }
    if (_attributeDict) {
        self.attributedText = [[NSAttributedString alloc]initWithString:self.text attributes:self.attributeDict];
    }
    if (self.textFieldCA) {
        self.textFieldCA(self);
    }
}
/**
 添加监控textfield的文本是否改变
 */
- (void)notificationObject{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFielChangeData) name:@"UITextFieldTextDidChangeNotification" object:self];
    
}

/**
 删除监控
 */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self];
}

- (void)clearBtnClick:(UIButton *)btn{
    self.text = @"";
    btn.hidden = YES;
    if (self.textFieldCA) {
        self.textFieldCA(self);
    }
}


#pragma mark - ============== UI界面 ==============
#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============

- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateInterface];
    
}

-(void)setBorderStyle:(UITextBorderStyle)borderStyle{
    if (borderStyle == UITextBorderStyleLine) {
        [super setBorderStyle:UITextBorderStyleNone];
    }else{
        [super setBorderStyle:borderStyle];
    }
    
}

-(BOOL)becomeFirstResponder{
    BOOL result = [super becomeFirstResponder];
    if (result) {
        [self.line setBackgroundColor:self.borderResColor];
    }
    return result;
}

-(BOOL)resignFirstResponder{
    BOOL result =  [super resignFirstResponder];;
    if (result) {
        [self.line setBackgroundColor:self.borderNorColor];
    }
    return result;
}




@end
