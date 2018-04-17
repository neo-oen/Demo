//
//  PinYinToT9Number.m
//  CTPIM
//
//  Created by Kevin Zhang、yingxin fu on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PinYinToT9Number.h"

@implementation PinYinToT9Number


+ (NSString*)pinyinToT9Number:(NSString*)string{
    
    if( !string || ![string length] ) return nil;
	
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingGB_18030_2000);
    
	NSData * gb2312_data = [string dataUsingEncoding:enc];
	
    NSMutableString * strValue = [[[NSMutableString alloc] initWithString:@""] autorelease];
    
	char * gb2312_string = (char *)[gb2312_data bytes];
    
    int iLen = strlen(gb2312_string);
    
    for (int i=0; i< iLen; i++)
    {
        int icode = charToNumber(gb2312_string[i]);
        
        if (icode>0)
        {
            [strValue appendFormat:@"%d", icode];
        }
    }
	
	return [[[NSString alloc] initWithString:strValue] autorelease];
}

int charToNumber(char code)
{
    int returnValue = -1 ;
    
    switch (code) {
        case 'A':
        case 'B':
        case 'C':
            returnValue = 2 ;
            break;
        case 'D':
        case 'E':
        case 'F':
            returnValue = 3 ;
            break;
        case 'G':
        case 'H':
        case 'I':
            returnValue = 4 ;
            break;
        case 'J':
        case 'K':
        case 'L':
            returnValue = 5;
            break;
        case 'M':
        case 'N':
        case 'O':
            returnValue = 6 ;
            break ;
        case 'P':
        case 'Q':
        case 'R':
        case 'S':
            returnValue = 7 ;
            break ;
        case 'T':
        case 'U':
        case 'V':
            returnValue = 8 ;
            break ;
        case 'W':
        case 'X':
        case 'Y':
        case 'Z':
            returnValue = 9 ;
            break;
        default:
            returnValue = 0 ;
            break;
    }
    
    return returnValue;
}

@end
