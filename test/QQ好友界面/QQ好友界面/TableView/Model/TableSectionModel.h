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

@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * desc;
@property(nonatomic,copy)NSArray * cells;//列表里有数组
//给tableview特殊
@property(nonatomic,assign,readonly)CGFloat  headerHeight;
@property(nonatomic,assign,readonly)CGFloat footerHeight;
@property(nonatomic,assign,getter=cellHiddenState)BOOL cellHidden;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cellBrandWithDict:(NSDictionary *)dict;

+ (NSArray *)cellBrandsWithPath:(NSString *)path;
+ (NSArray *)cellBrandsWithArray:(NSArray *)array;


@end
