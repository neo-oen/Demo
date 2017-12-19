//
//  TableViewCell.h
//  TableView
//
//  Created by 王雅强 on 2017/11/8.
//  Copyright © 2017年 neo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CellModel.h"
#import "Public.h"

typedef NS_ENUM(NSInteger, TableViewCellStyle) {
    TableViewCellStyleDefault,
    TableViewCellStyleText
};


//typedef <#void#> (^<#AnswerClick#>Action)(<#NSString * str#>);

@interface TableViewCell : UITableViewCell

//@property(nonatomic,copy)<#AnswerClick#>Action <#answer#>CA ;//向view类外，索要非本类的工作的接口
@property(nonatomic,strong)UIImageView * userImageView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)CellModel * model;//向本类输入资源的接口
//资源是model的时候
+(instancetype)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;//初始化视图的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateTableViewCellWithModel:(CellModel *)model;//加载资源

//-(BOOL)add<#AanswerButtonName#>:(NSString *) title;//视图的输入接口，通过她来调用视图的某些功能

@end

