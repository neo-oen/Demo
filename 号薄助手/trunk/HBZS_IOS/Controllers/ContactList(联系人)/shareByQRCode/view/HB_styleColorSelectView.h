//
//  HB_styleColorSelectView.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/4/22.
//
//

#import <UIKit/UIKit.h>
@class HB_styleColorSelectView;
@protocol styleColorSelectDelegate <NSObject>

-(void)styleColorSelectView:(HB_styleColorSelectView *)styleColorSelectView selectedColorHex:(NSString *)HexString;

@end

@interface HB_styleColorSelectView : UIView

@property(nonatomic,assign)id<styleColorSelectDelegate> delegate;

@property(nonatomic,strong)NSArray * colorsArr;

-(instancetype)init;

-(void)remove;




@end
