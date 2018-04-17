//  姓名索引
//  NameIndex.h
//  MyChineseBookAddressSort
//
//  Created by jian on 7/21/11.
//  Copyright 2011 com.HopeRun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"


@interface NameIndex : NSObject {
    
}

@property(nonatomic,retain) NSString *fullName;

@property (nonatomic, retain) NSString *_lastName;

@property (nonatomic, retain) NSString *_firstName;

@property (nonatomic, retain) NSString *_phoneStr;

@property (nonatomic) NSInteger _sectionNum;

@property (nonatomic) NSInteger _originIndex;

@property (nonatomic) NSInteger _contactID;

@property (nonatomic) NSInteger _groupID;

@property(nonatomic) NSRange keyRange;

@property(nonatomic,retain) NSMutableArray *rangeArray;

- (NSString *) getFirstName;

- (NSString *) getLastName;

- (NSString *) getStrName;


@end
