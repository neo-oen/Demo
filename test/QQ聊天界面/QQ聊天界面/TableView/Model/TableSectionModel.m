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


#pragma mark - ============== 实现方法 ==============
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        _cells = [CellModel cellsWithArray:_cells];//判断属性里有无数组
    }
    return self;
}

+ (instancetype)cellBrandWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)cellBrandsWithPath:(NSString *)path andDicType:(dicType)type
{
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arrayM = [NSMutableArray array];
    if (type) {
        for (NSDictionary *dict in array) {
            
            [arrayM addObject:[self cellBrandWithDict:dict]];
        }
         return arrayM;
        
    }else{

        TableSectionModel * sectionModel = [[self alloc]init];
        sectionModel.cells = [CellModel cellsWithArray:array];
        return @[sectionModel];
    }
    
}

+(NSArray *)cellBrandsWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellBrandWithDict:dict]];
    }
    
    return arrayM;
}

//连带初始化frame
- (instancetype)initWithDict:(NSDictionary *)dict AndHeight:(CGPoint)widthHeight{
    
    self = [self initWithDict:dict];
    [self setFrameWithWidthAndHeight:widthHeight];
    return self;
    
}
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict AndHeight:(CGPoint)widthHeight{
    
    return [[self alloc]initWithDict:dict AndHeight:widthHeight];
}

+ (NSArray *)cellBrandsWithPath:(NSString *)path andDicType:(dicType)type AndHeight:(CGPoint)widthHeight{
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arrayM = [NSMutableArray array];
    if (type) {
        for (NSDictionary *dict in array) {
            
           [arrayM addObject:[self cellBrandWithDict:dict AndHeight:widthHeight]];
        }
        return arrayM;
        
    }else{
        
        TableSectionModel * sectionModel = [[self alloc]init];
        sectionModel.cells = [CellModel cellsWithArray:array WithWidthAndHeight:widthHeight];
        return @[sectionModel];
    }
    
}
+ (NSArray *)cellBrandsWithArray:(NSArray *)array AndHeight:(CGPoint)widthHeight{

    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellBrandWithDict:dict AndHeight:widthHeight]];
    }
    
    return arrayM;
}





#pragma mark - ============== 方法 ==============




-(void)setFrameWithWidthAndHeight:(CGPoint)widthHeight{
    
    _footerWidth = widthHeight.x;
    _headerWidth = widthHeight.x;
    _footerHeight = widthHeight.y;
    _headerHeight = widthHeight.y;
    [self getFrameAndHeight];
    
}


-(void)getFrameAndHeight{
    

    
    if (_title&&_desc) {
        _headerHeight = (arc4random()%10) + 20;
        _footerHeight = (arc4random()%10) + 20;
    }
    
}

@end


