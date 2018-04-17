//
//  NSString+Extension.h
//  HBZS_IOS
//
//  Created by zimbean on 15/11/23.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/** 汉字转拼音(输入汉字，转出每个字拼音的首字母，拼成字符串) */
- (NSString *)chineseToPinYin;

@end
