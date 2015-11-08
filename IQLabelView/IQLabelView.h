//
//  IQLabelView.h
//  Created by kcandr on 17/12/14.

#import <UIKit/UIKit.h>

@protocol IQLabelViewDelegate;

@interface IQLabelView : UIView 

/**
 * Text color.
 *
 * Default: white color.
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 * Border stroke color.
 *
 * Default: red color.
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 * Name of text field font.
 * 
 * Default: current system font
 */
@property (nonatomic, copy) NSString *fontName;

/**
 * Size of text field font.
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 * Image for close button.
 *
 * Default: sticker_close.png from IQLabelView.bundle.
 */
@property (nonatomic, strong) UIImage *closeImage;

/**
 * Image for rotation button.
 *
 * Default: sticker_resize.png from IQLabelView.bundle.
 */
@property (nonatomic, strong) UIImage *rotateImage;

/**
 * Placeholder.
 *
 * Default: nil
 */
@property (nonatomic, copy) NSAttributedString *attributedPlaceholder;

/*
 * Base delegate protocols.
 */
@property (nonatomic, weak) id <IQLabelViewDelegate> delegate;

/**
 *  Shows content shadow.
 *
 *  Default: YES.
 */
@property (nonatomic) BOOL showsContentShadow;

/**
 *  Shows close button.
 *
 *  Default: YES.
 */
@property (nonatomic, getter=isEnableClose) BOOL enableClose;

/**
 *  Shows rotate/resize butoon.
 *
 *  Default: YES.
 */
@property (nonatomic, getter=isEnableRotate) BOOL enableRotate;

/**
 *  Resticts movements in superview bounds.
 *
 *  Default: NO.
 */
@property (nonatomic, getter=isEnableMoveRestriction) BOOL enableMoveRestriction;

/**
 *  Hides border and control buttons.
 */
- (void)hideEditingHandles;

/**
 *  Shows border and control buttons.
 */
- (void)showEditingHandles;

/** Sets the text alpha.
 *
 * @param alpha     A value of text transparency.
 */
- (void)setTextAlpha:(CGFloat)alpha;

/** Returns text alpha.
 *
 * @return  A value of text transparency.
 */
- (CGFloat)textAlpha;

@end

@protocol IQLabelViewDelegate <NSObject>

@optional

/**
 *  Occurs when a touch gesture event occurs on close button.
 *
 *  @param label    A label object informing the delegate about action.
 */
- (void)labelViewDidClose:(IQLabelView *)label;

/**
 *  Occurs when border and control buttons was shown.
 *
 *  @param label    A label object informing the delegate about showing.
 */
- (void)labelViewDidShowEditingHandles:(IQLabelView *)label;

/**
 *  Occurs when border and control buttons was hidden.
 *
 *  @param label    A label object informing the delegate about hiding.
 */
- (void)labelViewDidHideEditingHandles:(IQLabelView *)label;

/**
 *  Occurs when label become first responder.
 *
 *  @param label    A label object informing the delegate about action.
 */
- (void)labelViewDidStartEditing:(IQLabelView *)label;

/**
 *  Occurs when label starts move or rotate.
 *
 *  @param label    A label object informing the delegate about action.
 */
- (void)labelViewDidBeginEditing:(IQLabelView *)label;

/**
 *  Occurs when label continues move or rotate.
 *
 *  @param label    A label object informing the delegate about action.
 */
- (void)labelViewDidChangeEditing:(IQLabelView *)label;

/**
 *  Occurs when label ends move or rotate.
 *
 *  @param label    A label object informing the delegate about action.
 */
- (void)labelViewDidEndEditing:(IQLabelView *)label;

@end


