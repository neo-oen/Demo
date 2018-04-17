//
//  GobalSettings.h
//  CTPIM
//
//  Created by linsf on 11-9-20.
//  Copyright 2011年 asdfghjk. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConfigMgr.h"

#import "PathManager.h"

#define SYSTEMVERSION [UIDevice currentDevice].systemVersion


#define IOS_7_SYSTEM ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
//#define ZBLog      NSLog


// 根据服务端要求，暂时客户端版本号用3400100+ShortVersion
#define VersionClient [NSString stringWithFormat:@"3400100%@",[[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""]]
// 定义云端独有的字段。
// e家电话，VPN，性别，星座，血型，农历生日，QQ，MSN
// @ phone catalog.
#define kSABEPhoneLabel         @"ePhone"

#define kSABVPNLabel            @"VPN"

#define kSABFaxLabel            @"Fax"
// @ mail catalog.
#define kSABQQLabel             @"QQ"

#define kSABWeiXin              @"微信"

#define kSABYiXin               @"易信"

#define kSABMSNLabel            @"MSN"

#define kSABLunarBirthdayLabel  @"lunarBirthday"

#define kSABGenderLabel         @"gender"

#define kSABConstellationLabel  @"constellation"

#define kSABBloodTypeLabel      @"bloodType"

#define DELEGATE (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
//获取设置高度
#define Device_Height CGRectGetHeight([UIScreen mainScreen].bounds)
#define Device_Width ([UIScreen mainScreen].bounds.size.width)
#define RATE Device_Width/320
#define RateCGRectMake(x,y,w,h) CGRectMake((x)*RATE, (y)*RATE, (w)*RATE, (h)*RATE)
//applicationFrame

#define kNavigationBarHeight  44
#define kStatuBarHeight       20
#define kTabBarHeight         49



#define kGroupStyleTableHeaderHeight   35

#define COLOR(RED,GREEN,BLUE,ALPHA) [UIColor colorWithRed:(RED)/255.0 green:(GREEN)/255.0 blue:(BLUE)/255.0 alpha:(ALPHA)]

#define OPENURL(url) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]

#define USERDEFAULTS [NSUserDefaults standardUserDefaults]

#define AccountRowIsRefresh @"AccountRowIsRefresh"
#define IsNeedInitAddressBookRef [USERDEFAULTS boolForKey:@"ISNeedInitAddressBookRef"]

#define USEHELP @"    尊敬的用户，欢迎您使用号簿助手手机客户端！\n\n1、什么是号簿助手？\n    号簿助手是由中国电信提供的安全、可靠、跨终端、跨网络的通讯录管理软件，您可以通过本客户端进行通讯录安全备份和便捷恢复，是您换机时的好帮手、管理通讯录的好助手。\n\n2、什么是天翼帐号？有什么作用？\n    天翼帐号是中国电信为用户提供的业务统一登录帐号，使用天翼帐号可畅行中国电信提供的众多互联网服务，您可以访问http://pim.189.cn使用您的手机号码注册天翼帐号(支持中国境内所有手机)。\n    号簿助手使用天翼帐号验证您的身份，首次使用号簿助手的同步(上传/下载)功能时，需要设置您的天翼帐号和密码，为了您信息安全，请妥善保管您的帐号和密码。\n\n3、本客户端中所指的联系人包括哪些？\n    本地联系人为存储在手机终端中的联系人，不包括UIM卡或者SIM卡中的联系人，网络侧联系人为号簿助手WEB门户(http://pim.189.cn)中的“与手机同步的联系人”中的联系人。\n\n4、我应该如何设置数据网络来上传或下载通讯录呢？\n    号簿助手支持用户使用WIFI或运营商的移动网络(2G/3G)同步、上传或下载通讯录，推荐使用WIFI连接网络;如果您使用非中国电信移动网络，请将接入点切换至“互联网设置”，如中国移动互联网设置(CMNET)或中国联通互联网设置(UNINET)。\n\n5、什么是通讯录同步？\n    同步可以实现本地通讯录和网络侧通讯录信息互相更新;同步完成后用户手机本地和网络侧的通讯录均更新为最新的信息，并保持一致。\n\n6、什么是通讯录上传？\n    上传是指将手机本地通讯录通过数据网络(运营商无线网络或者WIFI网络)备份至号簿助手服务端，并覆盖服务端上原有的联系人信息;上传后，号簿助手服务端联系人和手机本地联系人保持一致。\n\n7、什么是通讯录下载？\n    当您更换手机或者通讯录丢失时可使用通讯录下载操作方便地恢复先前备份的通讯录信息。下载操作将号簿助手服务端的通讯录信息替换手机本地通讯录，原通讯录数据将被清除，请谨慎操作！\n\n8、同步失败应该怎么解决呢？\n    同步失败可能与您的网络状况有关，请检查您的数据网络，并尝试下载并安装最新版的客户端，如果您使用非中国电信移动网络，请将接入点切换至“互联网设置”。如果仍无法解决，请及时拔打我们的客服热线:10000号，我们将尽快协助您解决。\n\n9、如何获得更多关于号簿助手的信息呢？\n    如果您需要了解关于号簿助手业务的详细说明和使用帮助，请登录http://pim.189.cn查询。";

#define UserAgreement @"    尊敬的用户，您在使用本应用的过程中会因为数据连接而产生数据流量，数据流量费由运营商收取，详情请咨询当地运营商。\n    承诺若没有经过用户的允许，本软件绝不会对用户的联系人信息、通话记录、应用软件等进行扫描，同时也不会收集、处理或泄露用户的个人信息。\n    声明本软件带有读取、 删除、 编辑联系人、发送短信等功能；\n    为了向用户提供优质、个性化的服务，中国电信承诺遵循合法、正当、必要的原则，依法收集用户的客户资料等个人信息，用于提供电信服务、与用户沟通联系、改善服务质量等用途，并依法负有保密义务，不得泄露、篡改或者损毁。有权机关依法对用户个人信息调查取证的，中国电信有义务配合。"


/*固定Url地址*/
//会员说明
#define hyqysmUrl @"http://pim.189.cn/module/hyqysm.html"
