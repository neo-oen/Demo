//
//  UpDownRefurbishView.m
//  UpDownRefurbishView
//
//  Created by neo on 2017/10/17.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "UpDownRefurbishView.h"


@interface UpDownRefurbishView()

@property(nonatomic,strong)UIButton * button;
@property(nonatomic,strong)UIView * view;
@property(nonatomic,strong)UIActivityIndicatorView * activeIV;


@end

@implementation UpDownRefurbishView

#pragma mark - ============== 懒加载 ==============
-(UIButton *)button
{
    if(!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundColor:[UIColor purpleColor]];
        NSDictionary *attribs = @{NSFontAttributeName:[UIFont systemFontOfSize:40],
                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                 };
        NSAttributedString * sdf = [[NSAttributedString alloc] initWithString:@"点击加载更多" attributes:attribs];
        [_button setAttributedTitle:sdf forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return _button;
}

-(UIView *)view
{
    if(!_view) {
        _view = [[UIView alloc] initWithFrame:_button.frame];
        [_view setBackgroundColor:[UIColor orangeColor]];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_activeIV.frame.origin.x+30, _activeIV.frame.origin.y, 200, 20)];
        [label setText:@"sdfsd"];
        [_view addSubview:label];
        [_view setAlpha:0];
        [self addSubview:_view];
    }
    return _view;
}

-(UIActivityIndicatorView *)activeIV
{
    if(!_activeIV) {
        _activeIV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
         [_activeIV setFrame:CGRectMake(103,(_button.frame.size.height-20)*0.5 , 20, 20)];
        [_activeIV setColor:[UIColor whiteColor]];
       [self.view addSubview:_activeIV];
        //
    }
    return _activeIV;
}

#pragma mark - ============== 初始化 ==============

/**
 初始化view
 */

+(UpDownRefurbishView *)upDownRefurbishWithFrame:(CGRect)frame WithStyle:(UIUpDownRefurbishViewStyle )style withClickAction:(ButtonClickAction)buttonCA{
    
    UpDownRefurbishView * upDownRefurbishView = [[self alloc]initWithFrame:frame];
    upDownRefurbishView.buttonCA = buttonCA;
    return upDownRefurbishView;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.button setFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        self.activeIV;
        self.view;
        [_activeIV startAnimating];
        
    }
    return self;
}


#pragma mark - ============== 更新视图 ==============
/**
 根据资源，更新View
 
 @param model 资源
 */
//- (void)updateUpDownRefurbishViewWith:(UpDownRefurbishViewModel *)model {
//    
//    _model = model;
//    
//    
//}



#pragma mark - ============== 接口 ==============


/**
 接口
 
 
 @return 返回成功与否
 */
//-(BOOL)upDownRefurbishState{
//    
//    return YES;
//}


#pragma mark - ============== 方法 ==============
-(void)buttonClick{
    [_view setAlpha:1];
    if(self.buttonCA){
        self.buttonCA();
    }
}
#pragma mark - ============== 代理 ==============

//@end
//
//
//@implementation UpDownRefurbishView
//
//

@end
