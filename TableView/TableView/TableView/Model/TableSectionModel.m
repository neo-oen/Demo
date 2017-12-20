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
        _cells = [CellModel cellsWithArray:_cells AndRange:CGPointMake(_headerWidth, _headerHeight)];//判断属性里有无数组
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

- (instancetype)initWithDict:(NSDictionary *)dict AndRange:(CGPoint)widthHeight{
    
    self = [self initWithDict:dict];
    [self setFrameWithRange:widthHeight];
    return self;
    
}
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict AndRange:(CGPoint)widthHeight{
    
    return [[self alloc]initWithDict:dict AndRange:widthHeight];
}



//需要时打开
 + (NSArray *)cellBrandsWithPath:(NSString *)path andDicType:(DicType)type AndRange:(CGPoint)widthHeight{
 
 NSArray *array = [NSArray arrayWithContentsOfFile:path];
 NSMutableArray *arrayM = [NSMutableArray array];
 if (type) {
 for (NSDictionary *dict in array) {
 
 [arrayM addObject:[self cellBrandWithDict:dict AndRange:widthHeight]];
 }
 return arrayM;
 
 }else{
 
     TableSectionModel * sectionModel = [[self alloc]init];
     sectionModel.cells = [CellModel cellsWithArray:array AndRange:(CGPoint)widthHeight];
     return @[sectionModel];
 }
 
 }
+ (NSArray *)cellBrandsWithArray:(NSArray *)array AndRange:(CGPoint)widthHeight{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellBrandWithDict:dict AndRange:widthHeight]];
    }
    
    return arrayM;
}




#pragma mark - ============== 方法 ==============


-(void)setFrameWithRange:(CGPoint)widthHeight{
    
    _headerWidth = widthHeight.x;
    _headerHeight = widthHeight.y;
    _footerWidth = widthHeight.x;
    _footerHeight = widthHeight.y;
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
    return [NSString stringWithFormat:@"brandTitle=%@-brandDesc=%@-cells=%@",_title,_desc,_cells];
}


@end
