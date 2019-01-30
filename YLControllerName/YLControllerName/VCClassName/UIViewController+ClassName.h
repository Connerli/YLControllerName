//
//  UIViewController+ClassName.h
//  ShowControllerName
//
//  Created by Conner on 2018/12/5.
//  Copyright © 2018 Conner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ClassName)
/**
 显示类名
 
 @param display 是否显示 default NO
 @param color 显示文字颜色 default RedColor
 */
+ (void)displayClassName:(BOOL)display textColor:(nullable UIColor *)color;
@end

NS_ASSUME_NONNULL_END
