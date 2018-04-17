//
//  HB_CardsViewCtrl.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/5/12.
//
//

#import "BaseViewCtrl.h"
#import "HB_CardCollectionCell.h"
#import "HB_ContactInfoMoreView.h"//导航栏右侧“更多”按钮，浮层
#import "HB_ShareByQRcodeMoreView.h"
#import "HB_editMyCardVc.h"
@interface HB_CardsViewCtrl : BaseViewCtrl<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CardCollectionCelldelegate,editMyCarddelagate>

/** 主列表（横向CollectionView） */
@property(nonatomic,retain)UICollectionView * mainCollectionView;

/** 向左按钮 */
@property(nonatomic,retain)UIButton * goLeftbtn;
/** 向右按钮 */
@property(nonatomic,retain)UIButton * goRigthbtn;
/** 无数据提示 */
@property(nonatomic,retain)UILabel * remindLabel;
/** 数据源(元素HB_ContactModel) */
@property(nonatomic,retain)NSMutableArray * CardsdataArr;

/** 当前名片页 */
@property(nonatomic,assign)NSInteger currentPage;

/** 下拉框*/
@property(nonatomic,strong)HB_ShareByQRcodeMoreView * moreView;
@end
