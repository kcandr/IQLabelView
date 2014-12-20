//
//  IQLabelView.h
//  Created by kcandr on 17/12/14.

#import <UIKit/UIKit.h>

@protocol IQLabelViewDelegate;

@interface IQLabelView : UIView<UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    UIImageView *rotateView;
    UIImageView *closeView;

    BOOL _isShowingEditingHandles;
}

@property (assign, nonatomic) UITextField *textView;
@property (assign, nonatomic) NSString *fontName;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) UIImage *closeImage;
@property (assign, nonatomic) UIImage *rotateImage;

@property (unsafe_unretained) id <IQLabelViewDelegate> delegate;

@property(nonatomic, assign) BOOL showContentShadow;    //Default is YES.
@property(nonatomic, assign) BOOL enableClose;  // default is YES. if set to NO, user can't delete the view
@property(nonatomic, assign) BOOL enableRotate;  // default is YES. if set to NO, user can't Rotate the view

//Give call's to refresh. If SuperView is UIScrollView. And it changes it's zoom scale.
- (void)refresh;

- (void)hideEditingHandles;
- (void)showEditingHandles;

@end

@protocol IQLabelViewDelegate <NSObject>
@optional
- (void)labelViewDidBeginEditing:(IQLabelView *)label;
- (void)labelViewDidChangeEditing:(IQLabelView *)label;
- (void)labelViewDidEndEditing:(IQLabelView *)label;

- (void)labelViewDidClose:(IQLabelView *)label;

- (void)labelViewDidShowEditingHandles:(IQLabelView *)label;
- (void)labelViewDidHideEditingHandles:(IQLabelView *)label;
- (void)labelViewDidStartEditing:(IQLabelView *)label;
@end


