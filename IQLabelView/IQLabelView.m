//
//  IQLabelView.m
//  Created by kcandr on 17/12/14.

#import "IQLabelView.h"
#import <QuartzCore/QuartzCore.h>
#import "UITextField+DynamicFontSize.h"

CG_INLINE CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CG_INLINE CGRect CGRectScale(CGRect rect, CGFloat wScale, CGFloat hScale)
{
    return CGRectMake(rect.origin.x * wScale, rect.origin.y * hScale, rect.size.width * wScale, rect.size.height * hScale);
}

CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2)
{
    //Saving Variables.
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    
    return sqrt((fx*fx + fy*fy));
}

CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t)
{
    return atan2(t.b, t.a);
}


CG_INLINE CGSize CGAffineTransformGetScale(CGAffineTransform t)
{
    return CGSizeMake(sqrt(t.a * t.a + t.c * t.c), sqrt(t.b * t.b + t.d * t.d)) ;
}


static IQLabelView *lastTouchedView;

@implementation IQLabelView
{
    CGFloat _globalInset;

    CGRect initialBounds;
    CGFloat initialDistance;

    CGPoint beginningPoint;
    CGPoint beginningCenter;

    CGPoint prevPoint;
    CGPoint touchLocation;
    
    CGFloat deltaAngle;
    
    CGAffineTransform startTransform;
    CGRect beginBounds;
    
    CAShapeLayer *border;
}

@synthesize textView = _textView;
@synthesize fontName = _fontName, fontSize = _fontSize;
@synthesize enableClose = _enableClose;
@synthesize enableRotate = _enableRotate;
@synthesize delegate = _delegate;
@synthesize showContentShadow = _showContentShadow;
@synthesize closeImage = _closeImage, rotateImage = _rotateImage;

-(void)refresh
{
    if (self.superview) {
        CGSize scale = CGAffineTransformGetScale(self.superview.transform);
        CGAffineTransform t = CGAffineTransformMakeScale(scale.width, scale.height);
        [closeView setTransform:CGAffineTransformInvert(t)];
        [rotateView setTransform:CGAffineTransformInvert(t)];
        
        if (_isShowingEditingHandles) {
            [_textView.layer addSublayer:border];
        } else {
            [border removeFromSuperlayer];
        }
    }
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self refresh];
}

- (void)setFrame:(CGRect)newFrame
{
    [super setFrame:newFrame];
    [self refresh];
}

- (id)initWithFrame:(CGRect)frame
{
    /*(1+_globalInset*2)*/
    if (frame.size.width < (1+12*2))     frame.size.width = 25;
    if (frame.size.height < (1+12*2))   frame.size.height = 25;
 
    self = [super initWithFrame:frame];
    if (self) {
        _globalInset = 12;
        
        //        self = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
        self.backgroundColor = [UIColor clearColor];
        
        //Close button view which is in top left corner
        closeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _globalInset*2, _globalInset*2)];
        [closeView setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin)];
        closeView.backgroundColor = [UIColor whiteColor];
        closeView.layer.cornerRadius = _globalInset - 5;
        closeView.userInteractionEnabled = YES;
        [self addSubview:closeView];
        
         //Rotating view which is in bottom right corner
        rotateView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-_globalInset*2, self.bounds.size.height-_globalInset*2, _globalInset*2, _globalInset*2)];
        [rotateView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin)];
        rotateView.backgroundColor = [UIColor whiteColor];
        rotateView.layer.cornerRadius = _globalInset - 5;
        rotateView.contentMode = UIViewContentModeCenter;
        rotateView.userInteractionEnabled = YES;
        [self addSubview:rotateView];

        UIPanGestureRecognizer *moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
        [self addGestureRecognizer:moveGesture];
        
        UITapGestureRecognizer *singleTapShowHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)];
        [self addGestureRecognizer:singleTapShowHide];
        
        UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap:)];
        [closeView addGestureRecognizer:closeTap];
        
        UIPanGestureRecognizer *panRotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateViewPanGesture:)];
        [rotateView addGestureRecognizer:panRotateGesture];
        
        [moveGesture requireGestureRecognizerToFail:closeTap];
        
        [self setEnableClose:YES];
        [self setEnableRotate:YES];
        [self setShowContentShadow:YES];
        [self setCloseImage:[UIImage imageNamed:@"IQLabelView.bundle/sticker_close.png"]];
        [self setRotateImage:[UIImage imageNamed:@"IQLabelView.bundle/sticker_resize.png"]];
        
        [self hideEditingHandles];
     }
    return self;
}

