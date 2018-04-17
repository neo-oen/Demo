//
//  SyncLogListVC.h
//  HBZS_IOS
//
//  Created by zimbean on 14-8-12.
//
//

#import "BaseViewCtrl.h"

@interface SyncLogListVC : BaseViewCtrl<UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *syncLogs;
    
  
}

@property (nonatomic, retain)IBOutlet UITableView *syncLogListTable;

@end
