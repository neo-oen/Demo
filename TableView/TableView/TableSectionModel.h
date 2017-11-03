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
@property(nonatomic,copy)NSArray * cars;//列表里有数组
//给tableview特殊
@property(nonatomic,assign)CGFloat  headerHeight;
@property(nonatomic,assign)CGFloat footerHeight;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)carBrandWithDict:(NSDictionary *)dict;

+ (NSArray *)carBrandsWithPath:(NSString *)path;
+ (NSArray *)carBrandsWithArray:(NSArray *)array;


@end
