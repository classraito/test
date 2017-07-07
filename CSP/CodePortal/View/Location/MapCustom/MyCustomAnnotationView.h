//
//  MyAnimatedAnnotationView.h
//  IphoneMapSdkDemo
//
//  Created by wzy on 14-11-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "FGLocationsCustomPaoPaoView.h"
@interface MyCustomAnnotationView : MAAnnotationView
{
    
}
@property (nonatomic, strong) FGLocationsCustomPaoPaoView *calloutView;
@property (nonatomic, strong) UIImageView *annotationImageView;
-(void)setAnnotaionViewByImage:(UIImage *)_img highlightedImg:(UIImage *)_highlightedImg;
@end
