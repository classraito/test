//
//  FGFitnessTestTopBannerCellView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGFitnessTestTopBannerCellView.h"
#import "Global.h"
@implementation FGFitnessTestTopBannerCellView
@synthesize iv_banner;
@synthesize btn_startTest;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [commond useDefaultRatioToScaleView:iv_banner];
    [commond useDefaultRatioToScaleView:btn_startTest];
    
    btn_startTest.backgroundColor = [UIColor blackColor];
    btn_startTest.layer.cornerRadius = 10;
    btn_startTest.layer.masksToBounds = YES;
    NSString *str_startTest = multiLanguage(@"START TEST");
    [btn_startTest setTitle:str_startTest forState:UIControlStateNormal];
    [btn_startTest setTitle:str_startTest forState:UIControlStateHighlighted];
    
    btn_startTest.titleLabel.font = font(FONT_TEXT_BOLD, 16);
    
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(IBAction)buttonAction_startTest:(id)_sender;
{
    FGProfileFitnessTestModel *model = [FGProfileFitnessTestModel sharedModel];
    [model resetData];
    [model invalidateTimer];//重置计算模型
    
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushControllerByName:@"FGProfileFitnessLevelTestViewController" inNavigation:nav_current];
}
@end
