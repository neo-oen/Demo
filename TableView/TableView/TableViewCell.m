//
//  TableViewCell.m
//  TableView
//
//  Created by 王雅强 on 2017/11/8.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "TableViewCell.h"


#import "CellModel.h"
#import "Public.h"

typedef NS_ENUM(NSInteger, TableViewCellStyle) {
    TableViewCellStyleDefault,
    TableViewCellStyleText
};


//typedef <#void#> (^<#AnswerClick#>Action)(<#NSString * str#>);

@interface TableViewCell : UITableViewCell

//@property(nonatomic,copy)<#AnswerClick#>Action <#answer#>CA ;//向view类外，索要非本类的工作的接口
@property(nonatomic,strong)CellModel * model;//向本类输入资源的接口
//资源是model的时候
+(instancetype)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;//初始化视图的方法
- (void)updateTableViewCellWithModel:(CellModel *)model;//加载资源

//-(BOOL)add<#AanswerButtonName#>:(NSString *) title;//视图的输入接口，通过她来调用视图的某些功能

@end

@interface TableViewCell()

@property(nonatomic,strong)UIImageView * userImageView;
@property(nonatomic,strong)UILabel * nameLabel;

@end

@implementation TableViewCell

#pragma mark - ============== 懒加载 ==============
-(UIImageView *)userImageView
{
    if(!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_userImageView];
    }
    return _userImageView;
}
-(UILabel *)nameLabel
{
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}


#pragma mark - ============== 初始化 ==============

/**
 初始化view
 */
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}

+(instancetype)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    TableViewCell * cell = [[TableViewCell alloc]initWithStyle:style reuseIdentifier:reuseIdentifier];
    return cell;
}
#pragma mark - ============== 更新视图 ==============
/**
 根据资源，更新View
 
 @param model 资源
 */
- (void)updateTableViewCellWithModel:(CellModel *)model {
    
    _model = model;
    
    
}


#pragma mark - ============== 接口 ==============


/**
 接口
 
 @param title 输入的数据
 @return 返回成功与否
 */
//-(BOOL)add<#AanswerButtonName#>:(NSString *) title{
//    
//    <#data#>
//}


#pragma mark - ============== 方法 ==============
#pragma mark - ============== 代理 ==============

@end


@implementation TableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}

+(instancetype)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    TableViewCell * cell = [[TableViewCell alloc]initWithStyle:style reuseIdentifier:reuseIdentifier];
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end




// 2. 判断是否取到， 如果取不到就实例化新的cell
if (nil == cell) {
    // 实例化tableViewcell
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
}
TableSectionModel * model = self.models[indexPath.section];
CellModel * CellModel = model.cells[indexPath.row];


// 设置imageView
cell.imageView.image = [UIImage imageNamed:CellModel.icon];

// 设置文本
cell.textLabel.text = CellModel.name;
