//
//  HB_ContactCell.m
//  HBZS_iOS
//
//  Created by zimbean on 15/7/8.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//

#import "HB_ContactCell.h"

@interface HB_ContactCell ()

@end


@implementation HB_ContactCell

-(void)dealloc{
    [_contactModel release];
    [_iconIv release];
    [_nameLabel release];
    [super dealloc];
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *str=@"ContactCell";
    HB_ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[[self alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str] autorelease];
        [cell setupIconAndName];

    }
    return cell;
}
/**
 *  设置头像和名字
 */
-(void)setupIconAndName{
    //头像
    _iconIv=[[UIImageView alloc]init];
    _iconIv.backgroundColor=[UIColor clearColor];
    _iconIv.layer.masksToBounds=YES;
    _iconIv.layer.cornerRadius=20;
    [self.contentView addSubview:_iconIv];
    //名字
    _nameLabel=[[UILabel alloc]init];
    [self.contentView addSubview:_nameLabel];
}
-(void)layoutSubviews{
    [super layoutSubviews];

    //头像frame
    _iconIv.frame=CGRectMake(15, 10, 40, 40);
    //名字frame
    CGFloat nameLable_X=CGRectGetMaxX(_iconIv.frame)+15;
    CGFloat nameLable_Y=_iconIv.frame.origin.y;
    CGFloat nameLable_W=[UIScreen mainScreen].bounds.size.width-nameLable_X-20;
    CGFloat nameLable_H=_iconIv.frame.size.height;
    _nameLabel.frame=CGRectMake(nameLable_X, nameLable_Y ,nameLable_W,nameLable_H);
    
    //这里主要是为了实现对cell左侧复选按钮的图片自定义
    if (self.editing) {
        if ([[[UIDevice currentDevice]systemVersion] intValue]>=8) {
            //cell的所有子控件数组
            NSArray * cellSubViewsArr=self.subviews;
            //最后一个子控件，它的子控件数组(这个子控件一般表示的是编辑状态下左侧的复选框)
            NSArray * lastSubViewsArr=[[cellSubViewsArr lastObject] subviews];
            //遍历，取出imageView并更改
            for (int i=0; i<lastSubViewsArr.count; i++) {
                id obj = lastSubViewsArr[i];
                if ([obj isKindOfClass:[UIImageView class]]) {
                    UIImageView * iv = (UIImageView*)obj;
                    if (cellSubViewsArr.count==2) {//表示处于编辑状态，但没有选中
                        //iv.image=[UIImage imageNamed:@"选框"];
                    }else if (cellSubViewsArr.count==3) {//表示处于编辑状态，并且选中了
                        iv.image=[UIImage imageNamed:@"选框-选中"];
                    }
                }
            }
            //同理，把背景图片设置为透明，不需要显示
            if (cellSubViewsArr.count==3) {
                //取出背景图控件，第1个
                id obj = cellSubViewsArr[0];
                if ([obj isKindOfClass:[UIView class]]) {
                    UIView * bgView=(UIView *)obj;
                    bgView.hidden=YES;
                }
            }
        }else{//******************ios 7
            //cell的所有子控件数组
            NSArray * cellSubViewsArr=self.subviews;
            NSArray * scrollViewSubViewsArr=[cellSubViewsArr[0] subviews];
            //最后一个子控件，它的子控件数组(这个子控件一般表示的是编辑状态下左侧的复选框)
            UIControl * control = [scrollViewSubViewsArr lastObject];
            NSArray * controlSubViewsArr=control.subviews;
            //遍历，取出imageView并更改
            for (int i=0; i<controlSubViewsArr.count; i++) {
                id obj = controlSubViewsArr[i];
                if ([obj isKindOfClass:[UIImageView class]]) {
                    UIImageView * iv = (UIImageView*)obj;
                    if (scrollViewSubViewsArr.count==2) {//表示处于编辑状态，但没有选中
                        //iv.image=[UIImage imageNamed:@"选框"];
                    }else if (scrollViewSubViewsArr.count==3) {//表示处于编辑状态，并且选中了
                        UIImageView * bgIv = scrollViewSubViewsArr[0];
                        bgIv.hidden=YES;
                        iv.image=[UIImage imageNamed:@"选框-选中"];
                    }
                }
            }
        }
    }
}
#pragma mark - 模型的setter方法
-(void)setContactModel:(HB_ContactSimpleModel *)contactModel{
    if (_contactModel != contactModel) {
        [_contactModel release];
        _contactModel=[contactModel retain];
    }
    //设置名字
    self.nameLabel.text=contactModel.name;
    //设置头像
    if (contactModel.iconData_thumbnail) {
        self.iconIv.image=[UIImage imageWithData:contactModel.iconData_thumbnail];
    }else{
        self.iconIv.image=[UIImage imageNamed:@"默认联系人头像"];
    }
}

@end
