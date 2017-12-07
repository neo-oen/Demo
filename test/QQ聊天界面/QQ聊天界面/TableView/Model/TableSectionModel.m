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

//@implementation TableSectionModel
//
//@end



@interface <#class name#> : NSObject
typedef NS_ENUM(NSUInteger, <#MyEnum#>) {
    <#MyEnumValueA#>,
};

@property(nonatomic,copy)NSString * <#key#>;
@property(nonatomic,copy)NSArray * <#name#>s;//列表里有数组


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)<#name#>WithDict:(NSDictionary *)dict;

+ (NSArray *)<#name#>sWithPath:(NSString *)path<#andDicType:(dicType)type#>;//判断字典类型判断
+ (NSArray *)<#name#>sWithArray:(NSArray *)array;


//frame所需的属性（这个可以做输出，也可以当限制）

@property(nonatomic,assign,readonly)CGFloat <#xxx#>Width;
@property(nonatomic,assign,readonly)CGFloat  <#xxx#>Height;

-(void)setFrameWithWidthAndHeight:(CGPoint)widthHeight;
//连带初始化frame

- (instancetype)initWithDict:(NSDictionary *)dict AndRange:(CGPoint)widthHeight;
+ (instancetype)<#name#>WithDict:(NSDictionary *)dict AndRange:(CGPoint)widthHeight;

+ (NSArray *)<#name#>sWithPath:(NSString *)path<#andDicType:(dicType)type#> AndRange:(CGPoint)widthHeight;
+ (NSArray *)<#name#>sWithArray:(NSArray *)array AndRange:(CGPoint)widthHeight;

@end

@implementation <#class#>

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        _<#name#>s = [<#Class name#> <#name#>sWithArray:_<#name#>s];//判断属性里有无数组
    }
    return self;
}

+ (instancetype)<#name#>WithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

+ (NSArray *)<#name#>sWithPath:(NSString *)path
{
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self <#name#>WithDict:dict]];
    }
    
    return arrayM;
}

+(NSArray *)<#name#>sWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self <#name#>WithDict:dict]];
    }
    
    return arrayM;
}

@end
