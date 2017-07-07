//
//  FGPhotoGalleryManager.h
//  CSP
//
//  Created by Ryan Gong on 17/2/4.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KNPhotoBrowerImageView.h"
#import "KNPhotoBrower.h"
@interface FGPhotoGalleryManager : NSObject
{
    
}
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSMutableArray *actionSheetArray; // 右上角弹出框的 选项 -->代理回调
@property(nonatomic,strong)KNPhotoBrower *photoBrower;
+(FGPhotoGalleryManager *)sharedManager;
+(void)clearManager;
-(KNPhotoBrower *)showPhotoGalleryFromSourceViews:(NSMutableArray *)_arr_imgViews imgUrls:(NSMutableArray *)urlArr atIndex:(int)_photoIndex;
@end
