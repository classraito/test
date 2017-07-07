//
//  FGPostCameraButtonView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGPostCameraButtonCollectionCell : UICollectionViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_camera;
@property(nonatomic,weak)IBOutlet UIButton *btn_camera;
-(IBAction)buttonAction_go2Camera:(id)_sender;
@end
