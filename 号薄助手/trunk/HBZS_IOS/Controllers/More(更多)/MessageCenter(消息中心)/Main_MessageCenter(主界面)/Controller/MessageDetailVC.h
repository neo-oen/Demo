//
//  MessageDetailVC.h
//  HBZS_IOS
//
//  Created by zimbean on 14-6-24.
//
//

#import "BaseViewCtrl.h"
#import "GetSysMsgProto.pb.h"
#import "NewMessage.h"

@interface MessageDetailVC : BaseViewCtrl{
    UIScrollView *detailScrollView;
    
    UILabel *contentLabel;
    
    UIImageView *titleImgView;
    UIImageView *firstImgView;
    UIImageView *secondImgView;
    UIImageView *thirdImgView;
}

@property (nonatomic, retain)NewMessage *sysMsg;

- (id)initWithMessage:(NewMessage *)msg;

@end
