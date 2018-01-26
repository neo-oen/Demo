//
//  TableView.h
//  Navgation使用
//
//  Created by neo on 2018/1/19.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

typedef void (^CellClickAction)(NSIndexPath * indexPath,CellModel * model);
@interface TableView : UIView

@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property(nonatomic,strong)NSArray * models;
-(BOOL)addManWithModel:(CellModel *) model;
-(BOOL)addManWithModel:(CellModel *) model andIndexPath:(NSIndexPath *) indexPath;
-(BOOL)editManWithModel:(CellModel *) model andIndexPath:(NSIndexPath *) indexPath;

@property(nonatomic,copy)CellClickAction  cellClickAction;


@end
