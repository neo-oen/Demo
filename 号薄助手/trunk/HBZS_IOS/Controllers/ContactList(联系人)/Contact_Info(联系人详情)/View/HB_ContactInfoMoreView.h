//
//  HB_ContactInfoMoreView.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/29.
//
//

#import <UIKit/UIKit.h>
@class HB_ContactInfoMoreView;

@protocol HB_ContactInfoMoreViewDelegate <NSObject>
/**1  分享联系人 */
-(void)contactInfoMoreView:(HB_ContactInfoMoreView * )moreView didShareContactWithIndexPath:(NSIndexPath *)indexPath;
/**2  置顶联系人 */
-(void)contactInfoMoreView:(HB_ContactInfoMoreView * )moreView sendTopContactWithIndexPath:(NSIndexPath *)indexPath;
/**3  IP通话 */
-(void)contactInfoMoreView:(HB_ContactInfoMoreView * )moreView IPCallWithIndexPath:(NSIndexPath *)indexPath;
/**4  删除联系人 */
-(void)contactInfoMoreView:(HB_ContactInfoMoreView * )moreView deleteContactWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface HB_ContactInfoMoreView : UIView
/**
 *  联系人ID (用于后面判断该联系人是否置顶)
 */
@property(nonatomic,assign)NSInteger recordID;

@property(nonatomic,assign)id<HB_ContactInfoMoreViewDelegate> delegate;

//用于回调来相应
-(void)moreViewBackClick:(NSIndexPath *)indexPath;


@end
