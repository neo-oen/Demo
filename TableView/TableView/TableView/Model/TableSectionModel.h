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

@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * desc;
@property(nonatomic,copy)NSArray * cells;//列表里有数组

@property(nonatomic,assign,getter =iscellHiddened)BOOL cellHidden;//这样的值主要是由外界设置上的，不由字典里获取


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict;

+ (NSArray *)cellBrandsWithArray:(NSArray *)array;
+ (NSArray *)cellBrandsWithPath:(NSString *)path andDicType:(DicType)type;//判断字典类型判断


//frame所需的属性（这个可以做输出，也可以当限制）

@property(nonatomic,assign,readonly)CGFloat headerWidth;
@property(nonatomic,assign,readonly)CGFloat  headerHeight;
@property(nonatomic,assign,readonly)CGFloat footerWidth;
@property(nonatomic,assign,readonly)CGFloat  footerHeight;


-(void)setFrameWithRange:(CGPoint)widthHeight;
//连带初始化frame

- (instancetype)initWithDict:(NSDictionary *)dict AndRange:(CGPoint)widthHeight;
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict AndRange:(CGPoint)widthHeight;

+ (NSArray *)cellBrandsWithArray:(NSArray *)array AndRange:(CGPoint)widthHeight;
+ (NSArray *)cellBrandsWithPath:(NSString *)path andDicType:(DicType)type AndRange:(CGPoint)widthHeight;

@end
