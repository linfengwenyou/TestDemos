//
//  Macros.h
//  ImageBrowser
//
//  Created by fumi on 2019/5/9.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/** 类名转换 */
#define RAYStringOfClass(o) NSStringFromClass([o class])

#define kPlaceHolder [UIImage imageNamed:@"common_placeholder"]
#define KeyWindow [UIApplication sharedApplication].keyWindow

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** 16进制带透明Color */
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#endif /* Macros_h */
