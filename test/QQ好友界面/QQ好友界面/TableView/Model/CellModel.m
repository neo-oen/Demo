//
//  CellModel.m
//  TableView
//
//  Created by neo on 2017/10/21.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "CellModel.h"


@implementation CellModel


#pragma mark - ============== 初始化 ==============
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        //frame和Height都在这里赋值
        [self getFrameAndHeight];
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

#pragma mark - ============== 方法 ==============

-(void)getFrameAndHeight{
    _userImageViewFrame = CGRectMake(10, 10, 50, 50);
    CGSize nameLabelMaxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    CGSize nameLabelSize =[_name boundingRectWithSize:nameLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    
    _nameLabelFrame.origin = CGPointMake(10+50+10, 50*0.5+10-nameLabelSize.height*0.5);
    _nameLabelFrame.size = nameLabelSize;
    
    _cellHeight = 50+10;
}


@end


