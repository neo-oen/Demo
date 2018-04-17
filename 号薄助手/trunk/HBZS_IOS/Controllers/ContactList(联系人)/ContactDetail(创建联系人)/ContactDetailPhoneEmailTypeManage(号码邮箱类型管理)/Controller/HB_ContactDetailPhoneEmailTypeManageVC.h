//
//  HB_ContactDetailPhoneEmailTypeManageVC.h
//  HBZS_IOS
//
//  Created by zimbean on 15/10/14.
//
//

#import "BaseViewCtrl.h"
#include "HB_ContactDetailPhoneCellModel.h"

@interface HB_ContactDetailPhoneEmailTypeManageVC : BaseViewCtrl
/**
 *  cell模型
 */
@property(nonatomic,retain)HB_ContactDetailPhoneCellModel *phoneCellModel;
/**
 *  从上一个页面传入的类型数据，（还可以选择的剩余类型）
 */
@property(nonatomic,retain)NSMutableArray *typeArr;


@end
