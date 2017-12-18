//
//  TableViewHeaderView.h
//  TableView
//
//  Created by 王雅强 on 2017/12/16.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableSectionModel.h"

@interface TableViewHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong)UIButton * contextButton;
@property(nonatomic,strong)TableSectionModel * model;

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
+(instancetype)viewWithReuseIdentifier:(NSString *)reuseIdentifier;

-(void)updateTableViewHeaderViewWithModel:(TableSectionModel *) model;

@end
