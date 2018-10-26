//
//  UIView+Event.m
//  DemoTestSlider
//
//  Created by fumi on 2018/10/24.
//  Copyright © 2018年 fumi. All rights reserved.
//

#import "UIView+Event.h"
#import <objc/runtime.h>

@implementation UIView (Event)

const char *key = "demoKey";

- (void)setIdentifier:(NSString *)identifier
{
    objc_setAssociatedObject(self, key, identifier, OBJC_ASSOCIATION_COPY);
}

- (NSString *)identifier
{
   return objc_getAssociatedObject(self, key);
}

+ (void)load
{
    Method originMethod = class_getInstanceMethod(self, @selector(hitTest:withEvent:));
    Method newMethod = class_getInstanceMethod(self, @selector(lius_hitTest:withEvent:));
    
    
    if (!class_addMethod(self, @selector(hitTest:withEvent:), method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        method_exchangeImplementations(originMethod, newMethod);
    } else {
        class_replaceMethod(self, @selector(lius_hitTest:withEvent:), method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
   
    
    Method originMethod1 = class_getInstanceMethod(self, @selector(pointInside:withEvent:));
    Method newMethod1 = class_getInstanceMethod(self, @selector(lius_pointInside:withEvent:));
    
    
    if (!class_addMethod(self, @selector(pointInside:withEvent:), method_getImplementation(newMethod1), method_getTypeEncoding(newMethod1))) {
        method_exchangeImplementations(originMethod1, newMethod1);
    } else {
        class_replaceMethod(self, @selector(lius_pointInside:withEvent:), method_getImplementation(originMethod1), method_getTypeEncoding(originMethod1));
    }
}

- (UIView *)lius_hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *targetView = [self lius_hitTest:point withEvent:event];

    if ([self.identifier isKindOfClass:[NSString class]] && self.identifier.length > 0) {
        NSLog(@"hit self view: <%@-%p> targetView:%@", NSStringFromClass([self class]),self,targetView.identifier);
    }
    return targetView;
}


- (BOOL)lius_pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL isInside = [self lius_pointInside:point withEvent:event];
    if ([self.identifier isKindOfClass:[NSString class]] && self.identifier.length > 0) {
         NSLog(@"point in side targetView:<%@-%p> is inside:%@",NSStringFromClass([self class]),self,isInside?@"YES":@"NO");
    }
   
    return isInside;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.identifier isKindOfClass:[NSString class]] && self.identifier.length > 0) {
        NSLog(@"touchesBegan method:<%@-%p>, view:%@",NSStringFromClass([self class]),self,touches.anyObject.view.identifier);
    }
    [super touchesBegan:touches withEvent:event];
    
//    if (![self.identifier isEqualToString:@"Aview"]) {
//        [super touchesBegan:touches
//                  withEvent:event];
//    } else {
//        NSLog(@"打印了AView");
//    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.identifier isKindOfClass:[NSString class]] && self.identifier.length > 0) {
        NSLog(@"touchesEnded method:<%@-%p>, view:%@",NSStringFromClass([self class]),self,touches.anyObject.view.identifier);
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.identifier isKindOfClass:[NSString class]] && self.identifier.length > 0) {
        NSLog(@"touchesCancelled method:<%@-%p>, view:%@",NSStringFromClass([self class]),self,touches.anyObject.view.identifier);
    }
    [super touchesCancelled:touches withEvent:event];
    
}

@end
