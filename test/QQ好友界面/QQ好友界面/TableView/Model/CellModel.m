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
    _cellHeight = size.height;
    [self getFrame];
    
}



-(NSString *)description{
    return [NSString stringWithFormat:@"<%@:        %p> {iconName=%@,name=%@,subtitle=%@,imageFrame=%@,nameFrame=%@,subTitleFrame=%@}",self.class,self,self.icon,self.name,self.intro,NSStringFromCGRect(_userImageViewFrame),NSStringFromCGRect(_nameLabelFrame),NSStringFromCGRect(_subLabelFrame)];
}
#pragma mark - ============== 方法 ==============

-(void)getFrame{
    
    
    if (_cellWidth&& _cellHeight) {
        _userImageViewFrame = CGRectMake(0, 0, 50, 50);
        
       _nameLabelFrame.size = [_name boundingRectWithSize:CGSizeMake(_cellWidth - 50 -10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        _nameLabelFrame.origin = CGPointMake(50+10, 5);
       _subLabelFrame.size = [_intro boundingRectWithSize:CGSizeMake(_cellWidth -50 -10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} context:nil].size;
        _subLabelFrame.origin = CGPointMake(50+10, CGRectGetMaxY(_nameLabelFrame) + 5);
        _cellHeight = CGRectGetMaxY(_subLabelFrame)>CGRectGetMaxY(_userImageViewFrame)?CGRectGetMaxY(_subLabelFrame):CGRectGetMaxY(_userImageViewFrame);
    }
    
}



@end


