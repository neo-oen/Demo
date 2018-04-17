//
//  NameIndex.m
//  MyChineseBookAddressSort
//
//  Created by jian on 7/21/11.
//  Copyright 2011 com.HopeRun. All rights reserved.
//

#import "NameIndex.h"


@implementation NameIndex

@synthesize _firstName;

@synthesize _lastName;

@synthesize fullName;

@synthesize _phoneStr;

@synthesize _sectionNum;

@synthesize _originIndex;

@synthesize _contactID;

@synthesize _groupID;

@synthesize keyRange;

@synthesize rangeArray;

- (void)dealloc {
	if (_firstName) {
        [_firstName release];
        
        _firstName = nil;
    }
    
    if (_lastName) {
        [_lastName release];
        
        _lastName = nil;
    }
    
    if (_phoneStr) {
        [_phoneStr release];
        
        _phoneStr = nil;
    }
    
	[super dealloc];
}


- (NSString *) getFirstName {
  
	if ([_firstName canBeConvertedToEncoding: NSASCIIStringEncoding])
    {//如果是英语
		return _firstName;
	}
	else
    { //如果是非英语
		return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_firstName characterAtIndex:0])];
	}
}

- (NSString *) getLastName {
    if (_lastName.length == 0) {
       _lastName = @"未命名";
    }
    
	if ([_lastName canBeConvertedToEncoding:NSASCIIStringEncoding]) {//_lastName
		return _lastName;//_lastName
	}
	else
    {
		return [NSString stringWithFormat:@"%c",pinyinFirstLetter([_lastName characterAtIndex:0])];//_lastName
	}
}

- (NSString *) getStrName{
    NSString *tmp = [NSString stringWithFormat:@"%@%@", _lastName, _firstName];
    
    NSString *str = nil;
    
    BOOL bHanzi = YES;
    
    if ([tmp length] <= 0) {
        return nil;
    }
    
    //判断第一个字母为中文或英文
    if ([tmp canBeConvertedToEncoding:NSASCIIStringEncoding])
    {
		return [NSString stringWithFormat:@"0%@", tmp];
    }
    
    NSString *strfirst = [tmp substringWithRange:NSMakeRange(0, 1)];
    
    if ([strfirst canBeConvertedToEncoding:NSASCIIStringEncoding])
    {
        str = [NSString stringWithFormat:@"%@", @"0"];
    }
    else
    {
        bHanzi = YES;
        
        str = [NSString stringWithFormat:@"%@", @"1"];
    }
    
    for (NSInteger i = 0; i < [tmp length]; i++)
    {
        str = [NSString stringWithFormat:@"%@%c", str, pinyinFirstLetter([tmp characterAtIndex:i])];
        
        if (bHanzi) {
            str = [NSString stringWithFormat:@"%@%@", str, @"|"];
            
            break;
        }
    }
    
    return str;
}


@end
