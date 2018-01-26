//
//  MapShengModel.m
//  PickerView
//
//  Created by neo on 2018/1/11.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "MapShengModel.h"


@implementation MapShengModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)shengWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)shengsWithPath:(NSString *)path
{
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self shengWithDict:dict]];
    }
    
    return arrayM;
}

+(NSArray *)shengsWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self shengWithDict:dict]];
    }
    
    return arrayM;
}

@end
