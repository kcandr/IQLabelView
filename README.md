# IQLabelView

IQLabelView is used to add text overlay and resize and rotate it with single finger.

![IQLabelView screenshot](https://cloud.githubusercontent.com/assets/1710081/6282634/3fc18b22-b8e9-11e4-894f-6ed06e1c322c.png) ![IQLabelView screenshot](https://cloud.githubusercontent.com/assets/1710081/6490467/94a84ffe-c2b7-11e4-8cf4-05c011e26289.png)

## How to install it?

[CocoaPods](http://cocoapods.org) is the easiest way to install IQLabelView. Run ```pod search IQLabelView``` to search for the latest version. Then, copy and paste the ```pod``` line to your ```Podfile```. Your podfile should look like:

```
platform :ios, '7.0'
pod 'IQLabelView', '~> X.Y.Z'
```

Finally, install it by running ```pod install```.

If you don't use CocoaPods, just import IQLabelView/ folder with all the .m, .h, and .bundle files to your project.

## How to use it?

### IQLabelView Class

```objective-c

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
```

### IQLabelViewDelegate Protocol

```objective-c
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
```

### Example

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	CGRect labelFrame = CGRectMake(100, 100, 60, 50);
    
    IQLabelView *labelView = [[IQLabelView alloc] initWithFrame:labelFrame];
    [labelView setDelegate:self];
    [labelView setShowsContentShadow:NO];
    [labelView setFontName:@"Baskerville-BoldItalic"];
    [labelView setFontSize:21.0];
    [labelView setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Placeholder", nil) attributes:@{ NSForegroundColorAttributeName : [UIColor redColor] }]];
    
    [self.view addSubview:labelView];
}
```

## Reference

Inspired by 

- [IQStickerView](https://github.com/hackiftekhar/IQStickerView)
- [ZDStickerView](https://github.com/zedoul/ZDStickerView)
- [SPUserResizableView](https://github.com/spoletto/SPUserResizableView)

## License 

The MIT License (MIT)
Copyright (c) 2014 Alexander Romanchev
