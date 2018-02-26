//
//  ViewController3.m
//  主流框架SB
//
//  Created by neo on 2018/2/10.
//  Copyright © 2018年 neo. All rights reserved.
//

#import "ViewController3.h"

@interface ViewController3 ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController3

#pragma mark - ============== 懒加载 ==============
#pragma mark - ============== 初始化 ==============
#pragma mark - ============== 接口 ==============
#pragma mark - ============== 方法 ==============

/**
 
 打开图片上下文
    设置图片上下文
 获取上下文，
 编辑上下文
 
 渲染上下文
 
 裁剪上下文
 
    读取图片
 关闭上下文
 设置图片


 猜测图片的充填是前面上下文的洞里
 */
- (IBAction)buttonClick:(UIButton *)sender {
    UIImage * image = [UIImage imageNamed:@"me"];
    CGFloat margin = 5;
    CGSize size = CGSizeMake(image.size.width + margin * 2, image.size.height + margin * 2);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGPoint centerP = CGPointMake(size.width/2, size.height/2);
    CGFloat radius = MIN(image.size.width, image.size.height)/2;
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter: centerP radius:radius  startAngle:0 endAngle:2* M_PI clockwise:YES];
    path.lineWidth = margin;
     [[UIColor redColor] set];

    [path stroke];
    [path addClip];
    
    [image drawAtPoint:CGPointMake(margin, margin)];
    
    NSString * stringName = @"路飞";
    
    //水印
    NSDictionary * attributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor greenColor]};
    
    [stringName drawInRect:CGRectMake(30 , 30, 40, 20) withAttributes:attributeDic];
    
    UIImage * ctrImage =  UIGraphicsGetImageFromCurrentImageContext();
    
    radius = radius + path.lineWidth/2;
    
    CGFloat x = (size.width - radius * 2)/2;
    CGFloat y = (size.height - radius * 2)/2;
    CGFloat width = 2 * radius;
    CGFloat height = 2 * radius;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    x *= scale;
    y *= scale;
    
    width *= scale;
    height *= scale;
    
    
    CGImageRef  imageRef = CGImageCreateWithImageInRect(ctrImage.CGImage, CGRectMake(x, y, width, height));
    
    
    
    ctrImage = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    
//    CGImageRelease(imageRef);
    
    UIGraphicsEndImageContext();
    
    [_imageView setImage:ctrImage];
    
    
    UIImageWriteToSavedPhotosAlbum(ctrImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
/*
 获取路径
 数据化图片
 保存图片
 */
    
    NSString * documentPath = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,  NSUserDomainMask, YES).lastObject;
    
    NSString * filePath = [documentPath stringByAppendingString:@"010.png"];
    
    NSData * imageData = UIImagePNGRepresentation(ctrImage);
    
    [imageData writeToFile:filePath atomically:YES];
    NSLog(@"%@",filePath);
    
  
    [self viewToImage];
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;{
    
}

-(void)viewToImage{

    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0);
    
    //屏幕截图
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:ctr];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndPDFContext();
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
}

#pragma mark - ============== 代理 ==============
#pragma mark - ============== 设置 ==============
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
