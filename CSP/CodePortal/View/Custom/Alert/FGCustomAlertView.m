//
//  FGCustomAlertView.m
//  Pureit
//
//  Created by Ryan Gong on 16/3/25.
//  Copyright © 2016年 Ryan Gong. All rights reserved.
//

#import "FGCustomAlertView.h"
#import "Global.h"
CGFloat paddingTB = 20;
CGFloat paddingLR = 50;
static CGFloat kTransitionDuration = 0.3;
@interface FGCustomAlertView()
{
    NSMutableArray *arr_buttons;
    NSArray *arr_buttonTexts;
}
@property (strong, nonatomic) void (^callBackBlock)(FGCustomAlertView *alertView, NSInteger buttonIndex);
@end

@implementation FGCustomAlertView
@synthesize int_dismissButtonIndex;
@synthesize lb_message;
@synthesize lb_title;
@synthesize view_alertBox;
@synthesize cb1;
@synthesize cb2;
@synthesize cb3;
@synthesize view_bg;
-(void)awakeFromNib
{
    [super awakeFromNib];
    lb_title.font = font(FONT_TEXT_BOLD, 16);
    lb_message.font = font(FONT_TEXT_REGULAR, 16);
    lb_title.textColor = [UIColor blackColor];
    lb_message.textColor = [UIColor blackColor];
    lb_title.textAlignment = NSTextAlignmentCenter;
    lb_message.textAlignment = NSTextAlignmentCenter;
    
  
    [commond useDefaultRatioToScaleView:view_alertBox];
    [commond useDefaultRatioToScaleView:cb1];
    [commond useDefaultRatioToScaleView:cb2];
    [commond useDefaultRatioToScaleView:cb3];
    [commond useDefaultRatioToScaleView:view_bg];
    
    view_alertBox.layer.cornerRadius = 10;
    view_alertBox.layer.masksToBounds = YES;
    
    arr_buttons = [[NSMutableArray alloc] initWithObjects:cb1,cb2,cb3, nil];
    
    
}

-(void)setupWithTitle:(NSString*)title message:(NSString*)message buttons:(NSArray*)buttons andCallBack:(void (^)(FGCustomAlertView *alertView, NSInteger buttonIndex))callBackBlock
{
    
    _callBackBlock  = callBackBlock;
  int_dismissButtonIndex = -1;
  
    if(title)
    {
        lb_title.text = title;
        [lb_message setLineSpace:6 alignment:NSTextAlignmentCenter];
        
        [lb_title sizeToFit];
         [commond useDefaultRatioToScaleView:lb_title];
    }
    
    if(message){
        lb_message.text = message;
        
        [lb_message setLineSpace:6 alignment:NSTextAlignmentCenter];
        [lb_message sizeToFit];
       
        [commond useDefaultRatioToScaleView:lb_message];
    }
    
    if(buttons && [buttons count]>0)
    {
        arr_buttonTexts = [buttons copy];
        for(int i=0;i < 3 - [arr_buttonTexts count];i++)
        {
            
            FGCustomButton *_cb = [arr_buttons lastObject];
            [_cb removeFromSuperview];
           [arr_buttons removeLastObject];
        }
        
        for(int i=0;i<[arr_buttonTexts count];i++)
        {
            NSString *_str_buttonText = [arr_buttonTexts objectAtIndex:i];
            FGCustomButton *_cb = [arr_buttons objectAtIndex:i];
            _cb.button.tag = i + 1;
            [_cb setFrame:_cb.frame title:_str_buttonText arrimg:[UIImage imageNamed:@"arr-1.png"] borderColor:[UIColor clearColor] textColor:[UIColor whiteColor] bgColor:color_red_panel];
            
            [_cb.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    [self layoutMyCustomUI];
    [self showPopup];
}

-(void)layoutMyCustomUI
{
    CGFloat dy = paddingTB;
    
    CGRect _frame = CGRectZero;
    
    _frame = lb_title.frame;
    _frame.origin.y = dy;
    _frame.size.width = view_alertBox.frame.size.width - paddingLR * 2;
    lb_title.frame = _frame;
    lb_title.center = CGPointMake(view_alertBox.frame.size.width/2, lb_title.center.y);
    
    dy = lb_title.frame.origin.y + lb_title.frame.size.height + 30;
    
    _frame = lb_message.frame;
    _frame.origin.y = dy;
    _frame.size.width = view_alertBox.frame.size.width - paddingLR * 2;
    _frame.size.height += 40;
    lb_message.frame = _frame;
    lb_message.center = CGPointMake(view_alertBox.frame.size.width / 2, lb_message.center.y);
    
    dy = lb_message.frame.origin.y + lb_message.frame.size.height + 20;
    
    for(int i=0;i<[arr_buttons count];i++)
    {
        FGCustomButton *_cb = [arr_buttons objectAtIndex:i];
        _frame = _cb.frame;
        _frame.origin.y = dy;
        _cb.frame = _frame;
        _cb.center = CGPointMake(view_alertBox.frame.size.width / 2, _cb.center.y);
        dy = _cb.frame.origin.y + _cb.frame.size.height + 10;
    }
    
    dy += paddingTB;
    
    _frame = view_alertBox.frame;
    _frame.size.height = dy;
    view_alertBox.frame = _frame;
    
    view_alertBox.center = CGPointMake(W/2, H/2);
    self.frame = CGRectMake(0, 0, W, H);
    
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)addToSuperview
{
    if ([appDelegate respondsToSelector:@selector(window)]) {
        UIWindow * window = (UIWindow *) [appDelegate performSelector:@selector(window)];
        [window addSubview:self];
    }
}

-(void)show
{
    [self addToSuperview];
    [self becomeFirstResponder];
}

-(void)buttonAction:(UIButton *)_sender
{
    NSInteger buttonIndex = _sender.tag - 1;
    if (_callBackBlock) {
        _callBackBlock(self, buttonIndex);
    }
  
  if (int_dismissButtonIndex == -1)
    [self removeFromSuperview];
  else {
    if (int_dismissButtonIndex == buttonIndex) {
      [self removeFromSuperview];
    }
  }
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_buttons = nil;
    arr_buttonTexts = nil;
    _callBackBlock = nil;
}

-(void)showPopup
{
    view_alertBox.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    view_alertBox.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
    [UIView commitAnimations];
    
    [view_alertBox.layer removeAllAnimations];
}

- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}


- (void)bounce1AnimationStopped {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    view_alertBox.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
    
    [UIView commitAnimations];
}

- (void)bounce2AnimationStopped {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kTransitionDuration/2];
    view_alertBox.transform = [self transformForOrientation];
    view_alertBox.transform = CGAffineTransformScale([self transformForOrientation], 1, 1);
    [UIView commitAnimations];
    
}
@end
