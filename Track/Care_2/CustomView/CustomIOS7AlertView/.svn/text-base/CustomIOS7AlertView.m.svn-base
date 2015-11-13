//
//  CustomIOS7AlertView.m
//  CustomIOS7AlertView
//
//  Created by Richard on 20/09/2013.
//  Copyright (c) 2013 Wimagguc.
//
//  Lincesed under The MIT License (MIT)
//  http://opensource.org/licenses/MIT
//

#import "CustomIOS7AlertView.h"
#import <QuartzCore/QuartzCore.h>

const static CGFloat kCustomIOS7AlertViewDefaultButtonHeight       = 50;
const static CGFloat kCustomIOS7AlertViewDefaultButtonSpacerHeight = 0;
const static CGFloat kCustomIOS7AlertViewCornerRadius              = 0;
const static CGFloat kCustomIOS7MotionEffectExtent                 = 10.0;


@implementation CustomIOS7AlertView

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;

@synthesize parentView, containerView, dialogView, buttonView, onButtonTouchUpInside;
@synthesize delegate;
@synthesize buttonTitles;
@synthesize useMotionEffects;

- (id)initWithParentView: (UIView *)_parentView
{
    self = [self init];
    if (_parentView) {
        self.frame = _parentView.frame;
        self.parentView = _parentView;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

        delegate = self;
        useMotionEffects = false;
//        buttonTitles = @[@"Close"];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

// Create the dialog view, and animate opening the dialog
- (void)show
{
    dialogView = [self createContainerView];
  
    dialogView.layer.shouldRasterize = YES;
    dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
  
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

#if (defined(__IPHONE_7_0))
    if (useMotionEffects) {
        [self applyMotionEffects];
    }
#endif

    dialogView.layer.opacity = 0.5f;
    dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);

    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    [self addSubview:dialogView];

    // Can be attached to a view or to the top most window
    // Attached to a view:
    if (parentView != NULL) {
        [parentView addSubview:self];

    // Attached to the top most window (make sure we are using the right orientation):
    } else {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;

            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;

            default:
                break;
        }

        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    }

    dialogView.alpha = 0;
    [UIView animateWithDuration:0.23 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
                         dialogView.alpha = 1;
                         dialogView.layer.opacity = 1.0f;
                         dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
					 }
					 completion:NULL
     ];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackground:)];
    [self addGestureRecognizer:tap];
}
-(void)clickBackground:(UITapGestureRecognizer *)tap {
    CGPoint p = [tap locationInView:dialogView];
    
    CGFloat x = dialogView.bounds.origin.x;
    CGFloat y = dialogView.bounds.origin.y;
    CGFloat w = dialogView.bounds.size.width;
    CGFloat h = dialogView.bounds.size.height;
    if (!(p.x>x && p.x<x+w && p.y>y && p.y<y+h)) {
        [self close];
    }
}

// Button has been touched
- (IBAction)customIOS7dialogButtonTouchUpInside:(id)sender
{
    if (delegate != NULL) {
        [delegate customIOS7dialogButtonTouchUpInside:self clickedButtonAtIndex:[sender tag]];
    }

    if (onButtonTouchUpInside != NULL) {
        onButtonTouchUpInside(self, [sender tag]);
    }
}

// Default button behaviour
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"Button Clicked! %d, %d", buttonIndex, [alertView tag]);
    [self close];
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close
{
    CATransform3D currentTransform = dialogView.layer.transform;

    CGFloat startRotation = [[dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);

    dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    dialogView.layer.opacity = 1.0f;

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         dialogView.layer.opacity = 0.0f;
					 }
					 completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
					 }
	 ];
    
    for (UIGestureRecognizer *g in self.gestureRecognizers) {
        [self removeGestureRecognizer:g];
    }
}

- (void)setSubView: (UIView *)subView
{
    containerView = subView;
}

// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createContainerView
{
    if (containerView == NULL) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    }

    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];

    // For the black background
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];

    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];

    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       nil];

    CGFloat cornerRadius = kCustomIOS7AlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];

    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;

    // Add the custom container if there is any
    [dialogContainer addSubview:containerView];
    
    // Add the buttons too
    [self addButtonsToView:dialogContainer];
    
    return dialogContainer;
}

// Helper function: add buttons to container
- (void)addButtonsToView: (UIView *)container
{
    if (buttonTitles==NULL) { return; }

    CGFloat buttonWidth = container.bounds.size.width / [buttonTitles count];

    for (int i=0; i<[buttonTitles count]; i++) {
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [closeButton setFrame:CGRectMake(i * buttonWidth, 10, buttonWidth, buttonHeight)];

        [closeButton addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];

        [closeButton setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];

        [container addSubview:closeButton];
    }
}

// Helper function: count and return the dialog's size
- (CGSize)countDialogSize
{
    CGFloat dialogWidth = containerView.frame.size.width;
    CGFloat dialogHeight = containerView.frame.size.height-2;

    return CGSizeMake(dialogWidth, dialogHeight);
}

