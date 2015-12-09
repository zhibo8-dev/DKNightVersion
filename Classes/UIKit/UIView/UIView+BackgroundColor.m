//
//  UIView+BackgroundColor.m
//  UIView+BackgroundColor
//
//  Copyright (c) 2015 Draveness. All rights reserved.
//
//  These files are generated by ruby script, if you want to modify code
//  in this file, you are supposed to update the ruby code, run it and
//  test it. And finally open a pull request.

#import "UIView+BackgroundColor.h"
#import "DKNightVersionManager.h"
#import "objc/runtime.h"

@interface UIView ()

@end

@implementation UIView (BackgroundColor)

- (UIColor *(^)(void))backgroundColorPicker {
    return objc_getAssociatedObject(self, @selector(backgroundColorPicker));
}

- (void)setBackgroundColorPicker:(UIColor *(^)(void))picker {
    objc_setAssociatedObject(self, @selector(backgroundColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    SEL sel = NSSelectorFromString(setBackgroundColor:);
    [self performSelector:sel withObject:picker()];
    [self.pickers setValue:picker forKey:setBackgroundColor:];
}


@end
