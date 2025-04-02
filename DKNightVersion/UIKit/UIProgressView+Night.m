//
//  UIProgressView+Night.m
//  UIProgressView+Night
//
//  Copyright (c) 2015 Draveness. All rights reserved.
//
//  These files are generated by ruby script, if you want to modify code
//  in this file, you are supposed to update the ruby code, run it and
//  test it. And finally open a pull request.

#import "UIProgressView+Night.h"
#import "DKNightVersionManager.h"
#import <objc/runtime.h>

@interface UIProgressView ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, DKColorPicker> *pickers;

@end

@implementation UIProgressView (Night)


- (DKColorPicker)dk_progressTintColorPicker {
    return objc_getAssociatedObject(self, @selector(dk_progressTintColorPicker));
}

- (void)dk_setProgressTintColorPicker:(DKColorPicker)picker {
    objc_setAssociatedObject(self, @selector(dk_progressTintColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (picker) {
        self.progressTintColor = picker(self.dk_manager.themeVersion);
    } else {
        self.progressTintColor = nil;
    }
    [self.pickers setValue:[picker copy] forKey:@"setProgressTintColor:"];
}

- (DKColorPicker)dk_trackTintColorPicker {
    return objc_getAssociatedObject(self, @selector(dk_trackTintColorPicker));
}

- (void)dk_setTrackTintColorPicker:(DKColorPicker)picker {
    objc_setAssociatedObject(self, @selector(dk_trackTintColorPicker), picker, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (picker) {
        self.trackTintColor = picker(self.dk_manager.themeVersion);
    } else {
        self.trackTintColor = nil;
    }
    [self.pickers setValue:[picker copy] forKey:@"setTrackTintColor:"];
}


@end
