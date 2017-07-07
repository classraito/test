//
//  FGTrainingTableSectionView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGTrainingTableSectionView;
typedef enum
{
    TraingHomePage_SectionType_Featured = 0,
    TraingHomePage_SectionType_VIP = 1,
    TraingHomePage_SectionType_WorkOuts = 2
}TraingHomePage_SectionType;

@protocol FGTrainingTableSectionViewDelegate <NSObject>
-(void)didSelectedSection:(TraingHomePage_SectionType )_currentSectionType;
@end

@interface FGTrainingTableSectionView : UIView
{
    
}
@property TraingHomePage_SectionType currentSectionType;
@property(nonatomic,weak)IBOutlet UIButton *btn_featured;
@property(nonatomic,weak)IBOutlet UIButton *btn_vip;
@property(nonatomic,weak)IBOutlet UIButton *btn_workouts;
@property(nonatomic,weak)IBOutlet UIView *view_separator1;
@property(nonatomic,weak)IBOutlet UIView *view_separator2;
-(IBAction)buttonAction_featured:(id)_sender;
-(IBAction)buttonAction_vip:(id)_sender;
-(IBAction)buttonAction_workouts:(id)_sender;
-(void)setAllButtonTextDisable;
@property(nonatomic,weak)id<FGTrainingTableSectionViewDelegate> delegate;
@end
