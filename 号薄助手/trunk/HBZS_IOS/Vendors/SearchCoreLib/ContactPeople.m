//
//  ContactPeople.m
//  SearchCoreTest
//
//  Created by Apple on 28/01/13.
//  Copyright (c) 2013 kewenya. All rights reserved.
//

#import "ContactPeople.h"

@implementation ContactPeople

@synthesize lastName;

@synthesize firstName;

@synthesize contactId;

@synthesize contactGroupID;

@synthesize localID;

@synthesize name;

@synthesize phoneArray;

@synthesize highlightRange;

- (void)dealloc
{
    self.lastName = nil;
    self.firstName = nil;
    
    self.localID = nil;
    self.name = nil;
    self.phoneArray = nil;
    
    [super dealloc];
}

@end