- (void)layoutSubviews
{
    if (_textView) {
        border.path = [UIBezierPath bezierPathWithRect:_textView.bounds].CGPath;
        border.frame = _textView.bounds;
    }
}

#pragma mark - Set Control Buttons

- (void)setEnableClose:(BOOL)enableClose
{
    _enableClose = enableClose;
    [closeView setHidden:!_enableClose];
    [closeView setUserInteractionEnabled:_enableClose];
}

- (void)setEnableRotate:(BOOL)enableRotate
{
    _enableRotate = enableRotate;
    [rotateView setHidden:!_enableRotate];
    [rotateView setUserInteractionEnabled:_enableRotate];
}

- (void)setShowContentShadow:(BOOL)showContentShadow
{
    _showContentShadow = showContentShadow;
    
    if (_showContentShadow) {
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOffset:CGSizeMake(0, 5)];
        [self.layer setShadowOpacity:1.0];
        [self.layer setShadowRadius:4.0];
    } else {
        [self.layer setShadowColor:[UIColor clearColor].CGColor];
        [self.layer setShadowOffset:CGSizeZero];
        [self.layer setShadowOpacity:0.0];
        [self.layer setShadowRadius:0.0];
    }
}

- (void)setCloseImage:(UIImage *)closeImage
{
    _closeImage = closeImage;
    [closeView setImage:_closeImage];
}

- (void)setRotateImage:(UIImage *)rotateImage
{
    _rotateImage = rotateImage;
    [rotateView setImage:_rotateImage];
}

#pragma mark - Set Text Field

- (void)setTextView:(UITextField *)textView
{
    [_textView removeFromSuperview];
    
    _textView = textView;
    
    _textView.frame = CGRectInset(self.bounds, _globalInset, _globalInset);
    
    [_textView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.tintColor = [UIColor redColor];
    [_textView becomeFirstResponder];
    
    border = [CAShapeLayer layer];
    border.strokeColor = [UIColor redColor].CGColor;
    border.fillColor = nil;
    border.lineDashPattern = @[@4, @3];
    
    [self insertSubview:_textView atIndex:0];
}

- (void)setFontName:(NSString *)fontName
{
    _fontName = fontName;
    _textView.font = [UIFont fontWithName:_fontName size:_fontSize];
    [_textView adjustsWidthToFillItsContents];
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    _textView.font = [UIFont fontWithName:_fontName size:_fontSize];
}

#pragma mark - Bounds

- (void)hideEditingHandles
{
    lastTouchedView = nil;
    
    _isShowingEditingHandles = NO;
    
    if (_enableClose)       closeView.hidden = YES;
    if (_enableRotate)      rotateView.hidden = YES;
    
    [_textView resignFirstResponder];
    
    [self refresh];
    
    if([_delegate respondsToSelector:@selector(labelViewDidHideEditingHandles:)]) {
        [_delegate labelViewDidHideEditingHandles:self];
    }
}

- (void)showEditingHandles
{
    [lastTouchedView hideEditingHandles];
    
    _isShowingEditingHandles = YES;
    
    lastTouchedView = self;
    
    if (_enableClose)       closeView.hidden = NO;
    if (_enableRotate)      rotateView.hidden = NO;
    
    [self refresh];
    
    if([_delegate respondsToSelector:@selector(labelViewDidShowEditingHandles:)]) {
        [_delegate labelViewDidShowEditingHandles:self];
    }
}

#pragma mark - Gestures

- (void)contentTapped:(UITapGestureRecognizer*)tapGesture
{
    if (_isShowingEditingHandles) {
        [self hideEditingHandles];
        [self.superview bringSubviewToFront:self];
    } else {
        [self showEditingHandles];
    }
}

- (void)closeTap:(UITapGestureRecognizer *)recognizer
{
    [self removeFromSuperview];
    
    if([_delegate respondsToSelector:@selector(labelViewDidClose:)]) {
        [_delegate labelViewDidClose:self];
    }
}

-(void)moveGesture:(UIPanGestureRecognizer *)recognizer
{
    if (!_isShowingEditingHandles) {
        [self showEditingHandles];
    }
    touchLocation = [recognizer locationInView:self.superview];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        beginningPoint = touchLocation;
        beginningCenter = self.center;
 
        [self setCenter:CGPointMake(beginningCenter.x+(touchLocation.x-beginningPoint.x), beginningCenter.y+(touchLocation.y-beginningPoint.y))];

        beginBounds = self.bounds;
        
        if([_delegate respondsToSelector:@selector(labelViewDidBeginEditing:)]) {
            [_delegate labelViewDidBeginEditing:self];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self setCenter:CGPointMake(beginningCenter.x+(touchLocation.x-beginningPoint.x), beginningCenter.y+(touchLocation.y-beginningPoint.y))];
        
        if([_delegate respondsToSelector:@selector(labelViewDidChangeEditing:)]) {
            [_delegate labelViewDidChangeEditing:self];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self setCenter:CGPointMake(beginningCenter.x+(touchLocation.x-beginningPoint.x), beginningCenter.y+(touchLocation.y-beginningPoint.y))];
    
        if([_delegate respondsToSelector:@selector(labelViewDidEndEditing:)]) {
            [_delegate labelViewDidEndEditing:self];
        }
    }

    prevPoint = touchLocation;
}

