//
//  SearchItem.m
//  HBZS_IOS
//
//  Created by Kevin Zhang、yingxin on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchItem.h"

@implementation SearchItem

@synthesize contactID;

@synthesize contactType;

@synthesize contactGroupID;

@synthesize contactFirstName;

@synthesize contactFullName;

@synthesize contactLastName;

@synthesize contactSearch;

@synthesize contactSearchSimple;
//new:
@synthesize chineseFirstNamePY;

@synthesize chineseFirstName;

@synthesize contactT9Search;

@synthesize contactT9SearchSimple;

@synthesize contactSearchArray;

@synthesize contactLastSaveTime;

@synthesize contactPhoneArray;

@synthesize contactEmailArray;

@synthesize callLogTime;

@synthesize callLogType;

//new
@synthesize keyRange;

@synthesize rangeArray;

+ (SearchItem*)searchItemAlloc{
  return [[[SearchItem alloc]init]autorelease];
}

@end
