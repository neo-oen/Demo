//
//  HB_editMyCardVc.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/11/14.
//
//

#import "HB_ContactDetailController.h"
#import "HB_cardsDealtool.h"

typedef enum : NSUInteger {
    Edit_edit,
    Edit_AddNew,
} EditType;

@protocol editMyCarddelagate <NSObject>

-(void)editFinishWithType:(EditType)type;

@end

@interface HB_editMyCardVc : HB_ContactDetailController

@property(nonatomic,assign)id<editMyCarddelagate>delegate;

@property(nonatomic,assign)EditType editType;


@end
