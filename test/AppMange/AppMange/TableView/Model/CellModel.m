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

- (instancetype)initWithDict:(NSDictionary *)dict AndRange:(CGSize)size{
    
    self = [self initWithDict:dict];
    [self setFrameWithRange:size];
    return self;
    
}
+ (instancetype)cellWithDict:(NSDictionary *)dict AndRange:(CGSize)size{
    
    return [[self alloc]initWithDict:dict AndRange:size];
}

+ (NSArray *)cellsWithPath:(NSString *)path AndRange:(CGSize)size{
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellWithDict:dict AndRange:size]];
    }
    
    return arrayM;
}


 + (NSArray *)cellsWithPath:(NSString *)path AndDicType:(DicType)type AndRange:(CGSize)size{
 
 NSArray *array = [NSArray arrayWithContentsOfFile:path];
 NSMutableArray *arrayM = [NSMutableArray array];
 if (type) {
 for (NSDictionary *dict in array) {
 
 [arrayM addObject:[self cellWithDict:dict AndRange:size]];
 }
 
 }
     return arrayM;
 }


+ (NSArray *)cellsWithArray:(NSArray *)array AndRange:(CGSize)size{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellWithDict:dict AndRange:size]];
    }
    
    return arrayM;
}


#pragma mark - ============== 接口 ==============
-(void)setFrameWithRange:(CGSize)size{
    
    _cellWidth = size.width;

    [self getFrame];
    
}

#pragma mark - ============== 方法 ==============




-(void)getFrame{
    
    _imageViewFrame = CGRectMake(10, 5, 50, 50);
    CGSize nameLabelMaxSize = CGSizeMake(_cellWidth-50-20, MAXFLOAT);
    
    CGSize nameLabelSize =[_name boundingRectWithSize:nameLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    _nameLabelFrame.origin = CGPointMake(10+50+10, (50+10)*0.5-nameLabelSize.height);
    _nameLabelFrame.size = nameLabelSize;
    
    NSString * explanString = [NSString stringWithFormat:@"大小:%@ | 下载量:%@",_size,_download];
    
    CGSize explanLabelSize =[explanString boundingRectWithSize:nameLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    _explanLabelFrame.origin = CGPointMake(10+50+10, 50+10-explanLabelSize.height);
    _explanLabelFrame.size = explanLabelSize;
    
    _downloadButtonFrame = CGRectMake(_cellWidth - 40-10, (50+10 - 20)*0.5, 40, 20);
    
    _cellHeight = 50+10;
    _LineViewFrame = CGRectMake(0, _cellHeight - 2, _cellWidth, 2);
    
    
}

-(NSString *)description{
    return [NSString stringWithFormat:@"cellname=%@",_name];
}


@end

