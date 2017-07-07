//
//  FGPostAllPostsCollectView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGPostCameraButtonView.h"
@interface FGPostAllPostsCollectView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
{
    
}
@property(nonatomic,copy)NSMutableArray *arr_data;
@property (weak, nonatomic) IBOutlet UICollectionView *cv_allPosts;
@property(nonatomic,strong)FGPostCameraButtonView *view_cameraButton;
-(void)bindDataToUI;
- (void)loadMorePosts ;
-(void)beginRefresh;
-(void)postRequst_getAllPostList;
@end
