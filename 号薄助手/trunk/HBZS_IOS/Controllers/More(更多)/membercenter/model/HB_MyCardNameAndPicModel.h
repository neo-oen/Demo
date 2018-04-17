//
//  HB_MyCardNameAndPicModel.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/28.
//
//

#import <Foundation/Foundation.h>
#import "HB_cardsDealtool.h"
@interface HB_MyCardNameAndPicModel : NSObject

@property(nonatomic,retain)NSString * name;
@property(nonatomic,retain)UIImage * headerImage;
@property(nonatomic,retain)HB_ContactModel * model;
@end
