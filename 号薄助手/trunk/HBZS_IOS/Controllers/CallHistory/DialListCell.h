//
//  DialListCell.h
//  HBZS_IOS
//
//  Created by Kevin Zhang、yingxin on 12-5-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactListCell.h"

@interface DialListCell : ContactListCell{
              
}

@property (nonatomic, retain) UILabel  *midLabel;               //中间label

@property (nonatomic, retain) UIButton *dialInfoBtn;           //按钮

@property (nonatomic, retain) UILabel *rightLabel;            //通话次数

@property (nonatomic, retain) UILabel *locationLabel;         //归属地

@property (nonatomic, retain) UILabel  *dateLabel;           //通话日期


- (void)setLabelMid:(NSString*) textContent;

- (void)setDialInfoBtnTag:(NSUInteger) btnTag;

- (void)setDialInfoBtnHidden:(BOOL) bHidden;

- (void)setDialInfoBtnImg:(NSString*)imageName;

- (void)setLabelRight:(NSString*)textContent;

- (void)setLabelDate:(NSString*)textContent;

- (void)setLabelLocation:(NSString*)textContent;

@end
