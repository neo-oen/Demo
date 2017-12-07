//
//  CellModel.h
//  TableView
//
//  Created by neo on 2017/10/21.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Public.h"

typedef enum : NSUInteger {
    ME = 0,
    Other = 1,
} Type;


@interface CellModel : NSObject

@property(nonatomic,copy)NSString * text;
@property(nonatomic,copy)NSString * time;
@property(nonatomic,assign)Type type;
@property(nonatomic,strong)NSString * icon;

@property(nonatomic,assign,getter =istimeHiddened)BOOL timeHidden;

@property(nonatomic,assign,readonly)CGFloat cellWidth;
@property(nonatomic,assign,readonly)CGFloat cellHeight;

@property(nonatomic,assign,readonly)CGRect  timelFrame;
@property(nonatomic,assign,readonly)CGRect textContentFrame;
@property(nonatomic,assign,readonly)CGRect iconFrame;

//只初始化数据
- (instancetype)initWithDict:(NSDictionary *)dict andHiddenTime:(BOOL)hiddenTime;
+ (instancetype)cellWithDict:(NSDictionary *)dict andHiddenTime:(BOOL)hiddenTime;

+ (NSArray *)cellsWithPath:(NSString *)path;
+ (NSArray *)cellsWithArray:(NSArray *)array;


-(void)setFrameWithWidthAndHeight:(CGPoint)widthHeight;
//连带着初始化frame
- (instancetype)initWithDict:(NSDictionary *)dict andHiddenTime:(BOOL)hiddenTime WithWidthAndHeight:(CGPoint)widthHeight;
+ (instancetype)cellWithDict:(NSDictionary *)dict andHiddenTime:(BOOL)hiddenTime WithWidthAndHeight:(CGPoint)widthHeight;

+ (NSArray *)cellsWithPath:(NSString *)path WithWidthAndHeight:(CGPoint)widthHeight;
+ (NSArray *)cellsWithArray:(NSArray *)array WithWidthAndHeight:(CGPoint)widthHeight;


@end
