//
//  BackUpSuccessVc.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/9/14.
//
//

#import "BaseViewCtrl.h"
#import "SyncEngine.h"
@interface BackUpSuccessVc : BaseViewCtrl
{
    SyncState_t backstate;
    
    SyncTaskType tasktype;

}

@property(nonatomic,strong) UIButton * linkbutton;

@property(nonatomic,strong) UIImageView * logoImage;

@property(nonatomic,strong) UILabel * statelabel;

@property(nonatomic,strong) UILabel * detalLabel;

@property(nonatomic)NSInteger upCount;

@property(nonatomic)NSInteger downCount;

-(id)init;
-(void)setType:(SyncTaskType)type andState:(SyncState_t)state;
-(void)setsendCount:(NSInteger)upcount andreceiveCount:(NSInteger)downcount;
@end
