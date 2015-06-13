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
{
    UITextField *textView;
    UIImageView *rotateView;
    UIImageView *closeView;

    BOOL isShowingEditingHandles;
}

@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) UIColor *borderColor;

@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, strong) UIImage *closeImage;
@property (nonatomic, strong) UIImage *rotateImage;

@property (nonatomic, assign) id <IQLabelViewDelegate> delegate;

@property (nonatomic) BOOL showContentShadow;    //Default is YES.
@property (nonatomic) BOOL enableClose;          //Default is YES. if set to NO, user can't delete the view
@property (nonatomic) BOOL enableRotate;         //Default is YES. if set to NO, user can't rotate the view

- (void)refresh;

- (void)hideEditingHandles;
- (void)showEditingHandles;

- (void)setTextField:(UITextField *)field;
- (void)setTextAlpha:(CGFloat)alpha;
- (CGFloat)textAlpha;

@end
```

### IQLabelViewDelegate Protocol

```objective-c
@protocol IQLabelViewDelegate <NSObject>

@optional

- (void)labelViewDidClose:(IQLabelView *)label;
- (void)labelViewDidShowEditingHandles:(IQLabelView *)label;
- (void)labelViewDidHideEditingHandles:(IQLabelView *)label;
- (void)labelViewDidStartEditing:(IQLabelView *)label;
- (void)labelViewDidBeginEditing:(IQLabelView *)label;
- (void)labelViewDidChangeEditing:(IQLabelView *)label;
- (void)labelViewDidEndEditing:(IQLabelView *)label;

@end
```

### Example

```objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	CGRect labelFrame = CGRectMake(100, 100, 60, 50);
    UITextField *aLabel = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [aLabel setClipsToBounds:YES];
    [aLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    [aLabel setText:@"Label"];
    [aLabel setTextColor:[UIColor whiteColor]];
    [aLabel sizeToFit];
    
    IQLabelView *labelView = [[IQLabelView alloc] initWithFrame:labelFrame];
    labelView.delegate = self;
    [labelView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    [labelView setShowContentShadow:NO];
    [labelView setTextField:aLabel];
    [labelView setFontName:@"Baskerville-BoldItalic"];
    [labelView setFontSize:21.0];
    [labelView sizeToFit];
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
