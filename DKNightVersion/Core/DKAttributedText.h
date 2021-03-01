//
//  DKAttributedText.h
//  DKNightVersion
//
//  Created by 赵旺 on 2021/2/18.
//

#import <Foundation/Foundation.h>

typedef NSString DKThemeVersion;

typedef NSAttributedString *(^DKAttributedTextPicker)(DKThemeVersion *themeVersion);


NS_ASSUME_NONNULL_BEGIN

@interface DKAttributedText : NSObject

@end

NS_ASSUME_NONNULL_END
