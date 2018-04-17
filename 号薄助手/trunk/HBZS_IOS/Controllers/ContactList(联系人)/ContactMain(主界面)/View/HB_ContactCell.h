//
//  HB_ContactCell.h
//  HBZS_iOS
//
//  Created by zimbean on 15/7/8.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HB_ContactSimpleModel.h"

@interface HB_ContactCell : UITableViewCell

/**
 *  联系人头像
 */
@property(nonatomic,retain)UIImageView *iconIv;
/**
 *  联系人名字
 */
@property(nonatomic,retain)UILabel *nameLabel;

/**
 *  联系人数据模型
 */
@property(nonatomic,retain)HB_ContactSimpleModel *contactModel;
/**
 *  快速返回一个cell
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setupIconAndName;
@end
