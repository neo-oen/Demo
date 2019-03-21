//
//  ZBTextField.h
//  ZBAddressBook_iOS
//
//  Created by neo on 2019/3/21.
//  Copyright © 2019 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@class ZBTextField;
typedef void (^TextFieldDateChangeAction)(ZBTextField * textfield);

/**
 本类一旦设置边框，原生的clearBtn就会失效，建议使用本类的自定义clearBtn
 */
@interface ZBTextField : UITextField

@property (nonatomic, copy) TextFieldDateChangeAction textFieldCA ;

- (void)setBorderColorWithNormal:(UIColor *)norColor andResponder:(UIColor *)resColor;
- (void)setBorderColor:(UIColor *)color;
- (void)setBorderWidth:(float)width;
- (void)setborderEdges:(UIEdgeInsets)inset;

/**
 设置rightViewsize，一定要在给rightView后面设置

 @param rightSize rightSize
 */
-(void)setRightSize:(CGSize)rightSize;
/**
 设置这个使用自定义clearButton
 本方法使用的是rightView
 @param image 自定义图片
 */
- (void)setClearButtonWithImage:(NSString *)image;


/**
 设置这个，就可以实现实时显示富文本

 @param dict 富文本字典
 */
- (void)setAttributedDict:(NSDictionary<NSAttributedStringKey, id> *)dict;

@end

NS_ASSUME_NONNULL_END
