//
//  FGFitnessLevelTestPopupView_TakePic.m
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessLevelTestPopupView_TakePic.h"
#import "Global.h"
@implementation FGFitnessLevelTestPopupView_TakePic
@synthesize lb_title;
@synthesize iv_pic;
@synthesize lb_subtitle;
@synthesize btn_no;
@synthesize btn_done;
@synthesize btn_takePic;
@synthesize view_bg;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:iv_pic];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useDefaultRatioToScaleView:btn_no];
    [commond useDefaultRatioToScaleView:btn_done];
    [commond useDefaultRatioToScaleView:btn_takePic];
    [commond useDefaultRatioToScaleView:view_bg];
    
    
    lb_title.font = font(FONT_TEXT_BOLD, 22);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 16);
    btn_done.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    btn_no.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    NSString *_str_no = multiLanguage(@"NO");
    [btn_no setTitle:_str_no forState:UIControlStateNormal];
    [btn_no setTitle:_str_no forState:UIControlStateHighlighted];
    
    
    [self setYesButtonTitle:multiLanguage(@"YES")];
    
    lb_title.text = multiLanguage(@"Do you want to take\nan after pic?");
    lb_subtitle.text = multiLanguage(@"You can save this in your fitness log and/or share it with friends!");
}

-(void)setYesButtonTitle:(NSString *)_str
{
    [btn_done setTitle:_str forState:UIControlStateNormal];
    [btn_done setTitle:_str forState:UIControlStateHighlighted];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(IBAction)buttonAction_takePic_TakeAPhoto:(id)_sender
{
    [self takePhoto];
}

-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        UIViewController *vc_selfView = [self viewController];
        //    [vc_selfView presentModalViewController:picker animated:YES];
        [vc_selfView presentViewController:picker animated:YES completion:^{
            
        }];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        iv_pic.image = image;
        
        [[self viewController] dismissViewControllerAnimated:YES completion:^{
            
        }];
        [self setYesButtonTitle:multiLanguage(@"DONE")];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
