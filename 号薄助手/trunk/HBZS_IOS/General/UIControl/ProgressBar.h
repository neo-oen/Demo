//
//  ProgressBar.h
//  HBZS_IOS
//
//  Created by yingxin on 12-6-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    PROC_DEFAULT=0,
    PROC_YELLOW,
    PROC_GREEN,
    PROC_BLUE
}ProcType;

#define LABEL_WIDTH 250

@interface ProgressBar : UIView{
    UIImageView* progressView;
    
    UILabel* progressLabel;
    
    CGFloat fprogress;
}

@property (nonatomic, retain) UIImageView* progressView;

@property (nonatomic, retain) UILabel* progressLabel;

@property (nonatomic, assign) CGFloat fprogress;


- (void)setProgressMin;

- (void)setProgressMax;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated animateTime:(CGFloat)ntime;

- (void)setProgressType:(ProcType)type;

@end
