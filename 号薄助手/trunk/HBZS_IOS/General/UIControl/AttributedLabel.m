//
//  AttributedLabel.m
//  AttributedStringTest
//
//  Created by sun huayu on 13-2-19.
//  Copyright (c) 2013年 sun huayu. All rights reserved.
//

#import "AttributedLabel.h"

@implementation AttributedLabel

@synthesize attString;

- (void)dealloc{
    if (attString) {
        [attString release];
        
        attString = nil;
    }
   
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
  
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(
                            (CFAttributedStringRef)self.attString);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL,CGRectMake(0,
                                                  0,
                                                  self.bounds.size.width,
                                                  self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0),leftColumnPath, NULL);
    // flip the coordinate system
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    // draw
    CTFrameDraw(leftFrame, context);
    
    CGPathRelease(leftColumnPath);
    
    CFRelease(framesetter);
    
    CFRelease(leftFrame);
    
    UIGraphicsPushContext(context);
}

- (void)setText:(NSString *)text{
    [super setText:text];
    
    if (text == nil) {
        attString = nil;
    }
    else{
        if (attString) {
            [attString release];
            
            attString = nil;
        }
        
        attString = [[NSMutableAttributedString alloc] initWithString:text];
    }
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0 || location > self.text.length-1 || length+location > self.text.length) {
        return;
    }
   
    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                      value:(id)color.CGColor
                      range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0 || location > self.text.length-1 || length+location > self.text.length) {
        return;
    }
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT",
                                             font.pointSize,
                                             NULL);
    [attString addAttribute:(NSString *)kCTFontAttributeName value:(id)fontRef range:NSMakeRange(location, length)];
    
    CFRelease(fontRef);
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0 || location > self.text.length-1 || length+location > self.text.length) {
        return;
    }
    
    [attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                      value:(id)[NSNumber numberWithInt:style]
                      range:NSMakeRange(location, length)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
