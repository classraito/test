//
//  FGCustomizableBaseView.m
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/11/19.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import "FGCustomizableBaseView.h"
#import "Global.h"
@implementation FGCustomizableBaseView
@synthesize view_content;
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        self.view_content = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        [self addSubview:view_content];
        self.backgroundColor = [UIColor clearColor];
        return self;
    }
    return nil;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
   self.view_content.frame = self.bounds;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end
