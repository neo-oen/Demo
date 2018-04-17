//
//  SoundPlayer.h
//  HBZS_IOS
//
//  Created by 冯强迎 on 15/11/17.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface SoundPlayer : NSObject

/**

  *  @brief  为播放震动效果初始化

  *

  *  @return self

  */

-(instancetype)initForPlayingSystemSound:(SystemSoundID) soundID;

-(instancetype)initForPlayingLocalSoundByPath:(NSString *)soundIDPaht ofType:(NSString *)type;
@end
