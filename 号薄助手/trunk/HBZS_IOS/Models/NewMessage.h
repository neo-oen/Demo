//
//  NewMessage.h
//  HBZS_IOS
//
//  Created by zimbean on 14-6-25.
//
//

#import <Foundation/Foundation.h>

@interface NewMessage : NSObject{
    
}



@property (nonatomic)int jobServerId;
@property (nonatomic)int64_t timestamp;
@property (nonatomic)BOOL isRead;
@property (nonatomic, retain)NSString *iconUrl;
@property (nonatomic, retain)NSString *title;
@property (nonatomic, retain)NSString *content;
@property (nonatomic, strong)NSString * imgTitleUrl;
@property (nonatomic, retain) NSString* imgContentUrl1;
@property (nonatomic, retain) NSString* imgContentUrl2;
@property (nonatomic, retain) NSString* imgContentUrl3;

@property (nonatomic, retain)NSString * urlDetail;
@property (nonatomic, retain)NSString * StartDate;
@end
