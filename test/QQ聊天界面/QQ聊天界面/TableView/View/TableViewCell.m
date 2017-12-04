//
//  TableViewCell.m
//  TableView
//
//  Created by 王雅强 on 2017/11/8.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "TableViewCell.h"




@interface TableViewCell()

@property(nonatomic,strong)UIImageView * userImageView;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIButton * contentButton;

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
-(UILabel *)timeLabel
{
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:15]];
        [_timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}
-(UIButton *)contentButton
{
    if(!_contentButton) {
        _contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_contentButton.titleLabel setNumberOfLines:0];
        [_contentButton setContentEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
        [_contentButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:_contentButton];
        //
    }
    return _contentButton;
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
    self.timeLabel.text = _model.time;
    
   NSString * icon = _model.type==ME?@"other":@"me";
    [self.userImageView setImage:[UIImage imageNamed:icon]];
    
    [self.contentButton setTitle:_model.text forState:UIControlStateNormal];
    NSString * imageStr = _model.type==ME?@"chat_recive_press_pic":@"chat_send_nor";
    UIImage * BackGroundimage = [self resizeImageWith:imageStr];
    [self.contentButton setBackgroundImage:BackGroundimage forState:UIControlStateNormal];
    
    
    
}

-(void)setUpFrame{
    self.timeLabel.frame = self.model.timelFrame;
    self.userImageView.frame = _model.iconFrame;
    self.contentButton.frame = _model.textContentFrame;
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
                            
//处理按钮背景图片
- (UIImage *)resizeImageWith:(NSString *)imageName{
    // 对图片进行处理
    UIImage *image = [UIImage imageNamed:imageName];
    
    // 计算image 宽高的一半
    CGFloat halfWidth = image.size.width/2;
    CGFloat halfHeight = image.size.height/2;
    
    // CapInsets : 距离图片四周的距离
    /**
     UIImageResizingModeTile,  平铺
     UIImageResizingModeStretch, 拉伸
     */
    UIImage *resizeImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(halfHeight, halfWidth, halfHeight, halfWidth) resizingMode:UIImageResizingModeStretch];
    
    // 把拉伸过之后的image 反回
    return resizeImage;
    
    
    
    
}
                                 
#pragma mark - ============== 代理 ==============

@end


