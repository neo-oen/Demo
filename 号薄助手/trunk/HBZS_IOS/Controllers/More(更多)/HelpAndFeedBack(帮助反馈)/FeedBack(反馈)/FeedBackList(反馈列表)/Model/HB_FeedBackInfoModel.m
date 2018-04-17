//
//  HB_FeedBackInfoModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/5.
//
//

#import "HB_FeedBackInfoModel.h"

@implementation HB_FeedBackInfoModel

-(void)dealloc{
    [_feedBackContent release];
    [_time release];
    [_replayStatus release];
    [super dealloc];
}



@end
