//
//  TableSectionModel.h
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellModel.h"
#import <UIKit/UIKit.h>

@interface TableSectionModel : NSObject

@property(nonatomic,copy)NSString * name;
@property(nonatomic,strong)NSNumber * online;
@property(nonatomic,strong)NSArray * friends;//列表里有数组
@property(nonatomic,strong)NSArray * cells;//cell =friends

@property(nonatomic,assign,getter=cellHiddenState)BOOL cellHidden;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict;

+ (NSArray *)cellBrandsWithPath:(NSString *)path AndDicType:(DicType)type;//判断字典类型判断
+ (NSArray *)cellBrandsWithArray:(NSArray *)array;

//frame所需的属性（这个可以做输出，也可以当限制）

@property(nonatomic,assign,readonly)CGFloat  headerHeight;
@property(nonatomic,assign,readonly)CGFloat headerWidth;


@property(nonatomic,assign,readonly)CGRect  headerButtonFrame;
@property(nonatomic,assign,readonly)CGRect  onlineLabelFrame;

-(void)setFrameWithRange:(CGSize)size;
-(void)setFrameExtendWithRange:(CGSize)size;
//连带初始化frame

- (instancetype)initWithDict:(NSDictionary *)dict AndRange:(CGSize)size;
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict AndRange:(CGSize)size;

+ (NSArray *)cellBrandsWithPath:(NSString *)path AndDicType:(DicType)type AndRange:(CGSize)size;
+ (NSArray *)cellBrandsWithArray:(NSArray *)array AndRange:(CGSize)size;


@end

