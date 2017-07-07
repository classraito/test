//
//  FGPhotoGalleryManager.m
//  CSP
//
//  Created by Ryan Gong on 17/2/4.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGPhotoGalleryManager.h"
#import "Global.h"

static FGPhotoGalleryManager *galleryManager;
@interface FGPhotoVideoGallery()<KNPhotoBrowerDelegate>
{
    
}
@end


@implementation FGPhotoGalleryManager
@synthesize itemsArray;
@synthesize actionSheetArray; // 右上角弹出框的 选项 -->代理回调
@synthesize photoBrower;
+(FGPhotoGalleryManager *)sharedManager
{
    @synchronized(self)     {
        if(!galleryManager)
        {
            galleryManager=[[FGPhotoGalleryManager alloc]init];
            return galleryManager;
        }
    }
    return galleryManager;
}

+(void)clearManager
{
    if(!galleryManager)
        return;
    galleryManager = nil;
}

-(id)init
{
    if(self = [super init])
    {
        itemsArray = [[NSMutableArray alloc] initWithCapacity:1];
        actionSheetArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

+(id)alloc
{
    @synchronized(self)     {
        NSAssert(galleryManager == nil, @"企圖重复創建一個singleton模式下的FGPhotoGalleryManager");
        return [super alloc];
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    itemsArray = nil;
    actionSheetArray = nil;
}

-(KNPhotoBrower *)showPhotoGalleryFromSourceViews:(NSMutableArray *)_arr_imgViews imgUrls:(NSMutableArray *)urlArr atIndex:(int)_photoIndex
{
    if([_arr_imgViews count]!=urlArr.count)
    {
        NSLog(@"图片对象和对应的url数量不相同");
        urlArr = nil;
    
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [actionSheetArray removeAllObjects];
    [self.itemsArray removeAllObjects];
    
    
    int i=0;
    for(UIImageView *iv in _arr_imgViews)
    {
        KNPhotoItems *items = [[KNPhotoItems alloc] init];
        if(urlArr)
            items.url = [urlArr[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        NSLog(@"items.url = %@",items.url);
        items.sourceView = iv;
        [self.itemsArray addObject:items];
        i++;
    }
    
    photoBrower = nil;
    photoBrower = [[KNPhotoBrower alloc] init];
    photoBrower.itemsArr = [itemsArray copy];
    photoBrower.currentIndex = _photoIndex;
    
    // 如果设置了 photoBrower中的 actionSheetArr 属性. 那么 isNeedRightTopBtn 就应该是默认 YES, 如果设置成NO, 这个actionSheetArr 属性就没有意义了
    // photoBrower.actionSheetArr = [self.actionSheetArray mutableCopy];
    
    [photoBrower setIsNeedRightTopBtn:YES]; // 是否需要 右上角 操作功能按钮
    [photoBrower setIsNeedPictureLongPress:YES]; // 是否 需要 长按图片 弹出框功能 .默认:需要
    
    [photoBrower present];
    
    // 设置代理方法 --->可不写
    photoBrower.delegate = self;
    
    return photoBrower;
    
}

#pragma mark - Delegate

/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss{
    NSLog(@"Will Dismiss");
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)photoBrowerDidDismiss;
{
    [photoBrower removeFromSuperview];
    photoBrower = nil;

}

/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index{
    NSLog(@"operation:%zd",index);
    if(index == 0)
    {
        
    }
}

/**
 *  删除当前图片
 *
 *  @param index 相对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index{
    NSLog(@"delete-Relative:%zd",index);
}

/**
 *  删除当前图片
 *
 *  @param index 绝对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index{
    NSLog(@"delete-Absolute:%zd",index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success{
    NSLog(@"saveImage:%zd",success);
}
@end
