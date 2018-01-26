//
//  shopCellModel.h
//  collectionView
//
//  Created by neo on 2018/1/9.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopCellModel : NSObject

@property(nonatomic,assign)NSInteger  h;
@property(nonatomic,assign)NSInteger  w;

@property(nonatomic,copy)NSString * img;

@property(nonatomic,copy)NSString * price;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)goodWithDict:(NSDictionary *)dict;

+ (NSArray *)goodsWithPath:(NSString *)path;
+ (NSArray *)goodsWithArray:(NSArray *)array;


@end
