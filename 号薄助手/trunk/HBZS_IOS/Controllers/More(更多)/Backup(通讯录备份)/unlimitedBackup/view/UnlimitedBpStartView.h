//
//  UnlimitedBpStartView.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/7/27.
//
//

#import <UIKit/UIKit.h>
@class UnlimitedBpStartView;
@protocol UnlimitedBpStartViewDelegate <NSObject>

-(void)OpenNow;

@end


@interface UnlimitedBpStartView : UIView

@property(nonatomic,strong)id<UnlimitedBpStartViewDelegate>delegate;


@property (retain, nonatomic) IBOutlet UIImageView *headerImageview;
@property (retain, nonatomic) IBOutlet UIButton *bottomBtn;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextView *ContentTextView;

@end

