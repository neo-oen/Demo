//
//  NoShareListTV.m
//  testAPP
//
//  Created by neo on 2018/5/16.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import "NoShareListTV.h"

@implementation NoShareListTV

-(void)setNameLabelText:(ShareListViewType)listType
{
    if (listType == myShareListViewType) {
        self.nameLabel.text = @"尚未创建任何分享";
    } else {
        self.nameLabel.text = @"没有收到分享";
    }
}

@end
