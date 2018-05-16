//
//  NoShareListTV.h
//  testAPP
//
//  Created by neo on 2018/5/16.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    myShareListViewType,
    toMyShareListViewTypew
} ShareListViewType;

@interface NoShareListTV : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)setNameLabelText:(ShareListViewType)listType;


@end
