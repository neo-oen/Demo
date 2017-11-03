//
//  CarModel.h
//  TableView
//
//  Created by neo on 2017/10/21.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CarModel : NSObject

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * icon;
@property(nonatomic,assign)CGFloat cellHeight;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)carWithDict:(NSDictionary *)dict;

+ (NSArray *)carsWithPath:(NSString *)path;
+ (NSArray *)carsWithArray:(NSArray *)array;


@end
