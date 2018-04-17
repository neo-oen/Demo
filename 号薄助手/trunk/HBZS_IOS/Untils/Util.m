//
//  Util.m
//  HBZS_IOS
//
//  Created by Kevin Zhang on 13-5-23.
//
//

#import "Util.h"

@implementation Util

+ (UIImage *)allocImage:(NSString *)img{
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:img ofType:@"png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
    
    return image;
}

+ (UIBarButtonItem *)allocBarButtonItem:(UIButton *)btn{
    UIBarButtonItem *barBtnItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    return barBtnItem;
}

+ (UIButton *)allocBtn:(CGRect)_rect
        setImgForNomal:(NSString *)imgNomal setImgForHighlight:(NSString *)imgHighlight setTitleForNomal:(NSString *)titleForNomal
            setBtnType:(UIButtonType)btnType
                setTag:(int)btnTag setDelegate:(id)_delegate selector:(SEL)selector{
    UIButton *btn = [UIButton buttonWithType:btnType];
    btn.exclusiveTouch = YES;
    btn.frame = _rect;
    
    if (imgNomal) {
        [btn setBackgroundImage:[self allocImage:imgNomal] forState:UIControlStateNormal];
    }
    
    if (imgHighlight) {
        [btn setBackgroundImage:[self allocImage:imgHighlight] forState:UIControlStateHighlighted];
    }
    
    [btn setTitle:titleForNomal forState:UIControlStateNormal];
    
    [btn addTarget:_delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTag:btnTag];
    
    return btn;
}

+ (UITextField *)allocTextField:(CGRect)_rect setText:(NSString *)text setBorderStyle:(UITextBorderStyle)style
                        setFont:(CGFloat)fontSize
                   setPlaceHold:(NSString *)place setSecureTextEntry:(BOOL)isSecure setTag:(int)fieldTag{
    
    UITextField *txtField = [[[UITextField alloc]initWithFrame:_rect] autorelease];
    
    txtField.borderStyle = style;
    
    txtField.text = text;
    
    txtField.font = [UIFont systemFontOfSize:fontSize];
    
    txtField.secureTextEntry = isSecure;
    
    txtField.tag = fieldTag;
    
    txtField.placeholder = place;
    
    return txtField;
}

+ (UILabel *)allocLabel:(CGRect)_rect setText:(NSString *)text setFont:(CGFloat)fontSize
           setAlignment:(UITextAlignment)alignment setTextColor:(UIColor *)txtColor setTag:(int)txtTag{
    
    UILabel *label = [[[UILabel alloc]initWithFrame:_rect] autorelease];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.text = text;
    
    label.font = [UIFont systemFontOfSize:fontSize];
    
    label.textAlignment = alignment;
    
    label.tag = txtTag;
    
    label.textColor = txtColor;
    
    return label;
}

+ (void)Alert:(NSString *)title setMsg:(NSString *)msg setDelegate:(id)_delegate setTag:(int)_tag setBtnTitle:(NSString *)title1
  setBtnTitle:(NSString *)title2{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:_delegate cancelButtonTitle:title1 otherButtonTitles:title2, nil];
    
    alert.tag = _tag;
    
    [alert show];
    
    [alert release];
}

+ (NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"h:mm"];
    
    NSString *signInDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    
    [dateFormatter release];
    
    return signInDate;
}

+ (NSDate *)stringToDate:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"hh:mm"];
    
    NSDate *dateTime = [dateFormatter dateFromString:@"20:00"];
    
    [dateFormatter release];
    
    return dateTime;
}


@end
