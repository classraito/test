//
//  MyAnimatedAnnotationView.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 14-11-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "MyCustomAnnotationView.h"

@implementation MyCustomAnnotationView
@synthesize annotationImageView;
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        annotationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        annotationImageView.contentMode = UIViewContentModeScaleAspectFit;
        annotationImageView.userInteractionEnabled = NO;
        [self addSubview:annotationImageView];
    }
    return self;
}

-(void)setAnnotaionViewByImage:(UIImage *)_img highlightedImg:(UIImage *)_highlightedImg
{
    annotationImageView.image = _img;
    annotationImageView.highlightedImage = _highlightedImg;
    self.bounds = CGRectMake(0, 0, _img.size.width/2, _img.size.height/2);
    annotationImageView.bounds = self.bounds;
    annotationImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

-(void)dealloc
{
    annotationImageView = nil;
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView =  (FGLocationsCustomPaoPaoView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLocationsCustomPaoPaoView" owner:nil options:nil] objectAtIndex:0];
            [commond useDefaultRatioToScaleView:self.calloutView];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        annotationImageView.highlighted = YES;
        [self addSubview:self.calloutView];
    }
    else
    {
        annotationImageView.highlighted = NO;
        [self.calloutView removeFromSuperview];
        self.calloutView = nil;
    }
    
    [super setSelected:selected animated:animated];
}

/*避免弹出框上的事件无法响应*/
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}
@end
