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
-(UIImageView *)ImageView
{
    if(!_ImageView) {
        _ImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_ImageView];
    }
    return _ImageView;
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
-(UILabel *)explanLabel
{
    if(!_explanLabel) {
        _explanLabel = [[UILabel alloc] init];
        [_explanLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:_explanLabel];
    }
    return _explanLabel;
}
-(UIButton *)downloadButton
{
    if(!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//       NSAttributedString * attributeString = [[NSAttributedString alloc]initWithString:@"下载" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSStrokeColorAttributeName:[UIColor redColor]}];
//        [_downloadButton setAttributedTitle:attributeString forState:UIControlStateNormal];
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadButton setTitle:@"下载中" forState:UIControlStateHighlighted];
        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"buttongreen"] forState:UIControlStateNormal];
        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"buttongreen_highlighted"] forState:UIControlStateHighlighted];
        [_downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_downloadButton];
    }
    return _downloadButton;
}
-(UIView *)lineView
{
    if(!_lineView) {
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UIColor whiteColor]];
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
    [self.nameLabel setText: _model.name];
    [self.ImageView setImage:[UIImage imageNamed:_model.icon]];
    [self.explanLabel setText:[NSString stringWithFormat:@"大小:%@ | 下载量:%@",_model.size,_model.download]];
    
}

-(void)setUpFrame{
    self.nameLabel.frame = self.model.nameLabelFrame;
    self.ImageView.frame = _model.imageViewFrame;
    self.explanLabel.frame = _model.explanLabelFrame;
    [self.downloadButton setFrame:  _model.downloadButtonFrame];
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


