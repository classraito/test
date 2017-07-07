//
//  FGWorkingLogSectionView.m
//  CSP
//
//  Created by JasonLu on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWorkingLogSectionView.h"

@implementation FGWorkingLogSectionView
@synthesize delegate_workinglog;
#pragma mark - 生命周期
-(void)awakeFromNib
{
  [super awakeFromNib];
  
  [self.btn_featured setTitle:multiLanguage(@"WEEK") forState:UIControlStateNormal];
  [self.btn_vip setTitle:multiLanguage(@"MONTH") forState:UIControlStateNormal];
  [self.btn_workouts setTitle:multiLanguage(@"TOTAL") forState:UIControlStateNormal];
  
  [self.btn_featured setTitle:multiLanguage(@"WEEK") forState:UIControlStateHighlighted];
  [self.btn_vip setTitle:multiLanguage(@"MONTH") forState:UIControlStateHighlighted];
  [self.btn_workouts setTitle:multiLanguage(@"TOTAL") forState:UIControlStateHighlighted];
}

-(void)dealloc
{
  NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 所有字体都设成灰色

#pragma mark - 按钮事件
-(IBAction)buttonAction_featured:(id)_sender
{
  self.currentSectionType = TraingHomePage_SectionType_Featured;
  [self setAllButtonTextDisable];
  [self.btn_featured setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.btn_featured setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  if(delegate_workinglog && [delegate_workinglog respondsToSelector:@selector(didSelectedSection:)])
  {
    [delegate_workinglog didSelectedSection:self.currentSectionType];
  }
}

-(IBAction)buttonAction_vip:(id)_sender
{
  self.currentSectionType = TraingHomePage_SectionType_VIP;
  [self setAllButtonTextDisable];
  [self.btn_vip setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.btn_vip setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  if(delegate_workinglog && [delegate_workinglog respondsToSelector:@selector(didSelectedSection:)])
  {
    [delegate_workinglog didSelectedSection:self.currentSectionType];
  }
}

-(IBAction)buttonAction_workouts:(id)_sender
{
  self.currentSectionType = TraingHomePage_SectionType_WorkOuts;
  [self setAllButtonTextDisable];
  [self.btn_workouts setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.btn_workouts setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
  if(delegate_workinglog && [delegate_workinglog respondsToSelector:@selector(didSelectedSection:)])
  {
    [delegate_workinglog didSelectedSection:self.currentSectionType];
  }
}

@end
