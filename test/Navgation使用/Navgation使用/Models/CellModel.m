//
//  CellModel.m
//  Navgation使用
//
//  Created by neo on 2018/1/19.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "CellModel.h"

@implementation CellModel

- (instancetype)initWithName:(NSString *)name andPhone:(NSString *)phone;{
    self = [super init];
    if (self) {
        self.name = name;
        self.phone = phone;
    }
    return self;
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)cellWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)cellsWithPath:(NSString *)path
{
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellWithDict:dict]];
    }
    
    return arrayM;
}

+(NSArray *)cellsWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellWithDict:dict]];
    }
    
    return arrayM;
}
#pragma mark - ============== 协议 ==============

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phone=[aDecoder decodeObjectForKey:@"phone"];
    }
    
    return self;
}


@end
