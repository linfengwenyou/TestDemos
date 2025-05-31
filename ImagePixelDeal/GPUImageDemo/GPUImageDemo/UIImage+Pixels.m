//
//  UIImage+Pixels.m
//  GPUImageDemo
//
//  Created by rayor on 2021/5/27.
//

#import "UIImage+Pixels.h"

@implementation UIImage (Pixels)

const int RED = 1;
const int GREEN = 2;
const int BLUE = 3;


- (UIImage *)blendImageWithBImage:(UIImage *)bImage blendType:(KGImageBlendType)type {
    UIImage *image = self;
    
    // 通用配置：
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    // bImage
    CGRect bImageRect = CGRectMake(0, 0, bImage.size.width * bImage.scale, bImage.size.height * bImage.scale);
    int bWidth = bImageRect.size.width;
    int bHeight = bImageRect.size.height;
    
    uint32_t *bPixels = (uint32_t *)malloc(bWidth * bHeight * sizeof(uint32_t));
    memset(bPixels, 0, bWidth * bHeight * sizeof(uint32_t));
    
    CGContextRef ctxB = CGBitmapContextCreate(bPixels, bWidth, bHeight, 8, bWidth * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(ctxB, CGRectMake(0, 0, bWidth, bHeight), [bImage CGImage]);
    free(ctxB); // 直接销毁
    
    
    // aImage
    CGRect imageRect = CGRectMake(0, 0, image.size.width * image.scale, image.size.height * image.scale);
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    
    uint32_t *pixels = (uint32_t*)malloc(width * height * sizeof(uint32_t));
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    // 将像素写入其中
   
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    for (int y=0; y<height; y++) {
        @autoreleasepool {
            for (int x=0; x<width; x++) {
                @autoreleasepool {
                    uint8_t *rgbaPixel = (uint8_t*) & pixels[y * width + x];
                    
                    if (bPixels != NULL && y < bHeight && x < bWidth) {
                        uint8_t *bRgbPixel = (uint8_t*) & bPixels[y * width + x];
                        // 做颜色处理
                        [self updatePixel:rgbaPixel withBPixel:bRgbPixel blendType:type];
                    }
                    
                }
            }
        }
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    return resultImage;
}

- (UIImage *)blendImageWithColor:(UIColor *)bColor blendType:(KGImageBlendType)type {
    
    // 获取颜色数组
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    CGFloat a = 0;
    [bColor getRed:&r green:&g blue:&b alpha:&a];
    
    NSInteger rV = floor(r * 255);
    NSInteger gV = floor(g * 255);
    NSInteger bV = floor(b * 255);
    uint8_t bRgbPixel[] = {0,rV, gV, bV};

    
    
    UIImage *image = self;
    
    CGRect imageRect = CGRectMake(0, 0, image.size.width * image.scale, image.size.height * image.scale);
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    uint32_t *pixels = (uint32_t*)malloc(width * height * sizeof(uint32_t));
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    // 将像素写入其中
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    
    for (int y=0; y<height; y++) {
        @autoreleasepool {
            for (int x=0; x<width; x++) {
                @autoreleasepool {
                    uint8_t *rgbaPixel = (uint8_t*) & pixels[y * width + x];
                    // 做颜色处理
                    [self updatePixel:rgbaPixel withBPixel:bRgbPixel blendType:type];
                    
                }
            }
        }
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    
    return resultImage;
}



#pragma mark - 混合方式
- (void)updatePixel:(uint8_t *)aPixel withBPixel:(uint8_t *)bPixel blendType:(KGImageBlendType)type {
    
    if (type == KGImageBlendType_None) {
        return;
    }
    
    for (int i = 1; i <= BLUE; i++) {
        
        @autoreleasepool {
            
            switch (type) {
                case KGImageBlendType_Dark:
                {
                    aPixel[i] = [self useDarkenWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                    
                case KGImageBlendType_Multiply:
                {
                    aPixel[i] = [self useMultiplyWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_Burn:
                {
                    aPixel[i] = [self useBurnWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_LinarBurn:
                {
                    aPixel[i] = [self useLinarBurnWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_Lighten:
                {
                    aPixel[i] = [self useLightenWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_Filter:
                {
                    aPixel[i] = [self useFilterWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_ColorDoge:
                {
                    aPixel[i] = [self useColorDogeWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_LinearDodge:
                {
                    aPixel[i] = [self useLinearDodgeWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_OverLay:
                {
                    aPixel[i] = [self useOverLayerWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_SoftLight:
                {
                    aPixel[i] = [self useSoftLightWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_HardLight:
                {
                    aPixel[i] = [self useHardLightWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_VividLight:
                {
                    aPixel[i] = [self useVividLightWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_LinearLight:
                {
                    aPixel[i] = [self useLinearLightWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_PinLight:
                {
                    aPixel[i] = [self usePinLightWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_HardMix:
                {
                    aPixel[i] = [self useHardMixWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_Difference:
                {
                    aPixel[i] = [self useDifferenceWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                case KGImageBlendType_Exclusion:
                {
                    aPixel[i] = [self useExclusionWithA:aPixel[i] withB:bPixel[i]];
                }
                    break;
                default:
                    
                    break;
            }
            
            
        }
        
        
    }

}

/*变暗*/
- (NSInteger)useDarkenWithA:(NSInteger)A withB:(NSInteger)B {
    return B > A ? A : B;
}

/*正片叠底*/
- (NSInteger)useMultiplyWithA:(NSInteger)A withB:(NSInteger)B {
    return A*B/255;
}

/*颜色加深*/
- (NSInteger)useBurnWithA:(NSInteger)A withB:(NSInteger)B {
    return B == 0 ? B : MAX(0, (255 - ((255 - A) << 8 ) / B));
}

/*线性加深*/
- (NSInteger)useLinarBurnWithA:(NSInteger)A withB:(NSInteger)B {
    return (A + B < 255) ? 0 : (A + B - 255);
}

/*变亮*/
- (NSInteger)useLightenWithA:(NSInteger)A withB:(NSInteger)B {
    return (B > A) ? B : A;
}

/*滤色*/
- (NSInteger)useFilterWithA:(NSInteger)A withB:(NSInteger)B {
    return 255 - (((255 - A) * (255 - B)) >> 8);
}

/*颜色减淡*/
- (NSInteger)useColorDogeWithA:(NSInteger)A withB:(NSInteger)B {
    return (B == 255) ? B : MIN(255, ((A << 8 ) / (255 - B)));
}

/*线性减淡*/
- (NSInteger)useLinearDodgeWithA:(NSInteger)A withB:(NSInteger)B {
    return MIN(255, (A + B));
}

/*图像叠加*/
- (NSInteger)useOverLayerWithA:(NSInteger)A withB:(NSInteger)B {
    if (A <= 128) {   // 叠加
        return 2*A*B/255;
    } else {
        return 255-2*(255-A)*(255-B)/255;
    }
}


/*柔光*/
- (NSInteger)useSoftLightWithA:(NSInteger)A withB:(NSInteger)B {
    return B < 128 ? (2 * (( A >> 1) + 64)) * (B / 255) : (255 - ( 2 * (255 - ( (A >> 1) + 64 ) ) * ( 255 - B ) / 255 ));;
}

/*强光*/
- (NSInteger)useHardLightWithA:(NSInteger)A withB:(NSInteger)B {
    return (A < 128) ? (2 * A * B / 255) : (255 - 2 * (255 - A) * (255 - B) / 255);
}

/*亮光*/
- (NSInteger)useVividLightWithA:(NSInteger)A withB:(NSInteger)B {
    return B < 128 ? [self useBurnWithA:A  withB:2*B] : [self useColorDogeWithA:A withB:2*(B-128)];
}

/*线性光*/
- (NSInteger)useLinearLightWithA:(NSInteger)A withB:(NSInteger)B {
    return MIN(255, MAX(0, (B + 2 * A) - 1));
}

/*点光*/
- (NSInteger)usePinLightWithA:(NSInteger)A withB:(NSInteger)B {
    return MAX(0, MAX(2 * B - 255, MIN(B, 2*A)));
}

/*实色混合*/
- (NSInteger)useHardMixWithA:(NSInteger)A withB:(NSInteger)B {
    return ([self useVividLightWithA:A withB:B] < 128) ? 0 : 255;
}

/*差值*/
- (NSInteger)useDifferenceWithA:(NSInteger)A withB:(NSInteger)B {
    return labs(A-B);
}

/*排除*/
- (NSInteger)useExclusionWithA:(NSInteger)A withB:(NSInteger)B {
    return A + B - 2 * A * B / 255;
}

#pragma mark - name
+ (NSString *)nameWithType:(KGImageBlendType)type {
    switch (type) {
        case KGImageBlendType_None:
        {
            return  @"原图";
        }
            break;
        case KGImageBlendType_Dark:
        {
            return  @"变暗";
        }
            break;
        case KGImageBlendType_Multiply:
        {
            return  @"正片叠底";
        }
            break;
        case KGImageBlendType_Burn:
        {
            return  @"颜色加深";
        }
            break;
        case KGImageBlendType_LinarBurn:
        {
            return  @"线性加深";
        }
            break;
        case KGImageBlendType_Lighten:
        {
            return  @"变亮";
        }
            break;
        case KGImageBlendType_Filter:
        {
            return  @"滤色";
        }
            break;
        case KGImageBlendType_ColorDoge:
        {
            return  @"颜色减淡";
        }
            break;
        case KGImageBlendType_LinearDodge:
        {
            return  @"线性减淡";
        }
            break;
        case KGImageBlendType_OverLay:
        {
            return  @"叠加";
        }
            break;
        case KGImageBlendType_SoftLight:
        {
            return  @"柔光";
        }
            break;
        case KGImageBlendType_HardLight:
        {
            return  @"强光";
        }
            break;
        case KGImageBlendType_VividLight:
        {
            return  @"亮光";
        }
            break;
        case KGImageBlendType_LinearLight:
        {
            return  @"线性光";
        }
            break;
        case KGImageBlendType_PinLight:
        {
            return  @"点光";
        }
            break;
        case KGImageBlendType_HardMix:
        {
            return  @"实色混合";
        }
            break;
        case KGImageBlendType_Difference:
        {
            return  @"差值";
        }
            break;
        case KGImageBlendType_Exclusion:
        {
            return  @"排除";
        }
            break;
        default:
            return @"原图";
            break;
    }
}

@end