// Helper function: count and return the screen's size
- (CGSize)countScreenSize
{
    if (buttonTitles!=NULL && [buttonTitles count] > 0) {
        buttonHeight       = kCustomIOS7AlertViewDefaultButtonHeight;
        buttonSpacerHeight = kCustomIOS7AlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }

    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = screenWidth;
        screenWidth = screenHeight;
        screenHeight = tmp;
    }

    return CGSizeMake(screenWidth, screenHeight);
}

#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }

    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);

    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kCustomIOS7MotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kCustomIOS7MotionEffectExtent);

    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];

    [dialogView addMotionEffect:motionEffectGroup];
}
#endif

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    // If dialog is attached to the parent view, it probably wants to handle the orientation change itself
    if (parentView != NULL) {
        return;
    }

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;

    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;

        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;

        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;

        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.transform = rotation;
					 }
					 completion:^(BOOL finished){
                         // fix errors caused by being rotated one too many times
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             UIInterfaceOrientation endInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
                             if (interfaceOrientation != endInterfaceOrientation) {
                                 // TODO user moved phone again before than animation ended: rotation animation can introduce errors here
                             }
                         });
                     }
	 ];

}

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
    
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];

    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
					 animations:^{
                         dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
					 }
					 completion:nil
	 ];
    
}


//*******************
-(id)initStyleZeroWithTitle:(NSString *)title message:(NSString *)message {
    self = [self init];
    if (self) {
        CGFloat strH = [message boundingRectWithSize:CGSizeMake(210, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.height;
        BOOL isLongStr = (strH>40 ? YES:NO);
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 420*0.55, 247*0.55+isLongStr*strH/2)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width, containerView.bounds.size.height)];
        [imageView setImage:[[UIImage imageNamed:@"02_alert_background"] stretchableImageWithLeftCapWidth:10 topCapHeight:40]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, containerView.bounds.size.width-30, 20)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.text = title;
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat closeBtnWidth = 39;
        closeBtn.frame = CGRectMake(containerView.bounds.size.width-closeBtnWidth, 0, closeBtnWidth, closeBtnWidth);
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"02_alert_btn_close"] forState:UIControlStateNormal];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"02_alert_btn_close_selected"] forState:UIControlStateHighlighted];
        [closeBtn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width-20, (isLongStr ? strH:40))];
        messageLabel.center = CGPointMake(containerView.bounds.size.width/2, (isLongStr ? strH+25:65));
        messageLabel.textColor = _Color_font2;
        messageLabel.font = [UIFont boldSystemFontOfSize:14];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.numberOfLines = 0;
        messageLabel.text = message;
        
        UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        contentBtn.frame = CGRectMake(20, 90+isLongStr*strH/2, containerView.bounds.size.width-40, 35);
        [contentBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        contentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [contentBtn setBackgroundImage:[UIImage imageNamed:@"02_alert_longBtn"] forState:UIControlStateNormal];
        [contentBtn setBackgroundImage:[UIImage imageNamed:@"02_alert_longBtn_selected"] forState:UIControlStateHighlighted];
        [contentBtn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [containerView addSubview:imageView];
        [containerView addSubview:titleLabel];
        [containerView addSubview:closeBtn];
        [containerView addSubview:messageLabel];
        [containerView addSubview:contentBtn];
    }
    return self;
}

-(id)initStyleOneWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle {
    self = [self init];
    if (self) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 420*0.55, 247*0.55)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width, containerView.bounds.size.height)];
        [imageView setImage:[UIImage imageNamed:@"02_alert_background"]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, containerView.bounds.size.width-30, 20)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.text = title;
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat closeBtnWidth = 39;
        closeBtn.frame = CGRectMake(containerView.bounds.size.width-closeBtnWidth, 0, closeBtnWidth, closeBtnWidth);
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"02_alert_btn_close"] forState:UIControlStateNormal];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"02_alert_btn_close_selected"] forState:UIControlStateHighlighted];
        [closeBtn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        contentBtn.frame = CGRectMake(20, 63, containerView.bounds.size.width-40, 40);
        [contentBtn setTitle:buttonTitle forState:UIControlStateNormal];
        contentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [contentBtn setBackgroundImage:[UIImage imageNamed:@"02_alert_longBtn"] forState:UIControlStateNormal];
        [contentBtn setBackgroundImage:[UIImage imageNamed:@"02_alert_longBtn_selected"] forState:UIControlStateHighlighted];
        [contentBtn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [contentBtn setTag:0];
        
        [containerView addSubview:imageView];
        [containerView addSubview:titleLabel];
        [containerView addSubview:closeBtn];
        [containerView addSubview:contentBtn];
    }
    return self;
}

