//
//  TimeMachineCtrl.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/11/26.
//
//

#import "BaseViewCtrl.h"
@interface TimeMachineCtrl : BaseViewCtrl

@property (retain, nonatomic) IBOutlet UITableView *TimeMachinetable;


/**
 *数据源第一个本地联系人数量‘XX个联系人’，之后存时光机HB_MachineDataModel
 */
@property (nonatomic,strong) NSMutableArray * dataArray;
@end
