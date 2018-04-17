//
//  HB_SearchKeyBoardView.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/21.
//
//
#import <UIKit/UIKit.h>
@class HB_SearchKeyBoardView;

@protocol SearchKeyBoardViewDelegate <NSObject>
/**
 *  传递用户输入的搜索关键字
 */
-(void)searchKeyBoardView:(HB_SearchKeyBoardView *)searchKeyBoardView withSearchText:(NSString *)searchText;

@end

@interface HB_SearchKeyBoardView : UIView

/** 顶部输入框 */
@property(nonatomic,retain)UITextField * textField;
/**
 *  HB_SearchKeyBoardView的代理
 */
@property(nonatomic,assign)id<SearchKeyBoardViewDelegate> delegate;

/**
 *  需要显示的字母数组 (大写,字符串类型)
 */
@property(nonatomic,retain)NSArray *characterArr;


@end