-(id)initStyleTwoWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle {
    self = [self init];
    if (self) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 120)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width, containerView.bounds.size.height)];
        [imageView setImage:[UIImage imageNamed:@"03_alert_background"]];
        [containerView addSubview:imageView];
        
        for (int i=0; i<2; i++) {
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width-20, 40)];
            lb.center = CGPointMake(containerView.bounds.size.width/2, 22+i*28);
            lb.textAlignment = NSTextAlignmentCenter;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat btnHeight = 40;
            btn.frame = CGRectMake(i*(containerView.bounds.size.width-3*btnHeight), containerView.bounds.size.height-btnHeight, 3*btnHeight, btnHeight);
            
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [btn setBackgroundImage:[UIImage imageNamed:@"03_alert_btn"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"03_alert_btn_selected"] forState:UIControlStateHighlighted];
            [btn setTag:i];
            
            if (i==0) {
                lb.text = title;
                lb.textColor = [UIColor colorWithRed:250/255.0 green:155/255.0 blue:78/255.0 alpha:1];
                lb.font = [UIFont boldSystemFontOfSize:14];
                
                [btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                lb.numberOfLines = 0;
                lb.text = message;
                lb.textColor = _Color_font2;
                lb.font = [UIFont boldSystemFontOfSize:13];
                
                [btn setTitle:otherButtonTitle forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [containerView addSubview:lb];
            [containerView addSubview:btn];
        }
    }
    return self;
}

-(id)initStyleThreeWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle {
    self = [self init];
    if (self) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 147)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width, containerView.bounds.size.height)];
        [imageView setImage:[[UIImage imageNamed:@"02_alert_background"] stretchableImageWithLeftCapWidth:100 topCapHeight:100]];
        [containerView addSubview:imageView];
        
        for (int i=0; i<2; i++) {
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width-20, 40)];
            lb.center = CGPointMake(containerView.bounds.size.width/2, 20+i*50);
            lb.textAlignment = NSTextAlignmentCenter;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat btnHeight = 40;
            btn.frame = CGRectMake(11.5+117*i, containerView.bounds.size.height-btnHeight-7, 2.75*btnHeight, btnHeight-5);

            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [btn setBackgroundImage:[UIImage imageNamed:@"02_alert_longBtn"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"02_alert_longBtn_selected"] forState:UIControlStateHighlighted];
            [btn setTag:i];
            
            if (i==0) {
                lb.text = title;
                lb.textColor = [UIColor whiteColor];
                lb.font = [UIFont boldSystemFontOfSize:15];
                
                [btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                lb.numberOfLines = 0;
                lb.text = message;
                lb.textColor = _Color_font2;
                lb.font = [UIFont boldSystemFontOfSize:14];
                
                [btn setTitle:otherButtonTitle forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [containerView addSubview:lb];
            [containerView addSubview:btn];
        }
    }
    return self;
}

-(id)initStyleTextFieldWithTitle:(NSString *)title message:(NSString *)message text:(NSString *)text cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle {
    self = [self init];
    if (self) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 180)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:containerView.bounds];
        [imageView setImage:[[UIImage imageNamed:@"02_alert_background"] stretchableImageWithLeftCapWidth:0 topCapHeight:50]];
        [containerView addSubview:imageView];
        
        for (int i=0; i<2; i++) {
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.bounds.size.width-20, 40)];
            lb.center = CGPointMake(containerView.bounds.size.width/2, 20+i*50);
            lb.textAlignment = NSTextAlignmentCenter;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat btnHeight = 40;
            btn.frame = CGRectMake(11.5+117*i, containerView.bounds.size.height-btnHeight-7, 2.75*btnHeight, btnHeight-5);
            
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [btn setBackgroundImage:[UIImage imageNamed:@"02_alert_longBtn"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"02_alert_longBtn_selected"] forState:UIControlStateHighlighted];
            [btn setTag:i];
            
            if (i==0) {
                lb.text = title;
                lb.textColor = [UIColor whiteColor];
                lb.font = [UIFont boldSystemFontOfSize:15];
                
                [btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                lb.numberOfLines = 0;
                lb.frame = CGRectMake(20, 60, containerView.bounds.size.width-20*2, 21);
                lb.textAlignment = NSTextAlignmentLeft;
                lb.text = message;
                lb.textColor = _Color_font2;
                lb.font = [UIFont boldSystemFontOfSize:14];
                
                [btn setTitle:otherButtonTitle forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(customIOS7dialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            }
            [containerView addSubview:lb];
            [containerView addSubview:btn];
        }
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, containerView.bounds.size.width-20*2, 21)];
        tf.delegate = self;
        tf.text = text;
        tf.tag = 100;
        [containerView addSubview:tf];
        
        UIView *tfLine = [[UIView alloc] initWithFrame:CGRectMake(tf.frame.origin.x, tf.frame.origin.y+tf.bounds.size.height, tf.bounds.size.width, 1)];
        tfLine.backgroundColor = [UIColor grayColor];
        [containerView addSubview:tfLine];
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length) {
        return YES;
    }
    if (([textField.text length] + [string length] - range.length) > 15) {
        return NO;
    }
    return YES;
}

@end
