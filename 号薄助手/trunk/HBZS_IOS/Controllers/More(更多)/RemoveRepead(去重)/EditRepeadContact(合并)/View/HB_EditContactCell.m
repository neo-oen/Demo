//
//  HB_EditContactCell.m
//  HBZS_IOS
//
//  Created by zimbean on 15/8/21.
//
//

#import "HB_EditContactCell.h"

@implementation HB_EditContactCell


-(void)layoutSubviews{
    [super layoutSubviews];
    
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
    
//    self.selected=YES;
}

@end
