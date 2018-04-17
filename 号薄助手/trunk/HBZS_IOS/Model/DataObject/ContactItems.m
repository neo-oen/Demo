//
//  ContactItems.m
//  HBZS_IOS
//
//  Created by Kevin Zhang、yingxin on 12-4-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContactItems.h"

#pragma mark GroupItem
@implementation GroupItem

@synthesize groupName;

@synthesize groupID;

+ (GroupItem*)groupItemAlloc{
    return [[[GroupItem alloc]init]autorelease];
}

- (void)dealloc{
    if (groupName) {
        [groupName release];
        
        groupName = nil;
    }
    
	[super dealloc];
}

@end

#pragma mark DialItem
@implementation DialItem

@synthesize name;

@synthesize phone;

@synthesize times;

@synthesize contactID;

- (void)dealloc{
    if (times) {
        [times release];
        
        times = nil;
    }
    
	[super dealloc];
}

+ (DialItem*)dialItemAlloc{
    return [[[DialItem alloc]init]autorelease];
}

- (id)init{
    self = [super init];
    
    if (self) {
        times = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self.name = [decoder decodeObjectForKey:@"_name"];
    
    self.phone = [decoder decodeObjectForKey:@"_phone"];
    
    self.times =  [decoder decodeObjectForKey:@"_times"];
    
    self.contactID = [decoder decodeIntegerForKey:@"_contactid"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"_name"];
    
    [encoder encodeObject:self.phone forKey:@"_phone"];
    
    [encoder encodeObject:self.times forKey:@"_times"];
    
    [encoder encodeInteger:self.contactID forKey:@"_contactid"];
    
}


@end


#pragma mark ContactMember
@implementation ContactMember

@synthesize name;

@synthesize phone;

@synthesize ID;

+ (ContactMember*)contactMemberAlloc{
    return [[[ContactMember alloc]init]autorelease];
}

- (void)dealloc{
//    [name release];
//    
//    [phone release];
    
    [super dealloc];
}

@end


#pragma mark ContactInfoItem
@implementation ContactInfoItem

@synthesize typeName;

@synthesize content;

@synthesize count;

- (void)dealloc{
//    if (typeName) {
//        [typeName release];
//        
//        typeName = nil;
//    }
//    
//    if (content) {
//        [content release];
//        
//        content = nil;
//    }
    
    [super dealloc];
}

+ (ContactInfoItem*)contaceInfoItemAlloc{
    return [[[ContactInfoItem alloc]init]autorelease];
}

@end

#pragma mark CustomIPItem
@implementation CustomIPItem

@synthesize number;

@synthesize name;

- (void)dealloc{
    if (number) {
        [number release];
        
        number = nil;
    }
    
    if (name) {
        [name release];
        
        name = nil;
    }
    
    [super dealloc];
}

+ (CustomIPItem*)customIPItemAlloc{
    return [[[CustomIPItem alloc]init]autorelease];
}

@end

#pragma mark CustomServiceItem
@implementation CustomServiceItem

@synthesize ID;

@synthesize nickname;

@synthesize content;

@synthesize time;

@synthesize replycontentid;

@synthesize userreplysatisfactory;

@synthesize satisfactorydate;

- (void)dealloc{
    if (ID) {
        [ID release];
        
        ID = nil;
    }
    
    if (nickname) {
        [nickname release];
        
        nickname = nil;
    }
    
    if (content) {
        [content release];
        
        content = nil;
    }
    
    if (time) {
        [time release];
        
        time = nil;
    }
    
    if (satisfactorydate) {
        [satisfactorydate release];
        
        satisfactorydate = nil;
    }
    
    [super dealloc];
}

+ (CustomServiceItem*)customServiceItemAlloc{
    return [[[CustomServiceItem alloc]init]autorelease];
}

@end

//ContactItems
@implementation ContactItems

@end
