# DKNightVersion
DKNightVersion is a light weight framework. It's mainly built through `objc/runtime` library and reflection, providing a neat approach  adding night mode to your iOS app. A great many codes of this framework is automatically generated by Ruby script.

The most delightful feature of DKNightVersion is that it appends one more property `nightColor` to frequently-used UIKit components and provides you a default night mode theme. It is easily-used and well-designed. Hope you have a great joy to use DKNightVersion to integrate night mode in your Apps.

[![Build Status](https://travis-ci.org/Draveness/DKNightVersion.png)](https://travis-ci.org/Draveness/DKNightVersion)

# Demo

![](./DKNightVersion.gif)

# Installation with CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like DKNightVersion in your projects. See the [Get Started section](https://cocoapods.org/#get_started) for more details.

## Podfile

```
pod "DKNightVersion", "~> 0.5.0"
```

## Usage

Just add one line of code in your precompiled header, or import it where you need.

```
#import "DKNightVersion.h"
```

----

# How to use

## Using night color

DKNightVersion is based on property `nightColor`, such as `nightBackgroundColor` `nightTextColor` and etc.

Assign the night mode color you want to the `UIKit` component like this:

```
self.view.nightBackgroundColor = [UIColor blackColor];
self.label.nightTextColor = [UIColor whiteColor];
```

## Using DKNightVersionManager change theme

Use `DKNightVersionManager` sets the theme.

```
[DKNightVersionManager nightFalling];
```

If you'd like to switch back to normal mode:

```
[DKNightVersionManager dawnComing];
```

It's pretty easy to swich theme between night and normal mode.

## Using default night version

If you set `useDefaultNightColor` property for singleton manager to `YES`, which is the default value. DKNightVersion will provide you a default night mode. 

And you can also customize the color through assign color value to `nightColor` property. And we will first pick color you specified instead of default behavior.

Optionally, turn off the default night mode and set it on your own is also supported.

```
[DKNightVersionManager setUseDefaultNightColor:NO];
```

## Picking Color

DKNightVersionManager will pick the proper color following these two rules.

1. `useDefaultNightColor == YES` (The default behavior)

		nightColor > defaultNightColor > normalColor

2. `useDefaultNightColor == NO`

		nightColor > normalColor

# Contribute

if there is a bug, you can either fix it and open a pull request or open a issue.

If you want some new features, read the documentation and fork this repo.

# Contact

- Powered by [Draveness](http://github.com/draveness)
- Personal website [DeltaX](http://deltax.me)

# License

DKNightVersion is available under the MIT license. See the LICENSE file for more info.

# Todo

- Add more color support
- Test
- Documentation
