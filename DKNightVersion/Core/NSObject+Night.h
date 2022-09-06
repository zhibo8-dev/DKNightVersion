//
//  NSObject+Night.h
//  DKNightVersion
//
//  Created by Draveness on 15/11/7.
//  Copyright © 2015年 DeltaX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKNightVersionManager.h"


@protocol DKMutableDictProtocol <NSObject>

@optional
@property (readonly, copy) NSArray *allKeys;
- (void)enumerateKeysAndObjectsUsingBlock:(id)block;

@end

/// 给字典包装了一层 内部处理一些额外的逻辑
@interface DKMutableDict:NSObject <DKMutableDictProtocol>

/// 字典键值对有变化的时候 会触发这个回调， 之所以包了一层 主要就是为了监听键值对的变化
@property (nonatomic, copy) void(^didUpdateValue)(BOOL isEmpty);

@end



@interface NSObject (Night)


/// 返回日夜间模式控制单例
@property (nonatomic, strong, readonly) DKNightVersionManager *dk_manager;


/// 存储colorPickers 使用DKMutableDict包装一层的字典
@property (nonatomic, strong, readonly) DKMutableDict *pickers;


/// 如果设置为YES 日夜间模式不跟随父控件  默认NO
@property (nonatomic, assign) BOOL igonreSuperColorMode;

/// 设置支持的日夜间模式
/// 如果为nil 表示跟随dk_manager.themeVersion
/// 影响所有的子控件 如果igonreSuperColorMode=NO 当前的enableThemeVersion会跟随父控件
/// 想要不跟随父控件 赋值之前要先设置igonreSuperColorMode = YES
@property (nonatomic, strong) DKThemeVersion *enableThemeVersion;


/// 当触发日夜间切换的时候 要切换到什么模式
@property (nonatomic, strong, readonly) DKThemeVersion *targetThemeVersion;


/// 添加移除通知
- (void)dk_addColorChangeNoti;
- (void)dk_removeColorChangeNoti;


/// 颜色刷新 内部通过调用night_updateColor_business进行颜色更新
/// 同时处理一些提前return/状态标记的业务 不建议子类/分类重写
- (void)night_updateColor;


// 更新颜色具体要做的逻辑 如果子类分类要自己实现颜色替换 重写这个方法
- (void)night_updateColor_business;
 

// night_night_updateColor中调用night_updateColor_business之后执行这个方法，用于分类或子类补充一些逻辑
- (void)did_updateColor_business;


@end
