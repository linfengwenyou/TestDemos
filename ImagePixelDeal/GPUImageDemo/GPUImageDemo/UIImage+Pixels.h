//
//  UIImage+Pixels.h
//  GPUImageDemo
//
//  Created by rayor on 2021/5/27.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, KGImageBlendType) {
    KGImageBlendType_None       = 0,        // 不混合
    KGImageBlendType_Dark,                  // 变暗
    KGImageBlendType_Multiply,              // 正片叠底
    KGImageBlendType_Burn,                  // 颜色加深
    KGImageBlendType_LinarBurn,             // 线性加深
    KGImageBlendType_Lighten,               // 变亮
    KGImageBlendType_Filter,                // 滤色
    KGImageBlendType_ColorDoge,             // 颜色减淡
    KGImageBlendType_LinearDodge,           // 线性减淡
    KGImageBlendType_OverLay,               // 叠加
    KGImageBlendType_SoftLight,             // 柔光
    KGImageBlendType_HardLight,             // 强光
    KGImageBlendType_VividLight,            // 亮光
    KGImageBlendType_LinearLight,           // 线性光
    KGImageBlendType_PinLight,              // 点光
    KGImageBlendType_HardMix,               // 实色混合
    KGImageBlendType_Difference,            // 差值
    KGImageBlendType_Exclusion,             // 排除
};


@interface UIImage (Pixels)

/*通过图像进行颜色混合*/
- (UIImage *)blendImageWithBImage:(UIImage *)bImage blendType:(KGImageBlendType)type;

/*通过颜色进行颜色混合*/
- (UIImage *)blendImageWithColor:(UIColor *)bColor blendType:(KGImageBlendType)type;

/*获取指定类型名称*/
+ (NSString *)nameWithType:(KGImageBlendType)type;

@end

// 将两张图片先对其，然后截取相同信息，进行像素叠加
/*
 1. 将图片对其，找到正常图片尺寸
 2. 复合计算两个图片的像素，得到一个新的数据
 3. 重新排列成新的图片
 
 可以参考： https://github.com/depthlove/blend-image/blob/master/BlendImage/BlendImage/BlendImageView.m
 https://blog.csdn.net/fansongy/article/details/79303646
 
 参考： https://blog.csdn.net/zylxadz/article/details/47803479?utm_medium=distribute.pc_relevant.none-task-blog-baidujs_title-1&spm=1001.2101.3001.4242
 */
