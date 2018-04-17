//
//  HB_MemberModel.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/27.
//
//


#import <Foundation/Foundation.h>



@interface HB_MemberModel : NSObject

@property(nonatomic,assign)NSInteger memberlevel;
@property(nonatomic,retain)NSString *moduleimgoff;
@property(nonatomic,retain)NSString *moduleimgon;
@property(nonatomic,retain)NSString *modulelink;
@property(nonatomic,retain)NSString *moduletext;
@property(nonatomic,assign)NSInteger sort;
@end
