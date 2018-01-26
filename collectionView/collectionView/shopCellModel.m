//
//  shopCellModel.m
//  collectionView
//
//  Created by neo on 2018/1/9.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "shopCellModel.h"


@implementation shopCellModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)goodWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)goodsWithPath:(NSString *)path
{
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self goodWithDict:dict]];
    }
    
    return arrayM;
}

+(NSArray *)goodsWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self goodWithDict:dict]];
    }
    
    return arrayM;
}

@end
