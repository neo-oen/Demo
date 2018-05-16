//
//  ShareContactCell.h
//  testAPP
//
//  Created by neo on 2018/5/15.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "xxmodel.h"

typedef void (^FirstButtonClickAction)(ContactShareInfo * model);
typedef void (^SecondButtonClickAction)(ContactShareInfo * model);
typedef void (^SendOtherButtonClickAction)(ContactShareInfo * model);
typedef void (^AccessorViewClickAction)(ContactShareInfo * model);
@interface ShareContactCell : BaseTableViewCell

@property(nonatomic,copy)FirstButtonClickAction firstButtonCA;
@property(nonatomic,copy)SecondButtonClickAction secondButtonCA;
@property(nonatomic,copy)SendOtherButtonClickAction sendOtherButtonCA;
@property(nonatomic,copy)AccessorViewClickAction accessorViewButtonCA;

@property(nonatomic,strong)UIButton * accessorView;
@property(nonatomic,strong)UILabel * urlLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIButton * duplicateButton;
@property(nonatomic,strong)UIButton * cancelSharingButton;
@property(nonatomic,strong)UIButton * sendOtherButton;
@property(nonatomic,strong)UIView * lineView;

@property(nonatomic,strong)ContactShareInfo * model;//向本类输入资源的接口

//资源是model的时候
+(instancetype)cellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;//初始化视图的方法
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateTableViewCellWithModel:(ContactShareInfo *)model;//加载资源


-(void)setActionWithFirstBCA:(FirstButtonClickAction)first withSecondBCA:(FirstButtonClickAction)second withSendOtherBCA:(FirstButtonClickAction)send withAccessorViewBCA:(AccessorViewClickAction)accessor;

@end
