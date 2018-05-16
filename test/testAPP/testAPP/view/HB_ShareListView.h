//
//  HB_ShareListView.h
//  testAPP
//
//  Created by neo on 2018/5/16.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoShareListTV.h"

@class ContactShareInfo;
typedef void (^FirstButtonClickAction)(ContactShareInfo * model);
typedef void (^SecondButtonClickAction)(ContactShareInfo * model);
typedef void (^SendOtherButtonClickAction)(ContactShareInfo * model);
typedef void (^AccessorViewClickAction)(ContactShareInfo * model);

@interface HB_ShareListView : UIView

-(void)setShareListViewWith:(NSArray *)list andViewType:(ShareListViewType)listType;

-(void)setShareListViewWith:(NSArray *)list andViewType:(ShareListViewType)listType withFirstBCA:(FirstButtonClickAction)first withSecondBCA:(FirstButtonClickAction)second withSendOtherBCA:(FirstButtonClickAction)send withAccessorViewBCA:(AccessorViewClickAction)accessor;

@end
