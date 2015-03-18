//
//  UITextField+DynamicFontSize.h
//  Created by kcandr on 16/12/14.

#ifndef christmas_UITextField_DynamicFontSize_h
#define christmas_UITextField_DynamicFontSize_h

#import <UIKit/UIKit.h>

@interface UITextField (DynamicFontSize)

- (void)adjustsFontSizeToFillRect:(CGRect)newBounds;
- (void)adjustsWidthToFillItsContents;

@end

#endif
