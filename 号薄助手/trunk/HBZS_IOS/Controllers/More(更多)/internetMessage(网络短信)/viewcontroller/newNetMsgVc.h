//
//  newNetMsgVc.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/11/13.
//

#import "BaseViewCtrl.h"
#import "VENTokenField.h"


typedef enum{
    newNetMsg_AddMemb,
    newNetMsg_send,
    newNetMsg_selectContact
}newNetMsgbtntag;

@interface newNetMsgVc : BaseViewCtrl
@property (retain, nonatomic) IBOutlet VENTokenField *tokenfield;

@property (retain, nonatomic) IBOutlet UITextView *contentTextView;
@property (retain, nonatomic) IBOutlet UILabel *putinLabel;
@property (retain, nonatomic) IBOutlet UILabel *msgCountLabel;
//按钮
@property (retain, nonatomic) IBOutlet UIButton *sendBtn;
@property (retain, nonatomic) IBOutlet UIButton *contactBtn;
@property (retain, nonatomic) IBOutlet UIButton *addMemberBtn;


@property (retain, nonatomic) IBOutlet NSLayoutConstraint *tokenHeithConstraint;

@property (retain, nonatomic) UITableView * searchTableview;

@end
