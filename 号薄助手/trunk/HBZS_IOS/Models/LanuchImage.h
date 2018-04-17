//
//  LanuchImage.h
//  HBZS_IOS
//
//  Created by zimbean on 14-6-18.
//
//

#import <Foundation/Foundation.h>

@interface LanuchImage : NSObject{
    
}

@property (nonatomic, assign)int job_server_id;//Int类型, 0表示没有符合条件的ID
@property (nonatomic, assign)int timestamp;
@property (nonatomic, retain)NSString *start_date; //有效时间
@property (nonatomic, retain)NSString *end_date; //无效时间
@property (nonatomic, retain)NSString *background_color;
@property (nonatomic ) int display_time;
@property (nonatomic, retain)NSArray *imgs;
@property (nonatomic)int frequency;
@end
