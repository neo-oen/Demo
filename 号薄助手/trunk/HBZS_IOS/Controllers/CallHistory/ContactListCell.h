//
//  ContactListCell.h
//  CTPIM
//
//  Created by Kevin Zhang、 scanmac on 11-12-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HBZSAppDelegate.h"
//#import "RangeLightLabel.h"
#import "CellButton.h"
//#import "RangeLightLabel.h"
#import "AttributedLabel.h"

@class ContactListController;

@interface ContactListCell : UITableViewCell{
    CGPoint touchBeganPoint;
    
    AttributedLabel *topLabel;              //顶上label  联系人姓名
    
    AttributedLabel *bottomLabel;          //底下label  //联系人号码
    
    UIImageView *headImageView;           //头像
    
    CellButton *groupSelectBtn;          //按钮
}

@property (nonatomic, retain) AttributedLabel  *topLabel;

@property (nonatomic, retain) AttributedLabel *bottomLabel;

@property (nonatomic, retain) UIImageView  *headImageView;

@property (nonatomic, retain) CellButton *groupSelectBtn;

/*
 * init Cell
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

/*
 * 设置头像
 */
- (void)setHeadImage:(NSInteger)contaceID;

/*
 *  姓名UILabel
 */
- (void)setLabelTop:(NSString*)textContent lableFrame:(CGRect)lableFrame highLightRange:(NSMutableArray*)rangeArray;

/*
 * 号码 UILabel
 */
- (void)setLabelBottom:(NSString*)textContent lableFrame:(CGRect)lableFrame highLightRange:(NSMutableArray*)rangeArray;

/*
 * 裁剪图片
 */
- (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

/*
 * 设置群组选择按钮 Tag
 */
- (void)setGroupSelBtnTag:(NSUInteger) btnTag;

/*
 * 设置群组选择按钮 状态
 */
- (void)setGroupSelBtnSelected:(BOOL)bSelected;

/*
 * 设置群组选择按钮 隐藏
 */
- (void)setGroupSelBtnHidden:(BOOL)bHidden;

@end
