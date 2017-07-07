//
//  FGPostSectionTitleView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGPostSectionTitleView : UICollectionReusableView
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_separator_horizontal;
@property(nonatomic,weak)IBOutlet UIView *view_separator;
@property(nonatomic,weak)IBOutlet UIButton *btn_allPosts;
@property(nonatomic,weak)IBOutlet UIButton *btn_following;
-(void)setFollowingHighlighted;
-(IBAction)buttonAction_allPosts;
-(IBAction)buttonAction_following;
@end
