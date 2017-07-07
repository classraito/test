//
//  FGPostCameraViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/10/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGPostCameraView.h"
@interface FGPostCameraViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong)FGPostCameraView *view_camera;
-(void)buttonAction_cancel:(id)_sender;
@end
