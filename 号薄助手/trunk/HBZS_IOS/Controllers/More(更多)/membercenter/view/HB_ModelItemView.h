//
//  HB_ModelItemView.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/27.
//
//

#import <UIKit/UIKit.h>
#import "HB_MemberModel.h"
#import "UIButton+WebCache.h"
#import "GetMemberInfoProto.pb.h"
@protocol MemberModelDelegate <NSObject>

-(void)itemClickWithIndex:(NSInteger)index;

@end
@interface HB_ModelItemView : UIView
- (instancetype)initwithModel:(HB_MemberModel*)model andItemIndex:(NSInteger)i andmemberLevel:(MemberLevel)MyMemberLevel;
@property(nonatomic,retain)HB_MemberModel * model;
@property(nonatomic,retain)id<MemberModelDelegate>delegate;
@property(nonatomic,assign)int MyMemberLevel;
@property(nonatomic,assign)NSInteger index;
@end
