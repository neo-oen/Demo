//
//  HB_MyCardNameAndPicModel.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/9/28.
//
//

#import "HB_MyCardNameAndPicModel.h"
#import "MemAddressBook.h"

@implementation HB_MyCardNameAndPicModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[HB_cardsDealtool getCardsdata] firstObject];
        self.name = [self getCloudShareName];
        self.headerImage = [self getHearderImage];
        
    }
    return self;
}

-(UIImage *)getHearderImage
{
    
    
//    PortraitData * mycardHeard =[[MemAddressBook getInstance] myPortrait];
//    NSData * data = mycardHeard.imageData;
   
    NSData * data = self.model.iconData_original;
    UIImage * image;
    image =[UIImage imageWithData:data];
    
    if (!image) {
        image= [UIImage resizedImageWithName:@"会员中心默认头像"];
    }
    
    return image;
}
-(NSString *)getCloudShareName
{
    
    
    NSString * lastname = self.model.lastName?self.model.lastName:@"";
    NSString * firstname = self.model.firstName?self.model.firstName:@"";
    NSString * name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    if (!name.length) {
        name = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobileNum"];
    }
    
    return name;
    
}

@end
