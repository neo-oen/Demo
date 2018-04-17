//
//  SettingUnlimitedBackupView.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/7/29.
//
//

#import <UIKit/UIKit.h>
#import "HB_SettingSwitchCell.h"
#import "HB_SettingSwitchCellModel.h"
#import "HB_SettingOptionCell.h"
#import "HB_SettingOptionCellModel.h"
#import "SettingInfo.h"


@class SettingUnlimitedBackupView;
@protocol SettingUnlimitedBackupViewDelegate <NSObject>

-(void)BtnClickWithStep:(NSInteger)step;
-(void)toMemPrivilegeWeb;

@end

@interface SettingUnlimitedBackupView : UIView<UITableViewDelegate,UITableViewDataSource,HB_SettingSwitchCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate,HB_SettingOptionCellDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) IBOutlet UILabel *setp1;
@property (retain, nonatomic) IBOutlet UILabel *step2;
@property (retain, nonatomic) IBOutlet UILabel *step3;
@property (retain, nonatomic) IBOutlet UIButton *NextStepBtn;
@property (retain, nonatomic) IBOutlet UIButton *memberCenterBtn;

@property (retain, nonatomic) IBOutlet UIView *topStepView;

@property (retain,nonatomic)UITextView * step2_view;

@property (retain, nonatomic) IBOutlet UIView *baseView;


@property(nonatomic,strong)id<SettingUnlimitedBackupViewDelegate>delegate;

/**  tableView数据源 */
@property(nonatomic,retain)NSMutableArray *dataArr;
/**  pickerView数据源 */
@property(nonatomic,retain)NSMutableArray *pickDataArr;
/**  当前选择的type */
@property(nonatomic,assign)NSInteger SelectType;



/**  保存Step Label对象*/
@property(nonatomic,retain)NSArray * StepArr;

@property(assign,nonatomic)NSInteger currentStep;

@property(nonatomic,retain)NSString * OpenTime;

/**  autoLaout*/
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *contentSize;

@end
