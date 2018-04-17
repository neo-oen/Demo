//
//  HB_RemoveRepeadTool.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/18.
//
//

#import <Foundation/Foundation.h>
@class HB_RemoveRepeadTool;

@protocol HB_RemoveRepeadToolDelegate <NSObject>
/**
 *  去重完成后的回调，包含合并了几个重复联系人，剩余几个相似联系人
 *
 *  @param tool         去重类
 *  @param repeadCount  去除的重复联系人个数
 *  @param similarCount 剩余的相似联系人个数
 */
-(void)removeRepeadTool:(HB_RemoveRepeadTool *)tool didFinishFilterContactArrWithRepeadCount:(NSInteger)repeadCount
                                                                            andSimilarCount:(NSInteger)similarCount;
-(void)removeRepeadTool:(HB_RemoveRepeadTool *)tool compeletPercent:(CGFloat)percent;
@end

@interface HB_RemoveRepeadTool : NSObject
/**
 *  代理
 */
@property(nonatomic,assign)id<HB_RemoveRepeadToolDelegate> delegate;
/**
 *  在相似联系人数组中，去除一模一样的联系人，并返回一个相似联系人的数组构成的数组
 */
-(NSArray *)filterContactArr;

@end
