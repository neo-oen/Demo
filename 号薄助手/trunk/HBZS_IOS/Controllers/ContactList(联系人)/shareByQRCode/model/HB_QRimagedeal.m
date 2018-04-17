//
//  HB_QRimagedeal.m
//  HBZS_IOS
//
//  Created by 冯强迎 on 16/10/26.
//
//

#import "HB_QRimagedeal.h"

@implementation HB_QRimagedeal


#pragma mark 图片像素处理
void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}
+(UIImage *)QRCodeImageStyleChange:(UIImage *)image toColorHex:(NSString *)hexString
{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    
    size_t bytesPerRow = imageWidth*4;
    uint32_t * rgbImageBuf = (uint32_t *)malloc(bytesPerRow * imageHeight);
    //创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,   kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    
    
    //转换颜色值
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    
    range.location+=2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    
    range.location+=2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];
    
    //遍历像素点
    int pixeNum = imageWidth * imageHeight;
    
    uint32_t * pCurPtr = rgbImageBuf;
    
    for (int i = 0; i<pixeNum; i++,pCurPtr++) {
        if ((*pCurPtr & (uint32_t)0xFFFFFF00) !=0)    // 将白色变成透明
        {
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0; //alpha
            ptr[1] = 255;//blue
            ptr[2] = 255;//green
            ptr[3] = 255;//red
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[1] = blue;
            ptr[2] = green;
            ptr[3] = red;
        }
    }
    //
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    
    
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL,true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    
    return resultUIImage;
    
}
@end
