//
//  UIViewController+TitleView.m
//  HBZS_IOS
//
//  Created by zimbean on 13-10-27.
//
//

#import "UIViewController+TitleView.h"

@implementation UIViewController (TitleView)

- (void)setVCTitle:(NSString *)title{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = 1;
    titleLabel.text = title;
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
}

- (void)setVCTitle:(NSString *)title backupButtonIsHidden:(BOOL)isHidden{
    if (isHidden) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = 1;
        titleLabel.text = title;
        self.navigationItem.titleView = titleLabel;
        [titleLabel release];
    }
    else{
        NSLog(@"L: %@", NSStringFromCGRect(self.navigationItem.leftBarButtonItem.customView.frame));
        UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(-20, 0, 320, 44)];
        customView.backgroundColor = [UIColor clearColor];
        UIButton *backupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backupBtn.frame = CGRectMake(0, 7, 30, 30);
        [backupBtn setImage:UIImageWithName(@"icon_select_refresh_unclick.png") forState:UIControlStateNormal];
        [backupBtn setImage:UIImageWithName(@"icon_select_refresh_click.png") forState:UIControlEventTouchUpInside];
        [customView addSubview:backupBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 7, 240, 30)];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = 0;
        titleLabel.text = title;
        [customView addSubview:titleLabel];
        
        self.navigationItem.titleView = customView;
        [titleLabel release];
    }
}

- (void)allocSyncButton{
    UIButton *syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
    syncButton.frame = CGRectMake(0, 0, 62.5, 44);
    syncButton.backgroundColor = [UIColor redColor];
   // [self.navigationItem.titleView addSubview: syncButton];
    [self.navigationController.navigationBar addSubview:syncButton];
}

- (NSString *)vcTitle{
    if ([self.navigationItem.titleView isKindOfClass:[UILabel class]]) {
        UILabel *titleLabel = (UILabel *)(self.navigationItem.titleView);
        return titleLabel.text;
    }else if ([self.navigationItem.titleView isKindOfClass:[UIButton class]]){
        UIButton *btn=(UIButton *)(self.navigationItem.titleView);
        return btn.titleLabel.text;
    }else{
        return @"返回标题错误";
    }
}

#pragma mark - 2015.4.17 添加导航栏标题按钮
-(void)setVCTitleButtonWithTitle:(NSString *)title{
    //动态计算按钮的宽度
    CGSize size=[self dynamicSizeWithStr:title andFontSize:20 andHight:30];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (size.width<140) {
        btn.frame=CGRectMake(0, 0, size.width  +25, 30);
        btn.imageEdgeInsets=UIEdgeInsetsMake(0, size.width+15, 0, 0);
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    }else{
        btn.frame=CGRectMake(0, 0, 140 + 25, 30);
        btn.imageEdgeInsets=UIEdgeInsetsMake(0,  140 +15, 0, 0);
        btn.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);

    }
    
    btn.titleLabel.font=[UIFont systemFontOfSize:20];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor clearColor];
    btn.titleLabel.textAlignment=NSTextAlignmentLeft;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_down_top"] forState:UIControlStateSelected];
    btn.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    btn.tag=100;
    self.navigationItem.titleView=btn;
}
#pragma mark - 动态计算label的frame
/**
 *  动态计算label的frame
 *
 *  @param str      <#str description#>
 *  @param fontSize <#fontSize description#>
 *  @param hight    <#hight description#>
 *
 *  @return <#return value description#>
 */
-(CGSize)dynamicSizeWithStr:(NSString *)str andFontSize:(CGFloat)fontSize andHight:(CGFloat )hight{
    /*
     动态行高
     1.iOS7以后
     2.iOS7以前
     */
    //获取设备相关信息
    //系统版本
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    //pre --> 版本的第一位
    NSString *pre = [systemVersion substringToIndex:1];
    if ([pre intValue] >= 7) {
        //iOS7以后，使用如下方法
        //根据label要显示的内容(字符串)动态设置行高
        /*
         第一个参数：CGSize --> label的最大宽高
         第二个参数：附件条件 --> NSStringDrawingUsesLineFragmentOrigin --> 一行所占的区域(文本高度+行距)
         第三个参数：属性字典 --> font
         第四个参数：nil --> 按默认的
         */
        //font的大小要跟label的font保持一致
        UIFont *font = [UIFont systemFontOfSize:fontSize];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        
        //要显示的文字所占的矩形区域
        CGRect rect = [str boundingRectWithSize:CGSizeMake(1000, hight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
        return rect.size;
    }
    else{
        //iOS7以前，使用如下方法
        /*
         第一个参数：字体的大小 --> 跟label的保持一致
         第二个参数：CGSize
         第三个参数：换行方式
         */
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(1000, hight) lineBreakMode:NSLineBreakByCharWrapping];
        return size;
    }
}
#pragma mark -


@end
