//
//  FGCIImageFilterTool.m
//  CSP
//
//  Created by Ryan Gong on 16/11/3.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCIImageFilterTool.h"
#import "Global.h"
#import <objc/runtime.h>
static FGCIImageFilterTool *imgTool;
@interface FGCIImageFilterTool()
{
    
}
@end

@implementation FGCIImageFilterTool
@synthesize arr_items;
@synthesize arr_displayNames;
+(id)alloc
{
    @synchronized(self)     {
        NSAssert(imgTool == nil, @"企圖創建一個singleton模式下的MemoryCache");
        return [super alloc];
    }
    return nil;
}


+(FGCIImageFilterTool *)sharedTool//用这个方法来初始化MemoryCache
{
    @synchronized(self)     {
        if(!imgTool)
        {
            imgTool=[[FGCIImageFilterTool alloc]init];
            
//            imgTool.arr_items = [[NSMutableArray alloc] init];
//            imgTool.arr_displayNames = [[NSMutableArray alloc] init];
//            [imgTool setupFilters];
            imgTool.arr_items = (NSMutableArray *)@[
                                  @"",
                                  @"CIPhotoEffectChrome",
                                  @"CIPhotoEffectFade",
                                  @"CIPhotoEffectInstant",
                                  @"CIPhotoEffectProcess",
                                  @"CIPhotoEffectTransfer",
//                                  @"CIEdgeWork",
                                  @"CISRGBToneCurveToLinear",
                                  @"CISepiaTone",
                                  @"CIComicEffect",
                                  @"CIBoxBlur",
                                  @"CIDiscBlur",
                                  @"CIHeightFieldFromMask",
                                  @"CILinearToSRGBToneCurve",
                                  @"CIPhotoEffectMono",
                                  @"CIPhotoEffectNoir"
                                  ];
            
//            imgTool.arr_displayNames = (NSMutableArray *)@[
//                                                           @"Origin",
//                                                           @"Photo Effect Chrome",
//                                                           @"Photo Effect Fade",
//                                                           @"Photo Effect Instant",
//                                                           @"Photo Effect Process",
//                                                           @"Photo Effect Transfer",
////                                                           @"Edge Work",
//                                                           @"sRGB Tone Curve to Linear",
//                                                           @"Sepia Tone",
//                                                           @"Comic Effect",
//                                                           @"Box Blur",
//                                                           @"Disc Blur",
//                                                           @"Height Field From Mask",
//                                                           @"Linear to sRGB Tone Curve",
//                                                           @"Photo Effect Mono",
//                                                           @"Photo Effect Noir"
//                                                           ];
            
            imgTool.arr_displayNames = (NSMutableArray *)@[
                                                           @"Origin",
                                                           @"Chrome",
                                                           @"Fade",
                                                           @"Instant",
                                                           @"Process",
                                                           @"Transfer",
                                                           //                                                           @"Edge Work",
                                                           @"Curve to Linear",
                                                           @"Sepia Tone",
                                                           @"Comic Effect",
                                                           @"Box Blur",
                                                           @"Disc Blur",
                                                           @"Light Off",
                                                           @"Light On",
                                                           @"Mono",
                                                           @"Noir"
                                                           ];


//            [imgTool fillInDisplayNameByItems];
        
//            NSLog(@"%@",imgTool.arr_items);
//            NSLog(@"%@",imgTool.arr_displayNames);
            return imgTool;
        }
    }
    return imgTool;
}

-(void)fillInDisplayNameByItems
{
    for(int i=0;i<[imgTool.arr_items count];i++)
    {
        NSString *_filterName = [imgTool.arr_items objectAtIndex:i];
        CIFilter *_filter = [CIFilter filterWithName:_filterName];
        NSString *str_displayName = [_filter.attributes objectForKey:kCIAttributeFilterDisplayName];
        [imgTool.arr_displayNames addObject:str_displayName];
    }

}

-(void)setupFilters
{
    NSArray *categorys = @[kCICategoryStillImage,kCICategoryBlur,kCICategoryColorEffect,kCICategoryColorAdjustment,kCICategoryGradient];
    
    for(NSString *category in categorys)
    {
        NSArray *arr_itemInSingleCategory = [CIFilter filterNamesInCategory:category];
        for(NSString *_filterName in arr_itemInSingleCategory)
        {
            if(![imgTool.arr_items containsObject:_filterName])
            {
                CIFilter *_filter = [CIFilter filterWithName:_filterName];
                if([_filter.inputKeys count]==1 && [_filter.inputKeys containsObject:kCIInputImageKey])
                {
                    [imgTool.arr_items addObject:_filterName];
                    [imgTool.arr_displayNames addObject:[_filter.attributes objectForKey:kCIAttributeFilterDisplayName]];
                }
                _filter = nil;
            }
        }
    }
}

-(void)dealloc
{
    imgTool.arr_items = nil;
    imgTool.arr_displayNames = nil;
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}




-(UIImage *)filterByImage:(UIImage *)orgImage useFilter:(NSString *)_str_filter
{
    if([_str_filter isEmptyStr])
        return orgImage;
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:orgImage];
    
    CIFilter *filter = [CIFilter filterWithName:_str_filter
                                  keysAndValues:kCIInputImageKey, ciImage, nil];
    
    [filter setDefaults];
    
    CIContext *context = [CIContext contextWithOptions:nil];
//    EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  //  CIContext *context = [CIContext contextWithEAGLContext:eaglContext];
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    NSLog(@"orgImage.imageOrientation = %d",orgImage.imageOrientation);
    
    
    UIImage *retImage = [UIImage imageWithCGImage:cgImage];
    ciImage = nil;
    CGImageRelease(cgImage);
    
    return retImage;

}

-(UIImage *)filterByImage:(UIImage *)orgImage byFilterListIndex:(NSInteger)_index
{
   return [self filterByImage:orgImage useFilter:[self.arr_items objectAtIndex:_index]];
}
@end
