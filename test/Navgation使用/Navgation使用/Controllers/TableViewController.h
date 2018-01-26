//
//  TableViewController.h
//  Navgation使用
//
//  Created by neo on 2018/1/17.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"

@interface TableViewController : UIViewController

@property(nonatomic,copy)NSString * name;

-(BOOL)addManWithModel:(CellModel *) model;
-(BOOL)addManWithModel:(CellModel *) model andIndexPath:(NSIndexPath *) indexPath;
-(BOOL)editManWithModel:(CellModel *) model andIndexPath:(NSIndexPath *) indexPath;
@end
