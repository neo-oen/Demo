//
//  ProjuctModel.h
//  主流框架SB
//
//  Created by 王雅强 on 2018/2/28.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjuctModel : NSObject

@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * key;
@property(nonatomic,copy)NSString * image;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)projuctWithDict:(NSDictionary *)dict;

+ (NSArray *)projuctsWithPath:(NSString *)path;
+ (NSArray *)projuctsWithArray:(NSArray *)array;


@end
