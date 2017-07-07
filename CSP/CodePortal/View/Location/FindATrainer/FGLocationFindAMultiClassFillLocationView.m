//
//  FGLocationFindAMultiClassFillLocationView.m
//  CSP
//
//  Created by Ryan Gong on 17/2/16.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGLocationFindAMultiClassFillLocationView.h"
#import "Global.h"
@implementation FGLocationFindAMultiClassFillLocationView
@synthesize lb_description;
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_description];

    lb_description.font = font(FONT_TEXT_REGULAR, 16);
    
    lb_description.text = multiLanguage(@"Click next to select the number of classes you wish to take, then select the start date.Select the day of the week and time you wish to spread your multibookings over");

    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end
