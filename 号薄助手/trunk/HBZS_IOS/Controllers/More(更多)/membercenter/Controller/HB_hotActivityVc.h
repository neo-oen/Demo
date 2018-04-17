//
//  HB_hotActivityVc.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/20.
//
//

#import "BaseViewCtrl.h"
#import "GetSysMsgProto.pb.h"
@interface HB_hotActivityVc : BaseViewCtrl

@property(nonatomic,retain)UITableView * tableView;

@property(nonatomic,retain)NSArray * dataArr;

@end
