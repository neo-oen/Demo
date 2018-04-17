//
//  NSMutableAttributedString+CalculateTextSize.h
//  HBZS_IOS
//
//  Created by zimbean on 14-6-27.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (CalculateTextSize)

- (CGSize)sizeWithFontName:(NSString *)fontName
                  fontSize:(CGFloat)fontSize
         constrainedToSize:(CGSize)constrainedSize;
@end
