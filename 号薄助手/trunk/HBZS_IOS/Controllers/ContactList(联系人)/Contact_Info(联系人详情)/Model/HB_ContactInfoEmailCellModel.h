//
//  HB_ContactInfoEmailCellModel.h
//  HBZS_IOS
//
//  Created by zimbean on 15/7/27.
//
//

#import <Foundation/Foundation.h>
#import "HB_EmailModel.h"//邮箱类型

@interface HB_ContactInfoEmailCellModel : NSObject
/**  邮箱模型 */
@property(nonatomic,retain)HB_EmailModel *emailModel;
/** 图标 */
@property(nonatomic,retain)UIImage *icon;

/**
 *  快速创建一个邮箱cell的model
 */
+(instancetype)modelWithEmailModel:(HB_EmailModel*)emailModel andIcon:(UIImage *)icon;


@end
