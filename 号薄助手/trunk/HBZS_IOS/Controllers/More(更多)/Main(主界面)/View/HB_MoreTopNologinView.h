//
//  HB_MoreTopNologinView.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/6.
//
//

#import <UIKit/UIKit.h>
@class HB_MoreTopNologinView;
@protocol topNologinViewDelegate <NSObject>

/*index ==0 登录   
        ==1 注测
 */
-(void)topNologinView:(HB_MoreTopNologinView *)topView btnClickWithIndex:(NSInteger)index;


@end



@interface HB_MoreTopNologinView : UIView
@property (retain, nonatomic) IBOutlet UIButton *registBtn;
@property(nonatomic,retain)id<topNologinViewDelegate>delegate;
@end
