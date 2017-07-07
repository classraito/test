//
//  FGPostSectionTitleView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostSectionTitleView.h"
#import "Global.h"
@implementation FGPostSectionTitleView
@synthesize view_separator_horizontal;
@synthesize view_separator;
@synthesize btn_allPosts;
@synthesize btn_following;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, .5) toScaleView:view_separator_horizontal];
    [commond useRatio:CGRectMake(ratioW, ratioH, 1, ratioH) toScaleView:view_separator];
    [commond useDefaultRatioToScaleView:btn_following];
    [commond useDefaultRatioToScaleView:btn_allPosts];
    
    [btn_allPosts setTitle:multiLanguage(@"ALL USERS") forState:UIControlStateNormal];
    [btn_allPosts setTitle:multiLanguage(@"ALL USERS") forState:UIControlStateHighlighted];
    
    [btn_following setTitle:multiLanguage(@"FOLLOWING") forState:UIControlStateNormal];
    [btn_following setTitle:multiLanguage(@"FOLLOWING") forState:UIControlStateHighlighted];
    
    btn_allPosts.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    btn_following.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    [self setAllPostsHighlighted];
}

-(void)setAllPostsHighlighted
{
    [btn_allPosts setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_allPosts setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [btn_following setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_following setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
}

-(void)setFollowingHighlighted
{
    [btn_allPosts setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn_allPosts setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn_following setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_following setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(IBAction)buttonAction_allPosts;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KEY_HandleSection object:@"allPosts"];
}

-(IBAction)buttonAction_following;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KEY_HandleSection object:@"following"];
}
@end
