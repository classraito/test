//
//  FGFitnessLevelTestPopupView_TakePic.h
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"


@interface FGFitnessLevelTestPopupView_TakePic : FGPopupView<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UIImageView *iv_pic;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UIButton *btn_no;
@property(nonatomic,weak)IBOutlet UIButton *btn_done;
@property(nonatomic,weak)IBOutlet UIButton *btn_takePic;
@property(nonatomic,weak)IBOutlet UIView *view_bg;
-(void)setYesButtonTitle:(NSString *)_str;
-(IBAction)buttonAction_takePic_TakeAPhoto:(id)_sender;
@end
