//
//  UIViewController+XJForVcMethodSwizzle.m
//  XJMethodSwizzleDemo
//
//  Created by jamace on 2018/11/12.
//  Copyright © 2018年 com.jamace.com. All rights reserved.
//

#import "UIViewController+XJForVcMethodSwizzle.h"
#import <objc/runtime.h>

@implementation UIViewController (XJForVcMethodSwizzle)
//load方法会在类或者category里面加入了runtime的时候会被触发，并且只会调用一次
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //替换系统viewDidAppear方法,当类调用viewDidAppear方法的时候会去执行xj_viewDidAppear，方法，而后会执行viewDidAppear方法
        [self swizzled_swizzleMethod:class originalSelector:@selector(viewDidAppear:) swizzledSelector:@selector(xj_viewDidAppear:)];
        //替换系统viewDidAppear方法,当类调用viewWillDisappear方法的时候会去执行xj_viewWillDisAppear，方法，而后会执行viewDviewWillDisappearidAppear方法
        [self swizzled_swizzleMethod:class originalSelector:@selector(viewWillDisappear:) swizzledSelector:@selector(xj_viewWillDisAppear:)];
    });
}
//当控制器类调用viewDidAppear的时候会触发该方法，xj_viewDidAppear的作用是触发系统的viewDidAppear方法
-(void)xj_viewDidAppear:(BOOL)animated
{
    [self xj_viewDidAppear:YES];
    NSString *className = NSStringFromClass([self class]);
    NSLog(@"xj_viewDidAppear----%@",className);
    //统计页面
//    [MobClick beginLogPageView:className];
}
//当控制器类调用viewWillDisAppear的时候会触发该方法，xj_viewWillDisAppear的作用是触发系统的viewWillDisAppear方法
-(void)xj_viewWillDisAppear:(BOOL)animated
{
    [self xj_viewWillDisAppear:YES];
    NSString *className = NSStringFromClass([self class]);
    NSLog(@"xj_viewWillDisAppear----%@",className);
    //统计页面
//    [MobClick endLogPageView:className];
}

//方法替换
+ (void)swizzled_swizzleMethod:(Class)cls originalSelector:(SEL)originalSel swizzledSelector:(SEL)swizzledSel {
    Class class = cls;
    SEL originalSelector = originalSel;
    SEL swizzledSelector = swizzledSel;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
