//
//  HB_CenterLetterView.m
//  HBZS_iOS
//
//  Created by zimbean on 15/7/13.
//  Copyright (c) 2015年 shtianxin. All rights reserved.
//

#import "HB_CenterLetterView.h"

@interface HB_CenterLetterView ()
/**
 *  字母
 */
@property(nonatomic,retain)UILabel * letterLabel;

@end

@implementation HB_CenterLetterView
-(void)dealloc{
    [_letterLabel release];
    [_letter release];
    [super dealloc];
}
-(instancetype)init{
    self=[super init];
    if (self) {
        [self addLetterLabel];
    }
    return self;
}
/**
 *  添加字母
 */
-(void)addLetterLabel{
    //添加字母
    _letterLabel=[[UILabel alloc]init];
    _letterLabel.textColor=COLOR_I;
    _letterLabel.font=[UIFont boldSystemFontOfSize:14];
    _letterLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_letterLabel];
}
-(void)setLetter:(NSString *)letter{
    _letter = letter;
    self.letterLabel.text=letter;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor=COLOR_B;
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=self.frame.size.width/2;
    self.letterLabel.bounds=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.letterLabel.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

@end
