//
//  NSObject+Night.m
//  DKNightVersion
//
//  Created by Draveness on 15/11/7.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import "NSObject+Night.h"
#import "NSObject+DeallocBlock.h"
#import <objc/runtime.h>

@interface DKMutableDict ()

@property (nonatomic, strong) NSMutableDictionary *realDict;

@end

@implementation DKMutableDict

- (NSMutableDictionary *)realDict
{
    if (_realDict == nil) {
        _realDict = [NSMutableDictionary dictionary];
    }
    return _realDict;
}


- (void)setObject:(id)anObject forKey:(id)aKey
{
    if (anObject) {
        [self.realDict setObject:anObject forKey:aKey];
    } else {
        [self.realDict removeObjectForKey:aKey];
    }
    self.didUpdateValue(self.realDict.allKeys.count <= 0);
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [self.realDict setValue:value forKey:key];
    self.didUpdateValue(self.realDict.allKeys.count <= 0);
}

- (id)valueForKey:(NSString *)key
{
    return [self.realDict valueForKey:key];
}

// 消息转发 外部调用把DKMutableDict认为是NSMutableDictionary 让realDict去执行对应的方法
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.realDict;
}

@end


static void *DKViewDeallocHelperKey;

@interface NSObject ()

// 用这个中转的值来判断 当前pickers是否存在键值对 直接访问self.picker会触发get方法
@property (nonatomic, assign) BOOL pickersIsNotEmpty;

// 记录当前控件的日夜间模式
@property (nonatomic, strong) DKThemeVersion *themeVersion;

@end

@implementation NSObject (Night)

#pragma mark - getter
- (DKMutableDict *)pickers
{
    DKMutableDict *pickers = objc_getAssociatedObject(self, @selector(pickers));
    if (!pickers) {
        
        pickers = [[DKMutableDict alloc] init];
        pickers.didUpdateValue = ^(BOOL isEmpty) {
            self.pickersIsNotEmpty = !isEmpty;
        };
        
        self.themeVersion = self.dk_manager.themeVersion;
        objc_setAssociatedObject(self, @selector(pickers), pickers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return pickers;
}

- (DKNightVersionManager *)dk_manager {
    return [DKNightVersionManager sharedManager];
}

- (BOOL)pickersIsNotEmpty
{
    return [objc_getAssociatedObject(self, @selector(pickersIsNotEmpty)) boolValue];
}


- (DKThemeVersion *)themeVersion
{
    return objc_getAssociatedObject(self, @selector(themeVersion));
}

- (DKThemeVersion *)enableThemeVersion
{
    return objc_getAssociatedObject(self, @selector(enableThemeVersion));
}

- (BOOL)igonreSuperColorMode
{
    return objc_getAssociatedObject(self, @selector(igonreSuperColorMode));
}

- (DKThemeVersion *)targetThemeVersion
{
    if (self.enableThemeVersion) {
        return self.enableThemeVersion;
    }
    return self.dk_manager.themeVersion;
}

#pragma mark - setter
- (void)setPickersIsNotEmpty:(BOOL)pickersIsNotEmpty
{
    objc_setAssociatedObject(self, @selector(pickersIsNotEmpty), @(pickersIsNotEmpty), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当picker字典有值 就代表日夜间切换的时候要进行UI刷新 监听通知
    if (pickersIsNotEmpty) {
        [self dk_addColorChangeNoti];
    } else {
        [self dk_removeColorChangeNoti];
    }
}

- (void)setThemeVersion:(DKThemeVersion *)themeVersion
{
    objc_setAssociatedObject(self, @selector(themeVersion), themeVersion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setEnableThemeVersion:(DKThemeVersion *)enableThemeVersion
{
    if ([self.enableThemeVersion isEqualToString:enableThemeVersion]) {
        return;
    }
    
    // 如果父控件设置了 并且当前跟随父控件 只能跟父控件一样
    if (!self.igonreSuperColorMode &&
        [self respondsToSelector:@selector(superview)]) {
        UIView *superView = [self performSelector:@selector(superview)];
        if (superView.enableThemeVersion &&
            ![superView.enableThemeVersion isEqualToString:enableThemeVersion]) {
            return;
        }
    }
    objc_setAssociatedObject(self, @selector(enableThemeVersion), enableThemeVersion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 遍历赋值给子控件
    if ([self respondsToSelector:@selector(subviews)]) {
        UIView *view = (UIView *)self;
        for (UIView *subView in view.subviews) {
            if (!subView.igonreSuperColorMode) {
                subView.enableThemeVersion = enableThemeVersion;
            }
        }
        view.layer.enableThemeVersion = enableThemeVersion;
    }
    
    [self night_updateColor];
}

- (void)setIgonreSuperColorMode:(BOOL)igonreSuperColorMode
{
    objc_setAssociatedObject(self, @selector(igonreSuperColorMode), @(igonreSuperColorMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 颜色更新
- (void)night_updateColor {
    
    if (!self.pickersIsNotEmpty) {
        return;
    }
    
    // 如果已经是当前颜色模式 直接return
    if ([self.themeVersion isEqualToString:self.targetThemeVersion]) {
        return;
    }
    
    [self night_updateColor_business];
    [self did_updateColor_business];
    
    self.themeVersion = self.targetThemeVersion;
}

- (void)night_updateColor_business
{
    [self.pickers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull selector, DKColorPicker  _Nonnull picker, BOOL * _Nonnull stop) {
        SEL sel = NSSelectorFromString(selector);
        id result = picker(self.targetThemeVersion);
        [UIView animateWithDuration:DKNightVersionAnimationDuration
                         animations:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                             [self performSelector:sel withObject:result];
#pragma clang diagnostic pop
                         }];
    }];
}

- (void)did_updateColor_business
{
    
}

#pragma mark - 添加/移除通知
- (void)dk_addColorChangeNoti
{
    // 避免重复添加 先移除
    [self dk_removeColorChangeNoti];
    
    
    // 如果当前的pickers没有键值对 不需要响应通知
    if (!self.pickersIsNotEmpty) {
        return;
    }
    
    // 好像是因为避免分类dealloc不执行的问题 不在dealloc中接触通知的绑定
    @autoreleasepool {
        if (objc_getAssociatedObject(self, &DKViewDeallocHelperKey) == nil) {
            __unsafe_unretained typeof(self) weakSelf = self;
            // self被销毁了 关联对象肯定会执行到dealloc方法
            id deallocHelper = [self addDeallocBlock:^{
                [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
            }];
            objc_setAssociatedObject(self, &DKViewDeallocHelperKey, deallocHelper, OBJC_ASSOCIATION_ASSIGN);
        }
    }
    
    // 绑定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(night_updateColor) name:DKNightVersionThemeChangingNotification object:nil];
}

- (void)dk_removeColorChangeNoti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DKNightVersionThemeChangingNotification object:nil];
}

@end
