//
//  TableViewHeaderView.m
//  TableView
//
//  Created by 王雅强 on 2017/12/16.
//  Copyright © 2017年 neo. All rights reserved.
//

#import "TableViewHeaderView.h"


@interface TableViewHeaderView ()

@end

@implementation TableViewHeaderView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - ============== 懒加载 ==============
-(UIButton *)contextButton
{
    if(!_contextButton) {
        _contextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contextButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [_contextButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_contextButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_contextButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_contextButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_contextButton setBackgroundColor:[UIColor yellowColor]];
        [_contextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_contextButton];
    }
    return _contextButton;
}
#pragma mark - ============== 初始化 ==============


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
    
}

+(instancetype)viewWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    TableViewHeaderView * headerView = [[TableViewHeaderView alloc]initWithReuseIdentifier:reuseIdentifier];
    
    return headerView;
    
}



#pragma mark - ============== 接口 ==============
-(void)updateTableViewHeaderViewWithModel:(TableSectionModel *)model{
    self.model = model;
    [self setUpData];
}


#pragma mark - ============== 方法 ==============
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setUpFrame];
    
}

-(void)setUpData{
    
    [self.contextButton setTitle:self.model.title forState:UIControlStateNormal];
    
}

-(void)setUpFrame{
    [self.contextButton setFrame:self.contentView.frame];
    
}

-(void)buttonClick:(UIButton *) button{
    if(self.buttonCA){
        self.buttonCA();
    }
    
}
#pragma mark - ============== 代理 ==============





@end
