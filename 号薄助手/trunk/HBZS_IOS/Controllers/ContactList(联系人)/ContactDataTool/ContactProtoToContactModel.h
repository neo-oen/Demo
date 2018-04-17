//
//  ContactProtoToContactModel.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/3/1.
//
//

#import <Foundation/Foundation.h>
#import "ContactProto.pb.h"
#import "HB_ContactModel.h"
#import "HB_EmailModel.h"
#import "HB_PhoneNumModel.h"
#import "MemAddressBook.h"
@interface ContactProtoToContactModel : NSObject

+(ContactProtoToContactModel *)shareManager;

-(Contact*)ContactModelmemMycard:(HB_ContactModel *)model;
-(HB_ContactModel *)memMycardToContactModel:(Contact *)memContact;
@end

