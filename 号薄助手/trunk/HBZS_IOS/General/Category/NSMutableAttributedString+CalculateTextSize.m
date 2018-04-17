//
//  NSMutableAttributedString+CalculateTextSize.m
//  HBZS_IOS
//
//  Created by zimbean on 14-6-27.
//
//

#import "NSMutableAttributedString+CalculateTextSize.h"
#import <CoreText/CoreText.h>
@implementation NSMutableAttributedString (CalculateTextSize)

- (CGSize)sizeWithFontName:(NSString *)fontName
                  fontSize:(CGFloat)fontSize
         constrainedToSize:(CGSize)constrainedSize{
    
    CTFontRef helvetica = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL);
    [self addAttribute:(id)kCTFontAttributeName
                 value:(id)helvetica
                 range:NSMakeRange(0, [self length])];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)self);
    
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,
                                                                   CFRangeMake(0, 0),
                                                                   NULL,
                                                                   constrainedSize,
                                                                   NULL);
    CFRelease(framesetter);
    
    return textSize;
}

@end
