//
//  FGPhotoVideoGallery.h
//  CSP
//
//  Created by Ryan Gong on 16/11/11.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGPhotoVideoGalleryDelegate <NSObject>
-(void)didClickClose;
@end

@interface FGPhotoVideoGallery : UIView<UIScrollViewDelegate>
{

}
@property CGRect rect_showFrom;
@property(nonatomic,weak)IBOutlet UIScrollView *sv;
@property(nonatomic,weak)IBOutlet UIView *view_videoContainer;
@property(nonatomic,weak)IBOutlet UIPageControl *pc;
@property(nonatomic,weak) id <FGPhotoVideoGalleryDelegate> delegate;
-(void)setupByImagUrls:(NSMutableArray *)_arr_imgUrls currentIndex:(NSInteger)_currentIndex videoUrl:(NSString *)_str_videoUrl;
-(void)setupByImags:(NSMutableArray *)_arr_imgs  currentIndex:(NSInteger)_currentIndex  videoUrl:(NSString *)_str_videoUrl;
@end
