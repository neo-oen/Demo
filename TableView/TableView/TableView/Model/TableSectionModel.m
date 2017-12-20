//
//  TableSectionModel.m
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "TableSectionModel.h"




@implementation TableSectionModel

#pragma mark - ============== 实现方法 ==============


- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        _cells = [CellModel cellsWithArray:_cells ];//判断属性里有无数组
        _cellHidden = YES;
    }
    return self;
}

+ (instancetype)cellBrandWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}




+ (NSArray *)cellBrandsWithPath:(NSString *)path andDicType:(DicType)type
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

- (instancetype)initWithDict:(NSDictionary *)dict AndRange:(CGSize)size{
    
//    self = [super init];
//    if (self) {
//        [self setValuesForKeysWithDictionary:dict];
//        _cells = [CellModel cellsWithArray:_cells AndRange:size];//判断属性里有无数组
//        _cellHidden = YES;
//    }
//    [self setFrameWithRange:size];
//    return self;
    
        self = [self initWithDict:dict];

        [self setFrameExtendWithRange:size];
    
        return  self;
    
}
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict AndRange:(CGSize)size{
    
    return [[self alloc]initWithDict:dict AndRange:size];
}



//需要时打开
+ (NSArray *)cellBrandsWithPath:(NSString *)path andDicType:(DicType)type AndRange:(CGSize)size{
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arrayM = [NSMutableArray array];
    if (type) {
        for (NSDictionary *dict in array) {
            
            [arrayM addObject:[self cellBrandWithDict:dict AndRange:size]];
        }
        return arrayM;
        
    }else{
        
        TableSectionModel * sectionModel = [[self alloc]init];
        sectionModel.cells = [CellModel cellsWithArray:array AndRange:size];
        return @[sectionModel];
    }
    
}
+ (NSArray *)cellBrandsWithArray:(NSArray *)array AndRange:(CGSize)size{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellBrandWithDict:dict AndRange:size]];
    }
    
    return arrayM;
}




#pragma mark - ============== 方法 ==============

-(void)setFrameExtendWithRange:(CGSize)size{
    
    for (CellModel * model in self.cells) {
        [model setFrameWithRange:size];
    }
    _headerWidth = size.width;
    _headerHeight = size.height;
    _footerWidth = size.width;
    _footerHeight = size.height;
    [self getFrame];
}

-(void)setFrameWithRange:(CGSize)size{
    
    _headerWidth = size.width;
    _headerHeight = size.height;
    _footerWidth = size.width;
    _footerHeight = size.height;
    [self getFrame];
    
}

-(void)getFrame{
    
    
    if (_headerWidth&& _headerHeight) {
        _headerHeight = 10 + 20;
    }
    if (_footerWidth&& _footerHeight) {
        _footerHeight = (arc4random()%10) + 20;
    }
    
}

-(NSString *)description{
    
    return [NSString stringWithFormat:@"brandTitle=%@,brandDesc=%@,cells=%@,andTitleFrame=%@",_title,_desc,_cells,NSStringFromCGSize(CGSizeMake(_headerWidth, _headerHeight))];
}


@end



