//
//  FGPostEditPhotoViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/10/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGPostEditPhotoView.h"
@interface FGPostEditPhotoViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong)FGPostEditPhotoView *view_editPhoto;
@property(nonatomic,strong)NSString *str_videoPath;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil image:(UIImage *)_img  videoPath:(NSString *)_str_videoPath;
@end
