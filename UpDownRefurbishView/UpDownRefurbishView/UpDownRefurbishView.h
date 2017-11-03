//
//  UpDownRefurbishView.h
//  UpDownRefurbishView
//
//  Created by neo on 2017/10/17.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Public.h"

typedef NS_ENUM(NSInteger, UIUpDownRefurbishViewStyle) {
    UIUpDownRefurbishViewStyleButton,
    UIUpDownRefurbishViewStyleNone
};


typedef void (^ButtonClickAction)();

@interface UpDownRefurbishView : UIView

@property(nonatomic,copy)ButtonClickAction buttonCA ;//向view类外，索要非本类的工作的接口


+ (UpDownRefurbishView *)upDownRefurbishWithFrame:(CGRect)frame WithStyle:(UIUpDownRefurbishViewStyle )style withClickAction:(ButtonClickAction)buttonCA;

@end
