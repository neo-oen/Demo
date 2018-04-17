//
//  HB_OrderMemberModel.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/13.
//
//  扣费成功或获得免费体验后上传结果到服务器oerderMemberReq 信息

#import <Foundation/Foundation.h>
#import "GetMemberInfoProto.pb.h"
@interface HB_OrderMemberModel : NSObject

@property(nonatomic,retain)NSString * order_no;
@property(nonatomic,retain)NSString * price;
@property(nonatomic)MemberType memberType;
@property(nonatomic)MemberLevel memberLevel;
@end
