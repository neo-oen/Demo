//
//  EditManViewController.h
//  Navgation使用
//
//  Created by neo on 2018/1/22.
//  Copyright © 2018年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellModel.h"


@interface EditManViewController : UIViewController

@property(nonatomic,strong)CellModel * model;
@property(nonatomic,strong) NSIndexPath * indexPath;

@end