- (void)rotateViewPanGesture:(UIPanGestureRecognizer *)recognizer
{
    touchLocation = [recognizer locationInView:self.superview];
    
    CGPoint center = CGRectGetCenter(self.frame);
    
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        deltaAngle = atan2(touchLocation.y-center.y, touchLocation.x-center.x)-CGAffineTransformGetAngle(self.transform);
        
        initialBounds = self.bounds;
        initialDistance = CGPointGetDistance(center, touchLocation);
       
        if([_delegate respondsToSelector:@selector(labelViewDidBeginEditing:)]) {
            [_delegate labelViewDidBeginEditing:self];
        }
    } else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        float ang = atan2(touchLocation.y-center.y, touchLocation.x-center.x);
        
        float angleDiff = deltaAngle - ang;
//        float angleDiff = -ang;
        [self setTransform:CGAffineTransformMakeRotation(-angleDiff)];
        [self setNeedsDisplay];
        
        //Finding scale between current touchPoint and previous touchPoint
        double scale = sqrtf(CGPointGetDistance(center, touchLocation)/initialDistance);
        
        CGRect scaleRect = CGRectScale(initialBounds, scale, scale);
 
        if (scaleRect.size.width >= (1+_globalInset*2 + 20) && scaleRect.size.height >= (1+_globalInset*2 + 20)) {
            if (_fontSize < 100 || CGRectGetWidth(scaleRect) < CGRectGetWidth(self.bounds)) {
                [_textView adjustsFontSizeToFillRect:scaleRect];
                [self setBounds:scaleRect];
            }
        }
        
        if([_delegate respondsToSelector:@selector(labelViewDidChangeEditing:)]) {
            [_delegate labelViewDidChangeEditing:self];
        }
    } else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        if([_delegate respondsToSelector:@selector(labelViewDidEndEditing:)]) {
            [_delegate labelViewDidEndEditing:self];
        }
    }
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([_delegate respondsToSelector:@selector(labelViewDidStartEditing:)]) {
        [_delegate labelViewDidStartEditing:self];
    }
    [self contentTapped:nil];
    [_textView adjustsWidthToFillItsContents];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!_isShowingEditingHandles) {
        [self showEditingHandles];
    }
    [_textView adjustsWidthToFillItsContents];
    return YES;
}

@end
