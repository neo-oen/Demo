//
//  CellModel.h
//  TableView
//
//  Created by neo on 2017/10/21.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CellModel : NSObject

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * icon;
@property(nonatomic,assign)CGFloat cellHeight;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cellWithDict:(NSDictionary *)dict;

+ (NSArray *)cellsWithPath:(NSString *)path;
+ (NSArray *)cellsWithArray:(NSArray *)array;


@end