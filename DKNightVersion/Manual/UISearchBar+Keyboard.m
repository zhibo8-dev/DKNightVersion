//
//  UISearchBar+Keyboard.m
//  DKNightVersion
//
//  Created by Draveness on 6/8/16.
//  Copyright © 2016 Draveness. All rights reserved.
//

#import "UISearchBar+Keyboard.h"
#import "NSObject+Night.h"
#import <objc/runtime.h>

@interface NSObject ()


@end

@implementation UISearchBar (Keyboard)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(init);
        SEL swizzledSelector = @selector(dk_init);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
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

- (instancetype)dk_init {
    UISearchBar *obj = [self dk_init];
    if (self.dk_manager.supportsKeyboard && [self.targetThemeVersion isEqualToString:DKThemeVersionNight]) {
        
        if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0) {
            UISearchTextField *searchField = obj.searchTextField;
            searchField.keyboardAppearance = UIKeyboardAppearanceDark;
        }else {
            UITextField *searchField = [obj valueForKey:@"_searchField"];
            searchField.keyboardAppearance = UIKeyboardAppearanceDark;
        }
    } else {
        if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0) {
            UISearchTextField *searchField = obj.searchTextField;
            searchField.keyboardAppearance = UIKeyboardAppearanceDefault;
        }else {
            UITextField *searchField = [obj valueForKey:@"_searchField"];
            searchField.keyboardAppearance = UIKeyboardAppearanceDefault;
        }
    }

    return obj;
}

- (void)did_updateColor_business {
    if (self.dk_manager.supportsKeyboard && [self.targetThemeVersion isEqualToString:DKThemeVersionNight]) {
        if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0) {
        UISearchTextField *searchField = self.searchTextField;
        searchField.keyboardAppearance = UIKeyboardAppearanceDark;
        }else {
            UITextField *searchField = [self valueForKey:@"_searchField"];
            searchField.keyboardAppearance = UIKeyboardAppearanceDark;
        }
    } else {
        if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 13.0) {
        UISearchTextField *searchField = self.searchTextField;
        searchField.keyboardAppearance = UIKeyboardAppearanceDefault;
        }else {
            UITextField *searchField = [self valueForKey:@"_searchField"];
            searchField.keyboardAppearance = UIKeyboardAppearanceDefault;
        }
    }
}

@end
