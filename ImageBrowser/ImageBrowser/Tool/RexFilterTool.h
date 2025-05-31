//
//  RexFilterTool.h
//  ImageBrowser
//
//  Created by fumi on 2019/5/9.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RexFilterTool : NSObject

/** 从内容中筛选出图片地址信息 */
+ (NSArray <NSString *> *)imageUrlsFromContent:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
