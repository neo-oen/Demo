//
//  HB_ContactDetailGroupManagerVC.h
//  HBZS_IOS
//
//  Created by zimbean on 15/9/17.
//
//


#import "BaseViewCtrl.h"
#import "HB_ContactDetailArrowCellModel.h"


@protocol ContactDetailGroupManageDelegate <NSObject>

-(void)GroupIdsforNewContact:(NSArray *)groupmodels;

@end
@interface HB_ContactDetailGroupManagerVC : BaseViewCtrl
/**
 *  联系人的id
 */
@property(nonatomic,assign)NSInteger recordID;
/**
 *  arrowCell的模型
 */
@property(nonatomic,retain)HB_ContactDetailArrowCellModel *arrowCellModel;

@property(nonatomic,strong)id<ContactDetailGroupManageDelegate>delegate;

@end
