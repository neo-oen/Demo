//
//  DialDetailViewCtrl.h
//  HBZS_IOS
//
//  Created by yingxin on 12-6-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "BaseViewCtrl.h"
#import "ContactItems.h"
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>
@class DialDetailViewCtrl;
@class DialItem;
@protocol DialDetailViewDelegate <NSObject>

-(void)DialDetailView:(DialDetailViewCtrl *)vc deleteDialItem:(DialItem *)dialItem;
@end

typedef enum  _DialDetailBtnTag//用于标记键盘功能按键
{
    
    DialDetailBtnContact=100,  //跳转到联系人详情
    DialDetailBtnDial,         //拨号
    DialDetailBtnMessge,       //发短信
    DialDetailBtnAddnew,       //新建联系人
    DialDetailBtnAddLocal,     //添加到本低联系人
    DialDetailBtnDelete        //删除记录
}_DialDetailBtnTag;
@interface DialDetailViewCtrl : BaseViewCtrl<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    
  UITableView* detailTableView;
    
  DialItem* localDialItem;
    
    NSDateFormatter *formatter;
}

@property (nonatomic,retain)DialItem* localDialItem;

@property (nonatomic,strong)id<DialDetailViewDelegate>DialDetaiDelegate;

- (NSString*)dateToString:(NSDate*)date;

- (id)initWithDialItem:(DialItem*)dialItem;


@end
