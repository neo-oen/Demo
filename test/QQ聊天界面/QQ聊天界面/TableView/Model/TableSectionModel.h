//
//  TableSectionModel.h
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, dicType) {
    diclevel = 0,
    diclevels,
};
@interface TableSectionModel : NSObject

@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * desc;
@property(nonatomic,copy)NSArray * cells;//列表里有数组
//给tableview特殊
@property(nonatomic,assign,readonly)CGFloat  headerWidth;
@property(nonatomic,assign,readonly)CGFloat footerWidth;
@property(nonatomic,assign,readonly)CGFloat  headerHeight;
@property(nonatomic,assign,readonly)CGFloat footerHeight;


//只初始化数据


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict;

+ (NSArray *)cellBrandsWithPath:(NSString *)path andDicType:(dicType)type;
+ (NSArray *)cellBrandsWithArray:(NSArray *)array;


-(void)setFrameWithWidthAndHeight:(CGPoint)widthHeight;
//连带初始化frame





@end
