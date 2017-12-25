//
//  TableSectionModel.m
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "TableSectionModel.h"




@implementation TableSectionModel

#pragma mark - ============== 初始化 ==============



- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        _friends = [CellModel cellsWithArray:_friends];//判断属性里有无数组
        _cells = _friends;
        _cellHidden = YES;
    }
    return self;
}

+ (instancetype)cellBrandWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}


+ (NSArray *)cellBrandsWithPath:(NSString *)path AndDicType:(DicType)type
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
        sectionModel.friends = [CellModel cellsWithArray:array];
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
    
    self = [self initWithDict:dict];
    [self setFrameExtendWithRange:size];
    return self;
    
}
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict AndRange:(CGSize)size{
    
    return [[self alloc]initWithDict:dict AndRange:size];
}

+ (NSArray *)cellBrandsWithPath:(NSString *)path AndRange:(CGSize)size{
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self cellBrandWithDict:dict AndRange:size]];
    }
    
    return arrayM;
}


+ (NSArray *)cellBrandsWithPath:(NSString *)path AndDicType:(DicType)type AndRange:(CGSize)size{
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arrayM = [NSMutableArray array];
    if (type) {
        for (NSDictionary *dict in array) {
            
            [arrayM addObject:[self cellBrandWithDict:dict AndRange:size]];
        }
        return arrayM;
        
    }else{
        
        TableSectionModel * sectionModel = [[self alloc]init];
        sectionModel.friends = [CellModel cellsWithArray:array AndRange:size];
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


#pragma mark - ============== 接口 ==============

-(void)setFrameWithRange:(CGSize)size{
    
    _headerWidth = size.width;
    [self getFrame];
    
}

-(void)setFrameExtendWithRange:(CGSize)size{
    for (CellModel * model in self.friends) {
        [model setFrameWithRange:size];
    }
    [self setFrameWithRange:size];
    
}


-(NSString *)description{
    return [NSString stringWithFormat:@"<%@:        %p> {组名=%@,在线人数=%@,所有cell=%@,onlineLabelFrame=%@}",self.class,self,self.name,self.online,self.friends,NSStringFromCGRect(self.onlineLabelFrame)];
}
#pragma mark - ============== 方法 ==============



-(void)getFrame{
    
    

        _headerButtonFrame = CGRectMake(0, 0, _headerWidth, 30);
        NSString * string =  [NSString stringWithFormat:@"%@/%ld",self.online,self.friends.count];
        
        _onlineLabelFrame.size = [string boundingRectWithSize:CGSizeMake(_headerWidth-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size;
        
        _onlineLabelFrame.origin = CGPointMake(_headerWidth - _onlineLabelFrame.size.width, 0);
        
    _headerHeight = 30;
    
}



@end
