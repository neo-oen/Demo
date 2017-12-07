//
//  Public.m
//  QQ聊天界面
//
//  Created by neo on 2017/12/6.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "Public.h"

@implementation UITextField (UITextFieldRTView)

-(void)addLeftViewWithView:(UIView *)view andViewMode:(UITextFieldViewMode)viewMode{
    self.leftView = view;
    self.leftViewMode = viewMode;
}
-(void)addRightViewWithView:(UIView *)view andViewMode:(UITextFieldViewMode)viewMode{
    self.rightView = view;
    self.rightViewMode = viewMode;
}
-(void)addClearButtonWithViewMode:(UITextFieldViewMode)viewMode{

    self.clearButtonMode = viewMode;
}


@end

