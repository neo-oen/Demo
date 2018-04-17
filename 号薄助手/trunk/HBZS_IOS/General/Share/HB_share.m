//
//  HB_share.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/6/28.
//
//

#import "HB_share.h"


#import "UMSocial.h"
#import "YXApi.h"
#import "WXApi.h"


@implementation HB_share

+(void)RegisterUMShare
{
    //***********友盟相关代码  2015.8.25--yx****************
    //1.注册appKey
    [UMSocialData setAppKey:UM_AppId];
    //设置易信Appkey和分享url地址,注意需要引用头文件
    [UMSocialYixinHandler setYixinAppKey:Yixin_AppId url:@"http://pim.189.cn"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:Weixin_AppId appSecret:Weixin_appSecret url:@"http://pim.189.cn"];
    [UMSocialQQHandler setQQWithAppId:QQ_appId appKey:QQ_appKey url:@"http://pim.189.cn"];
    //隐藏所有没有安装客户端的平台
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline,UMShareToYXSession,UMShareToYXTimeline]];//报错
    //**********************友盟SDK__END*********************

}

-(void)shareWithCurrentVc:(id)currentVc andTitle:(NSString *)title andText:(NSString *)shareInfo andUrl:(NSString *)shareUrl andImage:(UIImage *)headImage andSharePlatForms:(NSArray *)Platforms
{
    NSMutableArray * shareToAppArr=[[NSMutableArray alloc]init];
    //设置为非纯图片模式
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeNone;
    [UMSocialData defaultData].extConfig.yxsessionData.yxMessageType = UMSocialYXMessageTypeNone;
    
    if (Platforms == nil) {
        //判断设备是否安装微信、易信，如果没有则不显示
        if ([YXApi isYXAppInstalled] && [YXApi isYXAppSupportApi]) {
            //如果易信安装了，并且支持分享功能
            [shareToAppArr addObjectsFromArray:@[UMShareToYXSession,UMShareToYXTimeline]];
        }
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            //当前用户安装了微信，并且支持开放api
            [shareToAppArr addObjectsFromArray:@[UMShareToWechatSession,UMShareToWechatTimeline]];
        }
        [shareToAppArr addObjectsFromArray:@[UMShareToQQ,UMShareToQzone]];
    }
    else
    {
        [shareToAppArr addObjectsFromArray:Platforms];
    }
    
    
    if (shareToAppArr.count) {
        
        if (shareUrl.length) {
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
            [UMSocialData defaultData].extConfig.yxsessionData.url = shareUrl;
            [UMSocialData defaultData].extConfig.yxtimelineData.url = shareUrl;
            
            
            [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
            [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
            
            
        }
        if (title.length) {
            [UMSocialData defaultData].extConfig.title = title;
        }
        
        
        [UMSocialSnsService presentSnsIconSheetView:currentVc appKey:UM_AppId  shareText:shareInfo shareImage:headImage shareToSnsNames:shareToAppArr delegate:nil];//@"号簿助手，让生活更便捷，马上下载安装吧！http://pim.189.cn"
    }else{
//        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"您没有安装易信或者微信客户端" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
    }
    [shareToAppArr release];
}

//
-(void)imageShare:(UIImage*)image withVc:(id)vc withSharePlatForms:(NSArray*)platForms
{
    
    NSMutableArray * shareToAppArr=[[NSMutableArray alloc]init];
    if (platForms.count) {
        [shareToAppArr addObjectsFromArray:platForms];
    }
    else
    {
        [shareToAppArr addObjectsFromArray:@[UMShareToQQ,UMShareToWechatSession,UMShareToYXSession]];
    }
    
    
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.yxsessionData.yxMessageType = UMSocialYXMessageTypeImage;
    [UMSocialSnsService presentSnsIconSheetView:vc appKey:UM_AppId  shareText:nil shareImage:image shareToSnsNames:shareToAppArr delegate:nil];
    
}

#pragma mark - 友盟分享的回调函数
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        ZBLog(@"分享到的平台为：%@",[[response.data allKeys] objectAtIndex:0]);
    }
    
    [self release];
}

@end
