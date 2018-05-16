//
//  ShareContactTableView.h
//  testAPP
//
//  Created by neo on 2018/5/16.
//  Copyright © 2018年 王雅强. All rights reserved.
//

#import "BaseTableView.h"


@class ContactShareInfo;
typedef void (^FirstButtonClickAction)(ContactShareInfo * model);
typedef void (^SecondButtonClickAction)(ContactShareInfo * model);
typedef void (^SendOtherButtonClickAction)(ContactShareInfo * model);
typedef void (^AccessorViewClickAction)(ContactShareInfo * model);

@interface ShareContactTableView : BaseTableView

@property(nonatomic,strong)NSArray * models;

-(void)setCellActionWithFirstBCA:(FirstButtonClickAction)first withSecondBCA:(FirstButtonClickAction)second withSendOtherBCA:(FirstButtonClickAction)send withAccessorViewBCA:(AccessorViewClickAction)accessor;

@end
