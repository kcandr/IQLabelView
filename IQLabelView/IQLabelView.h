//
//  IQLabelView.h
//  Created by kcandr on 17/12/14.

#import <UIKit/UIKit.h>

@protocol IQLabelViewDelegate;

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

@property (nonatomic) BOOL showContentShadow;     //Default is YES.
@property (nonatomic) BOOL enableClose;           //Default is YES. if set to NO, user can't delete the view
@property (nonatomic) BOOL enableRotate;          //Default is YES. if set to NO, user can't Rotate the view
@property (nonatomic) BOOL enableMoveRestriction; //Default is NO.

- (void)refresh;

- (void)hideEditingHandles;
- (void)showEditingHandles;

- (void)setTextField:(UITextField *)field;
- (void)setTextAlpha:(CGFloat)alpha;
- (CGFloat)textAlpha;

@end

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


