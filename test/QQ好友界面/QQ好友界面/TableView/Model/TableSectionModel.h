//
//  TableSectionModel.h
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@interface TableSectionModel : NSObject

@property(nonatomic,copy)NSString * name;
@property(nonatomic,strong)NSNumber * online;
@property(nonatomic,strong)NSArray * friends;//列表里有数组
//给tableview特殊
@property(nonatomic,assign,readonly)CGFloat  headerHeight;
@property(nonatomic,assign,readonly)CGFloat footerHeight;
@property(nonatomic,assign,getter=cellHiddenState)BOOL cellHidden;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict;

+ (NSArray *)cellBrandsWithPath:(NSString *)path;
+ (NSArray *)cellBrandsWithArray:(NSArray *)array;


@end
