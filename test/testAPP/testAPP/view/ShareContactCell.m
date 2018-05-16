//
//  ShareContactCell.m
//  testAPP
//
//  Created by neo on 2018/5/15.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import "ShareContactCell.h"




@interface ShareContactCell()


@end

@implementation ShareContactCell


#pragma mark - ============== 懒加载 ==============
-(UIButton *)accessorView
{
    if(!_accessorView) {
        _accessorView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accessorView setImage:[UIImage imageNamed:@"普通箭头-List"] forState:UIControlStateNormal];
        [_accessorView.imageView setContentMode:UIViewContentModeCenter];
        [_accessorView.imageView setClipsToBounds:NO];
        [_accessorView addTarget:self action:@selector(accessorButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_accessorView];
    }
    return _accessorView;
}

-(UILabel *)urlLabel
{
    if(!_urlLabel) {
        _urlLabel = [[UILabel  alloc] init];
        [_urlLabel setFont:[UIFont systemFontOfSize:19]];
        [_urlLabel setText:@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"];
        [self.contentView addSubview:_urlLabel];
    }
    return _urlLabel;
}
-(UILabel *)timeLabel
{
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel = [[UILabel  alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [_timeLabel setText:@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UIButton *)duplicateButton
{
    if(!_duplicateButton) {
        _duplicateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_duplicateButton addTarget:self action:@selector(firstButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonProperty:_duplicateButton];
    }
    return _duplicateButton;
}
-(UIButton *)cancelSharingButton
{
    if(!_cancelSharingButton) {
        _cancelSharingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelSharingButton addTarget:self action:@selector(secondButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonProperty:_cancelSharingButton];
    }
    return _cancelSharingButton;
}


-(UIButton *)sendOtherButton
{
    if(!_sendOtherButton) {
        _sendOtherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendOtherButton setTitle:@"转发" forState:UIControlStateNormal];
         [_sendOtherButton addTarget:self action:@selector(sendOtherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonProperty:_sendOtherButton];
    }
    return _sendOtherButton;
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
        [self setClipsToBounds:YES];
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中状态
    
    }
    
    return self;
}

+(instancetype)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    ShareContactCell * cell = [[ShareContactCell alloc]initWithStyle:style reuseIdentifier:reuseIdentifier];
    return cell;
}
#pragma mark - ============== 更新视图 ==============
/**
 根据资源，更新View
 
 @param model 资源
 */
- (void)updateTableViewCellWithModel:(ContactShareInfo *)model {

    _model = model;


//    [self setUpFrame];
    [self setUpData];

}

-(void)setUpData{
    self.urlLabel.text = _model.shareurl;
    self.timeLabel.text = _model.extractcode;
    [self setButtonTitleWith:_model.shareType];
}



-(void)setUpFrame{
    CGFloat xMargin = 25;
    CGFloat yMargin = 20;
    CGFloat margin = 5;
    CGFloat hButton = 30;
    CGFloat wButton = 80;
    
    self.urlLabel.frame = CGRectMake(xMargin, yMargin, 390, 22);
    self.timeLabel.frame = CGRectMake(xMargin, CGRectGetMaxY(self.urlLabel.frame)+ margin , 300, 15);
    self.accessorView.frame = CGRectMake(self.contentView.frame.size.width - 55, yMargin + 10, 20, 22);
    CGFloat yButton = (CGRectGetMaxY(self.timeLabel.frame) + yMargin + 2);
    self.duplicateButton.frame = CGRectMake(xMargin, yButton, wButton, hButton);
    self.cancelSharingButton.frame = CGRectMake(CGRectGetMaxX(self.duplicateButton.frame) + xMargin, yButton, wButton, hButton);
    self.sendOtherButton.frame = CGRectMake(self.contentView.frame.size.width - wButton - xMargin, yButton, wButton, hButton);
    
//    CGFloat hLine  = self.model.isSelected?128:80;
    self.lineView.frame = CGRectMake(25, 0, self.frame.size.width - 50, 1);
    
    [self setRotageImageView];
}

#pragma mark - ============== 接口 ==============


-(void)setActionWithFirstBCA:(FirstButtonClickAction)first withSecondBCA:(FirstButtonClickAction)second withSendOtherBCA:(FirstButtonClickAction)send withAccessorViewBCA:(AccessorViewClickAction)accessor{
    self.firstButtonCA = first;
    self.secondButtonCA = second;
    self.sendOtherButtonCA = send;
    self.accessorViewButtonCA = accessor;
}



#pragma mark - ============== 方法 ==============

-(void)setButtonProperty:(UIButton *)button{
    [button.layer  setBorderColor:[UIColor colorWithRed:0.48 green:0.8 blue:0 alpha:1].CGColor];
    [button.layer setBorderWidth:1];
    [button.layer setCornerRadius:5.0];
    [button setClipsToBounds:YES];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitleColor:[UIColor colorWithRed:0.48 green:0.8 blue:0 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"greenColor"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:button];
}


-(void)setButtonTitleWith:(ShareType)shareType{
    if (shareType ==myShare) {
        [_duplicateButton setTitle:@"复制" forState:UIControlStateNormal];
        [_cancelSharingButton setTitle:@"取消分享" forState:UIControlStateNormal];
    }else{
        [_duplicateButton setTitle:@"再次导入" forState:UIControlStateNormal];
        [_cancelSharingButton setTitle:@"删除" forState:UIControlStateNormal];
    }
    
    
}

/**
 修改accessorView的指向
 */
- (void)setRotageImageView{
    UIImageView * imageView = _accessorView.imageView;
#warning 动画效果失效
    [UIView animateWithDuration:1.0 animations:^{
        if (self.model.selected){
            imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }else{
            imageView.transform = CGAffineTransformIdentity;
        }
    }];
    

    
}

-(void)firstButtonClick:(UIButton *)button{
    if (self.firstButtonCA) {
        self.firstButtonCA(self.model);
    }
    
}
-(void)secondButtonClick:(UIButton *)button{
    if (self.secondButtonCA) {
        self.secondButtonCA(self.model);
    }
    
}
-(void)sendOtherButtonClick:(UIButton *)button{
    if (self.sendOtherButtonCA) {
        self.sendOtherButtonCA(self.model);
    }
    
}
-(void)accessorButtonClick:(UIButton *)button{
    
    if (self.accessorViewButtonCA) {
        self.accessorViewButtonCA(self.model);
    }
    
}


#pragma mark - ============== 代理 ==============


#pragma mark - ============== 设置 ==============
-(void)layoutSubviews{
     [self setUpFrame];
 
  
}

@end

