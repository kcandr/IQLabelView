//
//  UITextField+DynamicFontSize.h
//  Created by kcandr on 16/12/14.

#ifndef IQLabelView_UITextField_DynamicFontSize_h
#define IQLabelView_UITextField_DynamicFontSize_h

#import <UIKit/UIKit.h>

@interface UITextField (DynamicFontSize)

/** Adjust font size to new bounds.
 *
 * @param newBounds A new bounds.
 */
- (void)adjustsFontSizeToFillRect:(CGRect)newBounds;

/** Adjust width to new text.
 *
 */
- (void)adjustsWidthToFillItsContents;

@end

#endif
