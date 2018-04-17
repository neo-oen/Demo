//
//  CellButton.h
//  HBZS_IOS
//
//  Created by yingxin fu on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellButton : UIButton{
    NSInteger sectionTag;
    
    NSInteger rowTag;
}

@property (nonatomic, assign) NSInteger sectionTag;

@property (nonatomic, assign) NSInteger rowTag;

@end
