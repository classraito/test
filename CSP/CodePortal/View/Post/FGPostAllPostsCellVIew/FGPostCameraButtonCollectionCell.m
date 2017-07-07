//
//  FGPostCameraButtonView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostCameraButtonCollectionCell.h"
#import "Global.h"
#import "UIView+ViewController.h"
@implementation FGPostCameraButtonCollectionCell
@synthesize iv_camera;
@synthesize btn_camera;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:iv_camera];
    [commond useDefaultRatioToScaleView:btn_camera];
   
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"<::::::::::::::>test collection cell reuseable");
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FGPostCameraButtonCollectionCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}


-(IBAction)buttonAction_go2Camera:(id)_sender;
{
    FGPostCameraViewController *vc_postCamera = [[FGPostCameraViewController alloc] initWithNibName:@"FGPostCameraViewController" bundle:nil];
    [nav_current presentViewController:vc_postCamera animated:YES completion:nil];
}
@end
