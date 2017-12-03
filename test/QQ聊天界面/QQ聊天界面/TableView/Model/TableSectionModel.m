//
//  TableSectionModel.m
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "TableSectionModel.h"
#import "CellModel.h"




@implementation TableSectionModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        _cells = [CellModel cellsWithArray:_cells];//判断属性里有无数组
        [self getFrameAndHeight];
    }
    return self;
}

+ (instancetype)cellBrandWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)cellBrandsWithPath:(NSString *)path
{
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellBrandWithDict:dict]];
    }
    
    return arrayM;
}

+(NSArray *)cellBrandsWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellBrandWithDict:dict]];
    }
    
    return arrayM;
}

+(instancetype)cellBrandWithPath:(NSString *)path{
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    TableSectionModel * sectionModel = [[self alloc]init];
    sectionModel.cells = [CellModel cellsWithArray:array];
    [sectionModel getFrameAndHeight];
    return sectionModel;
}

#pragma mark - ============== 方法 ==============


-(void)getFrameAndHeight{
    
    _headerHeight = 0;
    _footerHeight = 0;
    
    if (_title&&_desc) {
        _headerHeight = (arc4random()%10) + 20;
        _footerHeight = (arc4random()%10) + 20;
    }
    
}

@end

//@implementation TableSectionModel
//
//@end
