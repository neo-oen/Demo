//
//  CellModel.h
//  TableView
//
//  Created by neo on 2017/10/21.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, DicType) {
    singleDic = 0,
    doubleDic
};

@interface CellModel : NSObject


@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * icon;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)cellWithDict:(NSDictionary *)dict;


+ (NSArray *)cellsWithPath:(NSString *)path AndDicType:(DicType)type;//判断字典类型判断
+ (NSArray *)cellsWithArray:(NSArray *)array;


//frame所需的属性（这个可以做输出，也可以当限制）

@property(nonatomic,assign,readonly)CGFloat cellWidth;
@property(nonatomic,assign,readonly)CGFloat  cellHeight;

@property(nonatomic,assign,readonly)CGRect  nameLabelFrame;
@property(nonatomic,assign,readonly)CGRect userImageViewFrame;

-(void)setFrameWithRange:(CGPoint)widthHeight;
//连带初始化frame

- (instancetype)initWithDict:(NSDictionary *)dict AndRange:(CGPoint)widthHeight;
+ (instancetype)cellWithDict:(NSDictionary *)dict AndRange:(CGPoint)widthHeight;

+ (NSArray *)cellsWithPath:(NSString *)path AndDicType:(DicType)type AndRange:(CGPoint)widthHeight;
+ (NSArray *)cellsWithArray:(NSArray *)array AndRange:(CGPoint)widthHeight;

@end
