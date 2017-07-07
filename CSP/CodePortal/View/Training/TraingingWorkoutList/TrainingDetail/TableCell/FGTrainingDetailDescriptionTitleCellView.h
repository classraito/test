//
//  FGTrainingDetailDescriptionTitleCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGTrainingDetailDescriptionTitleCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UIImageView *iv_arr;
-(void)openAnimation;
-(void)closeAnimation;
-(void)openAnimationWithAnimation:(BOOL)_animation;
-(void)closeAnimationWithAnimation:(BOOL)_animation;
@end
