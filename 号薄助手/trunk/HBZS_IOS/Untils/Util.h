//
//  Util.h
//  HBZS_IOS
//
//  Created by Kevin Zhang on 13-5-23.
//
//

#import <Foundation/Foundation.h>

@interface Util : NSObject{
    
}

/*
 * UIButton
 */
+ (UIButton *)allocBtn:(CGRect)_rect
        setImgForNomal:(NSString *)imgNomal setImgForHighlight:(NSString *)imgHighlight setTitleForNomal:(NSString *)titleForHighlight
            setBtnType:(UIButtonType)btnType
                setTag:(int)btnTag setDelegate:(id)_delegate selector:(SEL)selector;

/*
 * UITextField
 */
+ (UITextField *)allocTextField:(CGRect)_rect setText:(NSString *)text setBorderStyle:(UITextBorderStyle)style
                        setFont:(CGFloat)fontSize
                   setPlaceHold:(NSString *)place setSecureTextEntry:(BOOL)isSecure setTag:(int)fieldTag;

/*
 * UILabel
 */
+ (UILabel *)allocLabel:(CGRect)_rect setText:(NSString *)text setFont:(CGFloat)fontSize
           setAlignment:(UITextAlignment)alignment setTextColor:(UIColor *)txtColor setTag:(int)txtTag;

/*
 * UIBarButtonItem
 */
+ (UIBarButtonItem *)allocBarButtonItem:(UIButton *)btn;

/*
 * UIImage
 */
+ (UIImage *)allocImage:(NSString *)img;

/*
 * UIAlertView
 */
+ (void)Alert:(NSString *)title setMsg:(NSString *)msg setDelegate:(id)_delegate setTag:(int)_tag setBtnTitle:(NSString *)title1
  setBtnTitle:(NSString *)title2;

+ (NSString *)dateToString:(NSDate *)date;

+ (NSDate *)stringToDate:(NSString *)dateString;

@end
