//
//  TableViewCell.m
//  TableView
//
//  Created by 王雅强 on 2017/11/8.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "TableViewCell.h"




@interface TableViewCell()
@property(nonatomic,strong)UIView * lineView;


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
        [_nameLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}
-(UIView *)lineView
{
    if(!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
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
    

    [self setUpFrame];
    [self setUpData];
    
}

-(void)setUpData{
    self.nameLabel.text = _model.name;
    [self.userImageView setImage:[UIImage imageNamed:_model.icon]];
    
}

-(void)setUpFrame{
    self.nameLabel.frame = self.model.nameLabelFrame;
    self.userImageView.frame = _model.userImageViewFrame;
    self.lineView.frame = _model.LineViewFrame;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark - ============== 代理 ==============

@end


