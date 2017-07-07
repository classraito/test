//
//  FGPostEditPhotoView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    EditType_Filter = 0,
    EditType_Sticker = 1
}EditType;

#define MAX_FILTERS 10

@interface FGPostEditPhotoView : UIView
{
    
}
@property(nonatomic,strong)UIImage *img_edited;
@property(nonatomic,weak)IBOutlet UIView *view_container;
@property(nonatomic,weak)IBOutlet UIImageView *iv_needToEdit;
@property(nonatomic,weak)IBOutlet UIScrollView *sv_filterContainer;
@property(nonatomic,weak)IBOutlet UIView *view_switchStickOrFilter;
@property(nonatomic,weak)IBOutlet UIView *view_separator_stickerAndFilter;
@property(nonatomic,weak)IBOutlet UIButton *btn_filter;
@property(nonatomic,weak)IBOutlet UIButton *btn_sticker;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancel;
@property(nonatomic,weak)IBOutlet UIButton *btn_next;
-(void)setupNeedEditedImage:(UIImage *)_img;
-(IBAction)buttonAction_switchToSticker:(id)_sender;
-(IBAction)buttonAction_switchToFilter:(id)_sender;
-(UIImage *)getEditedImg;
@end
