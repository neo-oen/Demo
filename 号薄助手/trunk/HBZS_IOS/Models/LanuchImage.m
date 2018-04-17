//
//  LanuchImage.m
//  HBZS_IOS
//
//  Created by zimbean on 14-6-18.
//
//

#import "LanuchImage.h"

@implementation LanuchImage

@synthesize job_server_id;
@synthesize timestamp;
@synthesize start_date;
@synthesize end_date;
@synthesize background_color;
@synthesize display_time;
@synthesize imgs;
@synthesize frequency;

- (void)dealloc{
    if (start_date) {
        [start_date release];
    }
    
    if (end_date) {
        [end_date release];
    }
    
    if (background_color) {
        [background_color release];
    }
    [super dealloc];
}

@end
