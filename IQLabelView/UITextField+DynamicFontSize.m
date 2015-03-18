//
//  UITextField+DynamicFontSize.m
//  Created by kcandr on 16/12/14.

#import <Foundation/Foundation.h>
#import "UITextField+DynamicFontSize.h"
#import "IQLabelView.h"

@implementation UITextField (DynamicFontSize)

#define CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE 101
#define CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE 9

- (void)adjustsFontSizeToFillRect:(CGRect)newBounds
{
    NSString *text = (![self.text isEqualToString:@""] || !self.placeholder) ? self.text : self.placeholder;
    
    for (int i = CATEGORY_DYNAMIC_FONT_SIZE_MAXIMUM_VALUE; i > CATEGORY_DYNAMIC_FONT_SIZE_MINIMUM_VALUE; i--) {
        UIFont *font = [UIFont fontWithName:self.font.fontName size:(CGFloat)i];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                             attributes:@{ NSFontAttributeName : font }];
        
        CGRect rectSize = [attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(newBounds)-24, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
        
        if (CGRectGetHeight(rectSize) <= CGRectGetHeight(newBounds)) {
            ((IQLabelView *)self.superview).fontSize = (CGFloat)i-1;
            break;
        }
    }
}

- (void)adjustsWidthToFillItsContents
{
    NSString *text = (![self.text isEqualToString:@""] || !self.placeholder) ? self.text : self.placeholder;
    UIFont *font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:@{ NSFontAttributeName : font }];
    
    CGRect rectSize = [attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.frame)-24)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
    
    float w1 = (ceilf(rectSize.size.width) + 24 < 50) ? self.frame.size.width : ceilf(rectSize.size.width) + 24;
    float h1 =(ceilf(rectSize.size.height) + 24 < 50) ? 50 : ceilf(rectSize.size.height) + 24;
    
    CGRect viewFrame = self.superview.bounds;
    viewFrame.size.width = w1 + 24;
    viewFrame.size.height = h1;
    self.superview.bounds = viewFrame;
}

@end