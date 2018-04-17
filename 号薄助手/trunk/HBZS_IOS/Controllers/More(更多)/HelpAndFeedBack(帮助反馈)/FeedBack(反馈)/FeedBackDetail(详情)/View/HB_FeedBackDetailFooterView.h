//
//  HB_FeedBackDetailFooterView.h
//  HBZS_IOS
//
//  Created by zimbean on 15/11/10.
//
//

#import <UIKit/UIKit.h>

@interface HB_FeedBackDetailFooterView : UIView
/** 输入框 */
@property(nonatomic,retain)UITextView *textView;
/** 满意度评价 代号 */
@property(nonatomic,assign)NSUInteger evaluateNumber;

/**
 *  判断textView是否为空值
 */
-(BOOL)textViewIsNull;

@end
