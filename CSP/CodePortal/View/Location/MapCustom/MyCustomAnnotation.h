//
//  MyCustomAnnotation.h
//  DunkinDonuts
//
//  Created by Ryan Gong on 15/12/1.
//  Copyright © 2015年 Ryan Gong. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>


@interface MyCustomAnnotation : MAPointAnnotation
{
    
}
@property(nonatomic,strong)NSMutableDictionary *dic_annotationInfo;
@end
