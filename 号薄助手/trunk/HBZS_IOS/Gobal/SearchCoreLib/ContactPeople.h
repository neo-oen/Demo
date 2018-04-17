//
//  ContactPeople.h
//  SearchCoreTest
//
//  Created by Apple on 28/01/13.
//  Copyright (c) 2013 kewenya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactPeople : NSObject {
    
}

@property (nonatomic,assign) NSInteger contactGroupID;

@property (nonatomic,retain) NSNumber *localID;

@property (nonatomic,retain) NSString *name;

@property (nonatomic,retain) NSString *lastName;

@property (nonatomic,retain) NSString *firstName;

@property (nonatomic,assign) NSInteger contactId;

@property (nonatomic,retain) NSMutableArray *phoneArray;

@property (nonatomic,assign) NSRange highlightRange;

@end
