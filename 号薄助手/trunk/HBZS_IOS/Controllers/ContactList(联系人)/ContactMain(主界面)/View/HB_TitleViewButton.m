//
//  HB_TitleViewButton.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/14.
//
//

#define Image_W 10.0

#import "HB_TitleViewButton.h"

@implementation HB_TitleViewButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setAdjustsImageWhenHighlighted:NO];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    NSString * titleStr=[self titleForState:UIControlStateNormal];
    NSMutableDictionary * attributesDict=[NSMutableDictionary dictionary];
    attributesDict[NSFontAttributeName]=[UIFont systemFontOfSize:20];
    CGSize size=[titleStr boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDict context:nil].size;
    
    CGFloat image_W=Image_W;
    CGFloat image_X=contentRect.size.width * 0.5 + (size.width+image_W)*0.5 -image_W + 5;
    CGFloat image_H=contentRect.size.height;
    CGFloat image_Y=0;
    CGRect rect =CGRectMake(image_X, image_Y, image_W, image_H);
    return rect;
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    NSString * titleStr=[self titleForState:UIControlStateNormal];
    NSMutableDictionary * attributesDict=[NSMutableDictionary dictionary];
    attributesDict[NSFontAttributeName]=[UIFont systemFontOfSize:20];
    CGSize size=[titleStr boundingRectWithSize:CGSizeMake(200, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDict context:nil].size;
    
    CGFloat title_X=0;
    CGFloat title_W=contentRect.size.width * 0.5 + (size.width+Image_W)*0.5-Image_W;
    CGFloat title_H=contentRect.size.height;
    CGFloat title_Y=0;
    CGRect rect =CGRectMake(title_X, title_Y, title_W, title_H);
    return rect;
}


@end
