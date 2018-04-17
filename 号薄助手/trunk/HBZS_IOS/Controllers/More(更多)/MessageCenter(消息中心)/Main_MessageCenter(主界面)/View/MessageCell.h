//
//  MessageCell.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/9/10.
//
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *contectLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *headImageView;
@property (retain, nonatomic) IBOutlet UIImageView *isRead;

-(void)setMessageType:(BOOL)isRead;
@end
