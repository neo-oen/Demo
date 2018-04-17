//
//  NSString+Extension.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/23.
//
//

#import "NSString+Extension.h"
#import "pinyin.h"

@implementation NSString (Extension)

#pragma mark - 汉字转拼音(输入汉字，转出每个字拼音的首字母，拼成字符串)
/**
 * 汉字转拼音(输入汉字，转出每个字拼音的首字母，拼成字符串)
 */
- (NSString *)chineseToPinYin{
    NSArray * sourceStringArr=[self componentsSeparatedByString:@" "];
    NSString * sourceString=[sourceStringArr componentsJoinedByString:@""];
    NSString * str=[[[NSString alloc]init] autorelease];
    for (int i=0; i<sourceString.length; i++) {
        char c = pinyinFirstLetter([sourceString characterAtIndex:i]);
        str= [str stringByAppendingString:[NSString stringWithFormat:@"%c",c]];
    }
    str = [str uppercaseString];
    return str;
}



@end
