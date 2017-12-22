//
//  TableViewHeaderView.h
//  TableView
//
//  Created by 王雅强 on 2017/12/16.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableSectionModel.h"

typedef void (^ButtonClickAction)();

@interface TableViewHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong)UIButton * contextButton;
@property(nonatomic,strong)UILabel * onlineLabel;
@property(nonatomic,strong)TableSectionModel * model;
@property(nonatomic,copy)ButtonClickAction buttonCA ;//向view类外，索要非本类的工作的接口


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
+(instancetype)viewWithReuseIdentifier:(NSString *)reuseIdentifier;

-(void)updateTableViewHeaderViewWithModel:(TableSectionModel *) model;

@end
