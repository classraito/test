//
//  FGLocationRegisteAGroupView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationRegisteAGroupView.h"
#import "Global.h"

@implementation FGLocationRegisteAGroupView
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize lb_email;
@synthesize iv_bg;
@synthesize iv_email;
@synthesize btn_email;
@synthesize str_emailSubject;
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view_bg.backgroundColor = [UIColor clearColor];
    
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useDefaultRatioToScaleView:lb_email];
    [commond useDefaultRatioToScaleView:iv_bg];
    [commond useDefaultRatioToScaleView:iv_email];
    [commond useDefaultRatioToScaleView:btn_email];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 20);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 16);
    lb_email.font = font(FONT_TEXT_REGULAR, 16);
    
    lb_title.text = multiLanguage(@"Create a group");
    lb_subtitle.text = multiLanguage(@"please email to add your gym:");
    lb_email.text = multiLanguage(@"gymregistration@weboxapp.com");
    
    btn_email.layer.cornerRadius = btn_email.frame.size.width / 2;
    btn_email.layer.masksToBounds = YES;
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    str_emailSubject = nil;
}

-(void)displayComposerSheet
{
    @try {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setSubject:str_emailSubject];
        
        // Set up recipients
        NSArray *toRecipients = [NSArray arrayWithObject:@"gymregistration@weboxapp.com"];
        
        
        [picker setToRecipients:toRecipients];
        
        // Attach an image to the email
        /*  NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"png"];
         NSData *myData = [NSData dataWithContentsOfFile:path];
         [picker addAttachmentData:myData mimeType:@"image/png" fileName:@""];*/
        
        // Fill out the email body text
        
        [[self viewController] presentViewController:picker animated:YES completion:^{
            
        }];

    } @catch (NSException *exception) {
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please, setup a mail account in your phone first.") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
            
        }];
    } @finally {
        
    }
    
    
    }

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [[self viewController] dismissViewControllerAnimated:YES completion:^{
        UIViewController *vc =  [self viewController];
        if([vc isKindOfClass:[FGLocationFindAGroupViewController class]])
        {
            FGLocationFindAGroupViewController *vc_findAGroup = (FGLocationFindAGroupViewController *)vc;
            SAFE_RemoveSupreView(vc_findAGroup.view_map.view_registeGroupPopup)
            vc_findAGroup.view_map.view_registeGroupPopup = nil;
        }
        if([vc isKindOfClass:[FGLocationFindAGYMViewController class]])
        {
            FGLocationFindAGYMViewController *vc_findAGYM = (FGLocationFindAGYMViewController *)vc;
            SAFE_RemoveSupreView(vc_findAGYM.view_map.view_registeGroupPopup)
            vc_findAGYM.view_map.view_registeGroupPopup = nil;
        }

    }];
}

-(IBAction)buttonAction_sendEmail:(id)_sender;
{
    
    if([MFMailComposeViewController canSendMail])
    {
         [self displayComposerSheet];
    }
    else{
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please, setup a mail account in your phone first.") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
            
        }];
    }
   
}
@end
