//
//  HB_GroupManageCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//
#define Padding 15 //间距
typedef enum {
    EditButton=10,//编辑按钮
    DelateButton,//删除按钮
    ShareButton
}ButtonType;

#import "HB_GroupManageCell.h"
#import "GroupData.h"

@implementation HB_GroupManageCell
-(void)dealloc{
    [_model release];
    [_groupNameLabel release];
    [_editBtn release];
    [_deleteBtn release];
    [_arrowImageView release];
    [_lineLabel release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * identifyStr=@"HB_GroupManageCell";
    HB_GroupManageCell * cell=[tableView dequeueReusableCellWithIdentifier:identifyStr];
    if (cell==nil) {
        cell=[[[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyStr]autorelease];
        [cell setupSubViews];
    }
    return cell;
}
-(void)setupSubViews{
    //1.cell名字
    _groupNameLabel=[[UILabel alloc]init];
    _groupNameLabel.font=[UIFont systemFontOfSize:15];
    _groupNameLabel.textColor=COLOR_D;
    _groupNameLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;
    [self addSubview:_groupNameLabel];
    //2.编辑按钮
    _editBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageNamed:@"编辑_可点击"] forState:UIControlStateNormal];
    _editBtn.tag=EditButton;
    [_editBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_editBtn];
    //3.删除按钮
    _deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"删除可点击"] forState:UIControlStateNormal];
    _deleteBtn.tag=DelateButton;
    [_deleteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_deleteBtn];
    //分享按钮
    _shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"分享_绿"] forState:UIControlStateNormal];
    _shareBtn.tag=ShareButton;
    [_shareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareBtn];
    
    //4.右侧箭头
    _arrowImageView=[[UIImageView alloc]init];
    _arrowImageView.contentMode=UIViewContentModeCenter;
    _arrowImageView.image=[UIImage imageNamed:@"普通箭头-List"];
    [self addSubview:_arrowImageView];
    //5.底部细线
    _lineLabel=[[UILabel alloc]init];
    _lineLabel.textColor=[UIColor clearColor];
    _lineLabel.backgroundColor=COLOR_F;
    [self addSubview:_lineLabel];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //5.底部细线
    CGFloat lineLabel_X=Padding;
    CGFloat lineLabel_H=0.5;
    CGFloat lineLabel_Y=self.bounds.size.height-lineLabel_H;
    CGFloat lineLabel_W=self.bounds.size.width - 2 * Padding;
    self.lineLabel.frame=CGRectMake(lineLabel_X, lineLabel_Y, lineLabel_W, lineLabel_H);
    //4.右侧箭头
    CGFloat arrowImageView_W=self.arrowImageView.image.size.width;
    CGFloat arrowImageView_H=self.bounds.size.height;
    CGFloat arrowImageView_X=self.bounds.size.width-Padding - arrowImageView_W;
    CGFloat arrowImageView_Y=0;
    self.arrowImageView.frame=CGRectMake(arrowImageView_X, arrowImageView_Y, arrowImageView_W, arrowImageView_H);
    //3.删除按钮
    CGFloat deleteBtn_W=self.deleteBtn.imageView.image.size.width;
    CGFloat deleteBtn_H=self.bounds.size.height;
    CGFloat deleteBtn_X=arrowImageView_X-Padding-deleteBtn_W;
    CGFloat deleteBtn_Y=0;
    self.deleteBtn.frame=CGRectMake(deleteBtn_X, deleteBtn_Y, deleteBtn_W, deleteBtn_H);
    //2.编辑按钮
    CGFloat editBtn_W=self.editBtn.imageView.image.size.width;
    CGFloat editBtn_H=self.bounds.size.height;
    CGFloat editBtn_X=deleteBtn_X-Padding-editBtn_W;
    CGFloat editBtn_Y=0;
    self.editBtn.frame=CGRectMake(editBtn_X, editBtn_Y, editBtn_W, editBtn_H);
    //share按钮
    CGFloat shareBtn_W =self.editBtn.imageView.image.size.width;
    CGFloat shareBtn_H =self.bounds.size.height;
    CGFloat shareBtn_X = editBtn_X-Padding-shareBtn_W;
    CGFloat shareBtn_Y =0;
    self.shareBtn.frame = CGRectMake(shareBtn_X, shareBtn_Y, shareBtn_W, shareBtn_H);
    
    //1.cell名字
    CGFloat groupNameLabel_W=editBtn_X-Padding-Padding;
    CGFloat groupNameLabel_H=self.bounds.size.height;
    CGFloat groupNameLabel_X=Padding;
    CGFloat groupNameLabel_Y=0;
    self.groupNameLabel.frame=CGRectMake(groupNameLabel_X, groupNameLabel_Y, groupNameLabel_W, groupNameLabel_H);
}
-(void)setModel:(HB_GroupModel *)model{
    if (_model != model) {
        [_model release];
        _model=[model retain];
    }
    //根据ID，获取所有成员recordID数组
    NSArray * recordIDArr = [GroupData getGroupAllContactIDByID:model.groupID];
    NSString * nameLabelStr=[NSString stringWithFormat:@"%@（%d）",model.groupName,recordIDArr.count];
    self.groupNameLabel.text=nameLabelStr;
}
#pragma mark - 点击事件
-(void)btnClick:(UIButton *)btn{
    if (btn.tag==EditButton) {
        //编辑按钮
        if ([self.delegate respondsToSelector:@selector(groupManageCell:editBtnClick:)]) {
            [self.delegate groupManageCell:self editBtnClick:btn];
        }
        
    }else if (btn.tag==DelateButton){
        //删除按钮
        if ([self.delegate respondsToSelector:@selector(groupManageCell:deleteBtnClick:)]) {
            [self.delegate groupManageCell:self deleteBtnClick:btn];
        }
    }
    else if (btn.tag == ShareButton)
    {
        if ([self.delegate respondsToSelector:@selector(groupManageCell:shareBtnClick:)]) {
            [self.delegate groupManageCell:self shareBtnClick:btn];
        }
    }
}
@end
