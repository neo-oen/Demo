//
//  MyString.m
//  CTPIM
//
//  Created by  Kevin Zhang、 scanmac on 11-9-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MyString.h"

@implementation MyString

+ (BOOL)checkIsNumberString:(NSMutableString *)sourceStr{
    BOOL isNumberString = NO;
    
    if ([sourceStr stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]].length > 0) {
        
    }
    else{
        isNumberString = YES;
    }
    
    return isNumberString;
}

+ (BOOL)filterToNumberString:(NSMutableString*) sourceStr{
    
    if (sourceStr == nil || [sourceStr length] <= 0){
        return NO;
    }
    
    NSInteger sourceLen = [sourceStr length];
    
    char ch;
    
    for (int i = 0, j = 0; i < sourceLen; i ++){
        ch = [sourceStr characterAtIndex:j];
        
        if (ch >= '0' && ch <= '9'){
            j++;
            
            continue;
        }
        
        NSString *str = [[NSString alloc] initWithFormat:@"%c",ch];
        
        NSRange range;
        
        range = [sourceStr rangeOfString: str];
        
        [str release];
        
        if (range.length > 0){
            [sourceStr deleteCharactersInRange:range];
        }
    }
    
    return YES;
}

@end
