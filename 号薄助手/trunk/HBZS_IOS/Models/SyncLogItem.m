//
//  SyncLogItem.m
//  HBZS_IOS
//
//  Created by Kevin Zhang、yingxin fu on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SyncLogItem.h"

@implementation SyncLogItem

@synthesize syncType;

@synthesize startTime;

@synthesize endTime;

@synthesize syncResult;

- (void)dealloc
{
    if (syncType) {
        [syncType release];
        
        syncType = nil;
    }
    
    if (startTime) {
        [startTime release];
        
        startTime = nil;
    }
    
    if (endTime) {
        [endTime release];
        
        endTime = nil;
    }
    
    if (syncResult) {
        [syncResult release];
        
        syncResult = nil;
    }
    
    [super dealloc];
}

+ (SyncLogItem*)syncLogItemAlloc{
    return [[[SyncLogItem alloc]init]autorelease];
}


- (id)initWithCoder:(NSCoder *)decoder
{
    self.syncType = [decoder decodeObjectForKey:@"_type"];
    
    self.startTime = [decoder decodeObjectForKey:@"_starttime"];
    
    self.endTime =  [decoder decodeObjectForKey:@"_endtime"];
    
    self.syncResult = [decoder decodeObjectForKey:@"_syncresult"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.syncType forKey:@"_type"];
    
    [encoder encodeObject:self.startTime forKey:@"_starttime"];
    
    [encoder encodeObject:self.endTime forKey:@"_endtime"];
    
    [encoder encodeObject:self.syncResult forKey:@"_syncresult"];
}



@end
