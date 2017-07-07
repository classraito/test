//
//  MyCustomAnnotation.m
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/12/1.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import "MyCustomAnnotation.h"

@implementation MyCustomAnnotation
@synthesize dic_annotationInfo;
-(void)dealloc
{
    dic_annotationInfo = nil;
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end
