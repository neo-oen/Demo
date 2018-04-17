//
//  HB_FeedBackDetailModel.m
//  HBZS_IOS
//
//  Created by zimbean on 15/11/10.
//
//

#import "HB_FeedBackDetailModel.h"

@implementation HB_FeedBackDetailModel
-(void)dealloc{
    [_question release];
    [_questionTime release];
    [_answer release];
    [_answerTime release];
    [super dealloc];
}


@end
