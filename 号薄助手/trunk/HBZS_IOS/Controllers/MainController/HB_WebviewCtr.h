//
//  HB_WebviewCtr.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/3/1.
//
//

#import "BaseViewCtrl.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
@interface HB_WebviewCtr : BaseViewCtrl<NJKWebViewProgressDelegate,UIWebViewDelegate>

/**
 *  标题
 */
@property(nonatomic,copy)NSString *titleName;
/**
 *  目标url
 */
@property(nonatomic,retain)NSURL *url;

@property(nonatomic,retain)UIWebView * webView;

@property(nonatomic,retain)NJKWebViewProgress * progressProxy;

@property(nonatomic,retain)NJKWebViewProgressView *progressView;

@end
