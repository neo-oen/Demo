//
//  PinYinToT9Number.h
//  CTPIM
//
//  Created by Kevin Zhang、yingxin fu on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinYinToT9Number : NSObject

+ (NSString*)pinyinToT9Number:(NSString*)string;

int charToNumber(char code);

@end
