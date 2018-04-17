//
//  ConfigMgr.h
//  HBZS_IOS
//
//  Created by rentao on 5/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConfigMgr : NSObject {
    
	NSMutableDictionary* configDict;
}

+ (ConfigMgr*)getInstance;                 //取得ConfigMgr的对象实例。

- (void) load;                            //从文件中加载配置项。

- (void) save;                           //保存配置项到文件中。

/*
 * 设置配置项，key-value配置项是domain组下的元素
 */
- (void) setValue:(id)value forKey:(NSString *)key forDomain:(NSString *)domain;

/*
 * 获取配置项，根据domain组下的key获取相应的value
 */
- (id) getValueForKey:(NSString *)key forDomain:(NSString *)domain;

@end

// 配置文件说明
/*
 // 客户端配置
 BatchUploadContactLimit: 设置分批上传联系人时每批的数量
 BatchDownloadContactLimit: 设置分批下载联系人时每批的数量
 contactListVersion: 本地通信录的版本号
 
 //用户同步头像设置
 userSetSyncHeadimgOn: 1表示用户从同步头像关闭设置为开启 0为用户没有做过该类操作 需要在获得这个属性为1时并做相应处理之后将其设置为0
 
 // 临时账号密码，用于验证申请
 pimaccount: 通行证号码
 pimpassword: 密码
 
 // 正式帐号名密码
 user_name: 账号
 user_psw: 密码
 
 // 服务端配置
 sessionExpires: 
 tpnoolVersion: 
 authUrl: 
 tpnoolUrl: 
 uploadPortraitUrl: 
 downloadPortraitUrl: 
 uploadAllUrl: 
 getContactListUrl: 
 downloadContactUrl: 
 syncUploadContactUrl: 
 getContactListVersionUrl: 
 slowSyncUrl: 
 syncPortraitUrl: 
 syncSmsUrl: 
 uploadSmsUrl: 
 downloadSmsUrl: 
 clientReportUrl: 
 */