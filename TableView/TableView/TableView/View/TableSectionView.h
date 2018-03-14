//
//  TableSectionView.h
//  TableView
//
//  Created by neo on 2017/10/20.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableSectionModel.h"
#import "CellModel.h"
#import "WYQBaseTableView.h"



typedef NS_ENUM(NSInteger, UITableSectionViewStyle) {
    UITableSectionViewStyleDefault,
    UITableSectionViewStyleText
};


//typedef <#void#> (^<#AnswerClick#>Action)(<#NSString * str#>);

@interface TableSectionView : UIView

@property(nonatomic,strong)WYQBaseTableView * tableView;
//@property(nonatomic,copy)<#AnswerClick#>Action <#answer#>CA ;//向view类外，索要非本类的工作的接口
@property(nonatomic,strong)NSArray * models;//向本类输入资源的接口

+ (TableSectionView *)TableSectionWithFrame:(CGRect)frame withStyle:(UITableViewStyle)style andModel:(NSArray *)models;//初始化视图的方法
+(TableSectionView *)TableSectionWithStyle:(UITableViewStyle)style andModel:(NSArray *)models;
- (void)updateTableSectionViewWithModel:(NSArray *)models;//加载资源

////cell的增，删，改，移
//-(BOOL)addTableSectionCellWithModel:(CellModel *) model;//视图的输入接口，通过她来调用视图的某些功能
//-(BOOL)addTableSectionCellWithModel:(CellModel *) model andIndexPath:(NSIndexPath *)indexPath;
//
//-(BOOL)deleteTableSectionCell;//视图的输入接口，通过她来调用视图的某些功能
//-(BOOL)deleteTableSectionCellWithIndexPath:(NSIndexPath *)indexPath;
//
//-(BOOL)changeTableSectionCellWithModel:(CellModel *) model andIndexPath:(NSIndexPath *)indexPath;
//
//-(BOOL)moveTableSectionCellWithIndexPath:(NSIndexPath *)indexPathA toIndexPath:(NSIndexPath *)indexPathB;
//
////section的增，删，改，移
////视图的输入接口，通过她来调用视图的某些功能
//-(BOOL)addTableSectionSectionWithModel:(TableSectionModel *) model andIndexSet:(NSIndexSet *)indexSet;
//
//-(BOOL)deleteTableSectionWithIndexSet:(NSIndexSet *)indexSet;
//
//-(BOOL)changeTableSectionWithModel:(TableSectionModel *) model andIndexSet:(NSIndexSet *)indexSet;
//
//-(BOOL)moveTableSectionWithSection:(NSInteger)sectionA toSection:(NSInteger)sectionB;
//-(BOOL)reloadData;
//-(BOOL)reloadDataWithModel:(NSArray *)models;

@end
