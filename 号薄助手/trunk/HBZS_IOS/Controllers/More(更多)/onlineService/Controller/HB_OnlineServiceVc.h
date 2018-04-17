//
//  HB_OnlineServiceVc.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/2/23.
//
//

#import "BaseViewCtrl.h"

@interface HB_OnlineServiceVc : BaseViewCtrl<UIWebViewDelegate>

/**
 *  标题
 */
@property(nonatomic,copy)NSString *titleName;
/**
 *  目标url
 */
@property(nonatomic,retain)NSURL *url;

@property(nonatomic,strong)UIWebView * webview;
@end
