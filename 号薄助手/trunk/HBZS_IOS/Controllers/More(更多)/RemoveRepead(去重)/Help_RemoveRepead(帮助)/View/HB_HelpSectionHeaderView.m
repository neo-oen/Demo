//
//  HB_HelpSectionHeaderView.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/18.
//
//

#import "HB_HelpSectionHeaderView.h"
#import "HB_HelpCellButton.h"

@interface HB_HelpSectionHeaderView ()
/**
 *  按钮
 */
@property(nonatomic,retain)UIButton * bgButton;
/**
 *  底部细线
 */
@property(nonatomic,retain)UILabel  *lineLabel;


@end

@implementation HB_HelpSectionHeaderView
-(void)dealloc{
    [_bgButton release];
    [_lineLabel release];
    [super dealloc];
}
+(instancetype)headerViewWithTableView:(UITableView *)tableView{
    static NSString * identify=@"headerView";
    HB_HelpSectionHeaderView * headerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:identify];
    if (headerView==nil) {
        headerView=[[[HB_HelpSectionHeaderView alloc]initWithReuseIdentifier:identify] autorelease];
        [headerView setupSubViews];
    }
    return headerView;
}
-(void)setupSubViews{
    //添加按钮
    HB_HelpCellButton * btn=[HB_HelpCellButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font=[UIFont systemFontOfSize:15];
    [btn setTitleColor:COLOR_D forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"筛选箭头"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"筛选箭头-选中"] forState:UIControlStateSelected];
    btn.backgroundColor=COLOR_I;
    [btn addTarget:self action:@selector(sectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    self.bgButton=btn;
    //添加细线
    UILabel * label=[[UILabel alloc]init];
    label.backgroundColor=COLOR_H;
    [self.contentView addSubview:label];
    self.lineLabel=label;
    [label release];
}
-(void)sectionBtnClick:(UIButton *)btn{
    //1.改模型
    self.model.open=!self.model.isOpen;
    btn.selected = !btn.selected;
    //2.刷新数据
    if ([self.delegate respondsToSelector:@selector(helpSectionDidClickWihtHeaderView:)]) {
        [self.delegate helpSectionDidClickWihtHeaderView:self];
    }
}
-(void)setModel:(HB_HelpGroupModel *)model{
    _model=model;
    //按钮
    [self.bgButton setTitle:model.question forState:UIControlStateNormal];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //按钮
    self.bgButton.frame=self.contentView.bounds;
    //细线
    CGFloat line_X=15;
    CGFloat line_W=self.contentView.bounds.size.width-line_X*2;
    CGFloat line_H=0.5;
    CGFloat line_Y=self.contentView.bounds.size.height-line_H;
    self.lineLabel.frame=CGRectMake(line_X, line_Y, line_W, line_H);
}
-(void)didAddSubview:(UIView *)subview{
    self.bgButton.selected=self.model.isOpen;
}

@end
