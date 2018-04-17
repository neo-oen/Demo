//
//  HB_ShareByQRcodeMoreView.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/4/20.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    More_View_Style_Right1 = 1,
    More_View_Style_Right2,
    More_View_Style_Left,
    More_View_Style_Middel
    
}MoreView_Style;
@class HB_ShareByQRcodeMoreView;
@protocol shareByQRcodeMoreViewDelegate <NSObject>

-(void)shareByQRcodeMoreView:(HB_ShareByQRcodeMoreView *)moreView WithselectIndex:(NSInteger)index;

@end


@interface HB_ShareByQRcodeMoreView : UIView
-(instancetype)initWithNames:(NSArray *)nameArr andStyle:(MoreView_Style)style;
@property(nonatomic,assign)id<shareByQRcodeMoreViewDelegate>delegate;

@end



