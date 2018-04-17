//
//  HB_MessageCenterVC.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/13.
//
//

#import "BaseViewCtrl.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "NewMessage.h"
@interface HB_MessageCenterVC : BaseViewCtrl<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * tableview;
    
    NSMutableArray * dataArray;
    
    UIImageView * NomessImageView;

}

@end
