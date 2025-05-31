//
//  RexFilterTool.m
//  ImageBrowser
//
//  Created by fumi on 2019/5/9.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "RexFilterTool.h"

@implementation RexFilterTool
//
//+ (instancetype)shareInstance {
//
//    static RexFilterTool * instance;
//    static dispatch_once_t token;
//    dispatch_once(&token, ^{
//        instance = [[RexFilterTool alloc] init];
//    });
//    return instance;
//}

+ (NSArray <NSString *> *)imageUrlsFromContent:(NSString *)content {
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:10];
    
    /** 需要在此处使用正则表达式进行筛选 */
    NSString *imageRegx = @"http[^\"\';]*?\\.(jpg|png|jpeg)[^\")]*(?=(\"|\'))";
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:imageRegx options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *results = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    if (results.count <= 0) {
        return nil;
    }
    
    for (NSTextCheckingResult *result in results) {
        NSString *tmpString = [content substringWithRange:result.range];
        
        // 做一层筛选
       tmpString = [tmpString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        if ([tmpString containsString:@"%3A"]) {   // 内部有URL编码，需要解码后操作
            tmpString = [tmpString stringByRemovingPercentEncoding];
            // 需要遍历执行
            NSArray *subArray = [RexFilterTool imageUrlsFromContent:tmpString ?: @""];
            if (subArray) {
                [tmpArr addObjectsFromArray:subArray];
            }
        } else if (![tmpArr containsObject:tmpString] && tmpString) {
            [tmpArr addObject:tmpString];            
        }
    }
//    NSLog(@"%@",tmpArr.description);
    return tmpArr;
}

@end
