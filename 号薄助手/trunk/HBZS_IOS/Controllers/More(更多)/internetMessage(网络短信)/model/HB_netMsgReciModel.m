//
//  HB_netMsgReciModel.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/12/8.
//

#import "HB_netMsgReciModel.h"

@implementation HB_netMsgReciModel
-(void)dealloc
{
    [_name release];
    [_number release];
    [super dealloc];
}
@end
