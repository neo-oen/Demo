//
//  CellModel.m
//  TableView
//
//  Created by neo on 2017/10/21.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "CellModel.h"


@implementation CellModel

#define margin 10


#pragma mark - ============== 初始化 ==============
- (instancetype)initWithDict:(NSDictionary *)dict andHiddenTime:(BOOL)hiddenTime
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        self.timeHidden =hiddenTime;
        //frame和Height都在这里赋值
        [self getFrameAndHeight];
    }
    return self;
}

+ (instancetype)cellWithDict:(NSDictionary *)dict andHiddenTime:(BOOL)hiddenTime
{
    return [[self alloc] initWithDict:dict andHiddenTime:hiddenTime];
}

+ (NSArray *)cellsWithPath:(NSString *)path
{
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dict = array[i];
        CellModel * previousCellModel = arrayM.lastObject;
        BOOL timeHidden = [ dict[@"time"] isEqualToString:previousCellModel.time];
        CellModel * cellModel = [self cellWithDict:dict andHiddenTime:timeHidden];
        [arrayM addObject:cellModel];
    }

    return arrayM;
}

+(NSArray *)cellsWithArray:(NSArray *)array
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        NSDictionary *dict = array[i];
        CellModel * previousCellModel = arrayM.lastObject;
        
      BOOL timeHidden = [ dict[@"time"] isEqualToString:previousCellModel.time];
        CellModel * cellModel = [self cellWithDict:dict andHiddenTime:timeHidden];

        [arrayM addObject:cellModel];
    }
    
    return arrayM;
}

#pragma mark - ============== 方法 ==============
-(void)getFrameAndHeight{

    _timelFrame = CGRectMake(0, 0, screen_width, 20);
    if (_timeHidden==YES) {
        _timelFrame = CGRectMake(0, 0, 0, 0);
    }
    
    CGSize textContentMaxSize = CGSizeMake(screen_width - 2*margin -50 -40, MAXFLOAT);
    
    CGSize textContentSize =[_text boundingRectWithSize:textContentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;    
    
    if (_type==ME) {
        _iconFrame = CGRectMake(margin, CGRectGetMaxY(_timelFrame) + margin, 50, 50);
        _textContentFrame = CGRectMake(CGRectGetMaxX(_iconFrame) + margin, CGRectGetMinY(_iconFrame), textContentSize.width + 40, textContentSize.height+ 40);
        
    } else {
        _iconFrame = CGRectMake(screen_width-margin-50, CGRectGetMaxY(_timelFrame) + margin, 50, 50);
        _textContentFrame = CGRectMake(screen_width-2*margin-50-textContentSize.width-40, CGRectGetMinY(_iconFrame),textContentSize.width+ 40, textContentSize.height+ 40);
    
    }
    
    _cellHeight = CGRectGetMaxY(_textContentFrame) > CGRectGetMaxY(_iconFrame)? CGRectGetMaxY(_textContentFrame) + margin : CGRectGetMaxY(_iconFrame) + margin;
//    _cellHeight = 100;

//    _userImageViewFrame = CGRectMake(10, 10, 50, 50);
//    CGSize nameLabelMaxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
//    
//    CGSize nameLabelSize =[_name boundingRectWithSize:nameLabelMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
//    
//    _nameLabelFrame.origin = CGPointMake(10+50+10, 50*0.5+10-nameLabelSize.height*0.5);
//    _nameLabelFrame.size = nameLabelSize;
//    
//    _cellHeight = 50+10;
}




@end


