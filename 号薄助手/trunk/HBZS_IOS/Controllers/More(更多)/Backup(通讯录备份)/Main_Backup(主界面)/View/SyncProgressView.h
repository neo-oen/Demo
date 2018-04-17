//
//  SyncProgressView.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/9/7.
//
//

#import <UIKit/UIKit.h>
#import "ProgressBar.h"
@interface SyncProgressView : UIView

@property(nonatomic,strong)UIProgressView * progressView;
@property(nonatomic,strong)UIImageView * alertv;
@property(nonatomic,strong)UILabel * titlelabel;
@property(nonatomic,strong)UILabel * precentlabel;


-(void)show;
-(void)showInView:(UIViewController *)vc;
-(void)dismiss;
- (id)init;

-(void)setProgressMin;
-(void)setProgressMax;
-(void)setSyncProgress:(float)progress animated:(BOOL)animate;
-(void)setProTitleWithString:(NSString *)str;

@end
