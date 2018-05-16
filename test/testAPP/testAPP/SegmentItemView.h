//
//  SegmentItemView.h
//  testAPP
//
//  Created by neo on 2018/5/9.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentItemView : UIView

@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UILabel * label;
//@property(nonatomic,assign,getter=isSelected)BOOL selected;

//-(void)setItemWithImage:(UIImage *)image andTitle:(NSString *)title Selected:(BOOL)selected;
-(void)setItemWithImage:(UIImage *)image andTitle:(NSString *)title;

-(void)setItemWithImage:(UIImage *)image andTitleColor:(UIColor *)color;

@end
