//
//  ViewController.m
//  IQLabelViewDemo
//
//  Created by kcandr on 20.12.14.

#import "ViewController.h"
#import "IQLabelView.h"

@interface ViewController () <IQLabelViewDelegate>
{
    IQLabelView *currentlyEditingLabel;
    NSMutableArray *labels;
}

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSArray *colors;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colors = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor redColor], [UIColor blueColor], nil];
    
    UIBarButtonItem *addLabelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self action:@selector(addLabel)];

    UIBarButtonItem *refreshColorButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                        target:self action:@selector(changeColor)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self action:@selector(saveImage)];
    self.navigationItem.leftBarButtonItem = addLabelButton;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveButton, refreshColorButton, nil];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:88/255.0 green:173/255.0 blue:227/255.0 alpha:1.0]];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutside:)]];
    [self.imageView setImage:[UIImage imageNamed:@"image"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLabel
{
    [currentlyEditingLabel hideEditingHandles];
    CGRect labelFrame = CGRectMake(CGRectGetMidX(self.imageView.frame) - arc4random() % 150,
                                   CGRectGetMidY(self.imageView.frame) - arc4random() % 200,
                                   60, 50);
    UITextField *aLabel = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [aLabel setClipsToBounds:YES];
    [aLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
    [aLabel setText:@""];
    if (arc4random() % 2 == 0) {
        [aLabel setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Placeholder", nil)
                                                                         attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.75] }]];
    }
    [aLabel setTextColor:[UIColor whiteColor]];
    [aLabel sizeToFit];
    
    IQLabelView *labelView = [[IQLabelView alloc] initWithFrame:labelFrame];
    [labelView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    labelView.delegate = self;
    [labelView setShowContentShadow:NO];
    [labelView setTextField:aLabel];
    [labelView setFontName:@"Baskerville-BoldItalic"];
    [labelView setFontSize:21.0];
    [labelView sizeToFit];
    [self.view addSubview:labelView];
    
    currentlyEditingLabel = labelView;
    [labels addObject:labelView];
}

- (void)saveImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        UIImageWriteToSavedPhotosAlbum([self visibleImage], nil, nil, nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Saved to Photo Roll");
        });
    });
}

- (void)changeColor
{
    [currentlyEditingLabel setTextColor:[self.colors objectAtIndex:arc4random() % 3]];
}

- (UIImage *)visibleImage
{
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, YES, self.imageView.image.scale);
    NSLog(@"%f", self.imageView.frame.origin.y);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), CGRectGetMinX(self.imageView.frame), -CGRectGetMinY(self.imageView.frame));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *visibleViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return visibleViewImage;
}

#pragma mark - Gesture 

- (void)touchOutside:(UITapGestureRecognizer *)touchGesture
{
    [currentlyEditingLabel hideEditingHandles];
}

#pragma mark - IQLabelDelegate

- (void)labelViewDidClose:(IQLabelView *)label
{
    // some actions after delete label
    [labels removeObject:label];
}

- (void)labelViewDidBeginEditing:(IQLabelView *)label
{
    // move or rotate begin
}

- (void)labelViewDidShowEditingHandles:(IQLabelView *)label
{
    // showing border and control buttons
    currentlyEditingLabel = label;
}

- (void)labelViewDidHideEditingHandles:(IQLabelView *)label
{
    // hiding border and control buttons
    currentlyEditingLabel = nil;
}

- (void)labelViewDidStartEditing:(IQLabelView *)label
{
    // tap in text field and keyboard showing
    currentlyEditingLabel = label;
}

@end
