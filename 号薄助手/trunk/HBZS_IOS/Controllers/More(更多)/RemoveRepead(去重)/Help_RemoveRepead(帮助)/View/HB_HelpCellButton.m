//
//  HB_HelpCellButton.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/17.
//
//

#import "HB_HelpCellButton.h"

@implementation HB_HelpCellButton


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat image_W=12;
    CGFloat image_H=7;
    CGFloat image_X=contentRect.size.width-image_W-15;
    CGFloat image_Y=contentRect.size.height*0.5-image_H*0.5;
    CGRect frame=CGRectMake(image_X, image_Y, image_W, image_H);
    return frame;
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat title_X=15;
    CGFloat title_W=contentRect.size.width-title_X-12-15-15;
    CGFloat title_H=contentRect.size.height;
    CGFloat title_Y=0;
    CGRect frame=CGRectMake(title_X, title_Y, title_W, title_H);
    return frame;
}

@end
