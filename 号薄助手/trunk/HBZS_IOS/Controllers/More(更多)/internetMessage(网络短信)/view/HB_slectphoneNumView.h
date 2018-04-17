//
//  HB_slectphoneNumView.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/12/21.
//

#import <UIKit/UIKit.h>


@class HB_slectphoneNumView;

@protocol selectphoneNumViewdelegate <NSObject>

-(void)selectphoneNumView:(HB_slectphoneNumView *)selectview selectedPhone:(NSArray *)selectphones;

@end

@interface HB_slectphoneNumView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)UITableView * tableview;
@property(nonatomic,retain)NSArray * dataarr;
@end
