//
//  WYQBaseTableView.h
//  TableView
//
//  Created by 王雅强 on 2018/3/13.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableSectionModel.h"
#import "CellModel.h"
#import "TableViewCell.h"
#import "TableViewHeaderView.h"

@interface WYQBaseTableView : UITableView

@property(nonatomic,strong)NSArray * groups;

//cell的增，删，改，移
-(BOOL)addTableSectionCellWithModel:(CellModel *) model;//视图的输入接口，通过她来调用视图的某些功能
-(BOOL)addTableSectionCellWithModel:(CellModel *) model andIndexPath:(NSIndexPath *)indexPath;

-(BOOL)deleteTableSectionCell;//视图的输入接口，通过她来调用视图的某些功能
-(BOOL)deleteTableSectionCellWithIndexPath:(NSIndexPath *)indexPath;

-(BOOL)changeTableSectionCellWithModel:(CellModel *) model andIndexPath:(NSIndexPath *)indexPath;

-(BOOL)moveTableSectionCellWithIndexPath:(NSIndexPath *)indexPathA toIndexPath:(NSIndexPath *)indexPathB;

//section的增，删，改，移
//视图的输入接口，通过她来调用视图的某些功能
-(BOOL)addTableSectionSectionWithModel:(TableSectionModel *) model andIndexSet:(NSIndexSet *)indexSet;

-(BOOL)deleteTableSectionWithIndexSet:(NSIndexSet *)indexSet;

-(BOOL)changeTableSectionWithModel:(TableSectionModel *) model andIndexSet:(NSIndexSet *)indexSet;

-(BOOL)moveTableSectionWithSection:(NSInteger)sectionA toSection:(NSInteger)sectionB;
-(BOOL)reloadDataWithModel:(NSArray *)models;


@end
