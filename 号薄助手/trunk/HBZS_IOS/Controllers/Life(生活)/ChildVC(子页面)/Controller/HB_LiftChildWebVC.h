//
//  HB_LiftChildWebVC.h
//  HBZS_IOS
//
//  Created by zimbean on 15/8/14.
//
//

#import "BaseViewCtrl.h"
#import "NJKWebViewProgress.h"

@interface HB_LiftChildWebVC : BaseViewCtrl<NJKWebViewProgressDelegate,UIWebViewDelegate>

/**
 *  标题
 */
@property(nonatomic,copy)NSString *titleName;
/**
 *  目标url
 */
@property(nonatomic,retain)NSURL *url;

@property(nonatomic,retain)UIWebView * webView;

@end
