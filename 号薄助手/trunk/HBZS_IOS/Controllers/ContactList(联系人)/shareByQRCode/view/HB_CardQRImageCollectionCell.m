//
//  HB_CardQRImageCollectionCell.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 2017/7/6.
//
//

#import "HB_CardQRImageCollectionCell.h"
#import "HB_BusinessCardParser.h"
#import "SettingInfo.h"
@implementation HB_CardQRImageCollectionCell

-(void)dealloc
{
    
    [_QRImageView release];
    [_CardBgview release];
    [_nameLabel release];
    [_PhoneLabel release];
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInterface];
    }
    return self;
}

-(void)setupInterface
{
    CGFloat CardBgview_w =Device_Width-80;
    _CardBgview = [[UIView alloc] initWithFrame:CGRectMake(40, 0, CardBgview_w, 300)];
    [self.contentView addSubview:_CardBgview];
    
    UILongPressGestureRecognizer * LongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    LongPress.minimumPressDuration = 0.8;
    LongPress.numberOfTouchesRequired = 1;
    [_CardBgview addGestureRecognizer:LongPress];
    [LongPress release];
    
    CGFloat QRImageView_X = CardBgview_w/2-100;
    CGFloat QRImageView_Y = 30;
    CGFloat QRImageView_W = 200.f;
    CGFloat QRImageView_H = 200.f;
    self.QRImageView = [[UIImageView alloc] initWithFrame:CGRectMake(QRImageView_X, QRImageView_Y, QRImageView_W, QRImageView_H)];
    [_CardBgview addSubview:self.QRImageView];
    
    
    
    CGFloat NameLabel_W =200;
    CGFloat NameLabel_H =30;
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NameLabel_W, NameLabel_H)];
    self.nameLabel.center = CGPointMake(CardBgview_w/2, QRImageView_Y+QRImageView_H+20);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 0;
    [_CardBgview addSubview:self.nameLabel];
    
    
    CGFloat PhoneLabel_H = self.nameLabel.frame.origin.y+NameLabel_H +3;
    self.PhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PhoneLabel_H, CardBgview_w,25)];
    self.PhoneLabel.textAlignment = NSTextAlignmentCenter;
    [_CardBgview addSubview:self.PhoneLabel];
}

-(void)longPressClick:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if ([self.delegate respondsToSelector:@selector(celllongPressClick)]) {
            [self.delegate celllongPressClick];
            
        }
        NSLog(@"===began");
    }
    else
    {
        NSLog(@"===end");
    }
    
}

-(void)setContactmodel:(HB_ContactModel *)contactmodel
{
    _contactmodel= contactmodel;
    
}
-(void)setQRimageType:(NSInteger)QRimageType
{
    _QRimageType = QRimageType;
    if (QRimageType == 0) {//[self canToQRcode]
        
        self.showPhoneNum = [NSMutableString stringWithCapacity:0];
        
        self.cardImage =[HB_BusinessCardParser getQRcodeImageWithContact:self.contactmodel ShowPhoneNum:self.showPhoneNum];
        
        self.QRImageView.image =self.cardImage;//[self imageWithSelectHexImage:self.currentImage];
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@%@",self.contactmodel.lastName?self.contactmodel.lastName:@"",self.contactmodel.firstName?self.contactmodel.firstName:@""];
        self.PhoneLabel.text = self.showPhoneNum?self.showPhoneNum:@"";
        
        
    }
    else if (QRimageType == 1) {
        
        if (self.UrlString.length) {
            HB_BusinessCardParser  * parser = [[HB_BusinessCardParser alloc] init];
            
            self.UrlImage = [parser getQRImageBy:self.UrlString];
            
            self.PhoneLabel.text = self.UrlString;
            

        }
        else
        {
            self.PhoneLabel.text = @"尚未生成名片活码";
            self.UrlImage = [UIImage imageNamed:@"二维码-名片活码-尚未生成icon"];
            
        }
        
        self.QRImageView.image = self.UrlImage;

        self.nameLabel.text = [NSString stringWithFormat:@"%@%@",self.contactmodel.lastName?self.contactmodel.lastName:@"",self.contactmodel.firstName?self.contactmodel.firstName:@""];
        
    }
}

@end
