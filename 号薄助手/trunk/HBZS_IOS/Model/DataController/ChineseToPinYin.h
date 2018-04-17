//
//  ChineseToPinYin.h
//  CTPIM
//
//  Created by Kevin Zhang、 scanmac on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

@interface ChineseToPinYin : NSObject{
  
}

+ (NSMutableArray*)stringToPinYin:(NSString *)string;

+ (NSString*)pinyinFromChiniseString:(NSString *)string;

+ (NSString*)pinyinSimpleChiniseString:(NSString*)string;

+ (char)sortSectionTitle:(NSString *)string;

@end
