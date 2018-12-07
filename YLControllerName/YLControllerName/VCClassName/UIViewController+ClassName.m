//
//  UIViewController+ClassName.m
//  ShowControllerName
//
//  Created by Conner on 2018/12/5.
//  Copyright © 2018 Conner. All rights reserved.
//

#import "UIViewController+ClassName.h"
#import <objc/runtime.h>

#define kClassNameLabelTag 54321
static BOOL displayClassName = NO;
@implementation UIViewController (ClassName)
//交换viewDidApper 方法
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidAppear:);
        SEL swizzledSelector = @selector(yl_viewDidAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

+ (void)displayClassName:(BOOL)yesOrNo
{
    displayClassName = yesOrNo;
    if (displayClassName) {
        [self displayClassName];
    } else {
        [self removeClassName];
    }
}

#pragma mark - Method Swizzling
- (void)yl_viewDidAppear:(BOOL)animated
{
    [self yl_viewDidAppear:animated];

    if (displayClassName) {
        [[self class] displayClassName];
        [self showClassName];
    }
}

+ (void)displayClassName
{
    UIWindow *window = [self appWindow];

    UILabel *classNameLabel;
    if ([window viewWithTag:kClassNameLabelTag]) {
        classNameLabel = (UILabel *)[window viewWithTag:kClassNameLabelTag];
        [window bringSubviewToFront:classNameLabel];
    } else {
        classNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, window.bounds.size.width, 30)];
        classNameLabel.textColor = [UIColor redColor];
        classNameLabel.font = [UIFont systemFontOfSize:12];
        classNameLabel.tag = kClassNameLabelTag;
        classNameLabel.numberOfLines = 2;
        [window addSubview:classNameLabel];
        [window bringSubviewToFront:classNameLabel];
    }
}

- (void)showClassName {
    if ([self needDisplay]) {
        NSString *classNameStr = NSStringFromClass([self class]);
        NSString *parentClassNameStr = NSStringFromClass([[self getTopParentVC] class]);
        UIWindow *window = [UIViewController appWindow];
        UILabel *classNameLabel = (UILabel *)[window viewWithTag:kClassNameLabelTag];
        if ([classNameStr isEqualToString:parentClassNameStr]) {
            [classNameLabel setText:classNameStr];
        } else {
            [classNameLabel setText:[NSString stringWithFormat:@"P_%@\nC_%@",parentClassNameStr,classNameStr]];
        }
    }
}

+ (void)removeClassName
{
    UIWindow *window = [self appWindow];
    UILabel *classNameLabel;
    if ([window viewWithTag:kClassNameLabelTag]) {
        classNameLabel = (UILabel *)[window viewWithTag:kClassNameLabelTag];
        [classNameLabel removeFromSuperview];
    }
}

- (BOOL)needDisplay
{
    if ([self isKindOfClass:[UIInputViewController class]]) {
        return NO;
    } else if ([self isKindOfClass:[UINavigationController class]]) {
        return NO;
    } else {
        return YES;
    }
}

+ (UIWindow *)appWindow
{
    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    return [appDelegate window];
}

- (UIViewController *)getTopParentVC {
    if (self.parentViewController) {
        if ([self.parentViewController isKindOfClass:[UINavigationController class]] || [self.parentViewController isKindOfClass:[UITabBarController class]]) {
            return self;
        } else {
            return [self.parentViewController getTopParentVC];
        }
    } else {
        return self;
    }
}
@end
