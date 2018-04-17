//
//  HB_ ScanResultAnalyze.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/4/21.
//
//

#import <Foundation/Foundation.h>

@interface HB_ScanResultAnalyze : NSObject

@property(nonatomic,assign)UIViewController * CurrentViewController;

-(instancetype)initWithCurrentVc:(id)CurrentViewController;

-(void)AnalyzeResult:(NSString *)result;

@end
