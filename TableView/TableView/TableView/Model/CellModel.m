//
//  CellModel.m
//  TableView
//
//  Created by neo on 2017/10/21.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "CellModel.h"



@implementation CellModel

#pragma mark - ============== 实现方法 ==============


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


 + (NSArray *)cellsWithPath:(NSString *)path AndDicType:(DicType)type
 {
 NSArray *array = [NSArray arrayWithContentsOfFile:path];
 NSMutableArray *arrayM = [NSMutableArray array];
 if (type) {
 for (NSDictionary *dict in array) {
 
 [arrayM addObject:[self cellWithDict:dict]];
 }
 
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

//连带初始化frame

- (instancetype)initWithDict:(NSDictionary *)dict AndRange:(CGPoint)widthHeight{
    
    self = [self initWithDict:dict];
    [self setFrameWithRange:widthHeight];
    return self;
    
}
+ (instancetype)cellWithDict:(NSDictionary *)dict AndRange:(CGPoint)widthHeight{
    
    return [[self alloc]initWithDict:dict AndRange:widthHeight];
}

+ (NSArray *)cellsWithPath:(NSString *)path AndRange:(CGPoint)widthHeight{
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellWithDict:dict AndRange:widthHeight]];
    }
    
    return arrayM;
}


 + (NSArray *)cellsWithPath:(NSString *)path AndDicType:(DicType)type AndRange:(CGPoint)widthHeight{
 
 NSArray *array = [NSArray arrayWithContentsOfFile:path];
 NSMutableArray *arrayM = [NSMutableArray array];
 if (type) {
 for (NSDictionary *dict in array) {
 
 [arrayM addObject:[self cellWithDict:dict AndRange:widthHeight]];
 }
 
 }
     return arrayM;
 }


+ (NSArray *)cellsWithArray:(NSArray *)array AndRange:(CGPoint)widthHeight{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellWithDict:dict AndRange:widthHeight]];
    }
    
    return arrayM;
}


#pragma mark - ============== 接口 ==============
-(void)setFrameWithRange:(CGPoint)widthHeight{
    
    _cellWidth = widthHeight.x;
    _cellHeight = widthHeight.y;
    [self getFrame];
    
}

#pragma mark - ============== 方法 ==============




-(void)getFrame{
    
    
    if (_cellWidth&& _cellHeight) {
        _userImageViewFrame = CGRectMake(10, 10, 50, 50);
        CGSize nameLabelMaxSize = CGSizeMake(_cellWidth, MAXFLOAT);
        
        CGSize nameLabelSize =[_name boundingRectWithSize:nameLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        
        _nameLabelFrame.origin = CGPointMake(10+50+10, 50*0.5+10-nameLabelSize.height*0.5);
        _nameLabelFrame.size = nameLabelSize;
        
        _cellHeight = 50+10;
    }
    
}

-(NSString *)description{
    return [NSString stringWithFormat:@"cellname=%@",_name];
}


@end

