//
//  HB_BackupMoreView.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/13.
//
//

#import <UIKit/UIKit.h>
@class HB_BackupMoreView;
@protocol HB_BackupMoreViewDelegate <NSObject>
-(void)backupMoreView:(HB_BackupMoreView *)backupMoreView WithIndexPath:(NSIndexPath *)indexPath;

@end
@interface HB_BackupMoreView : UIView
/**
 *  代理
 */
@property(nonatomic,assign)id<HB_BackupMoreViewDelegate> delegate;
@end
