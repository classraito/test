//
//  FGPostViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/9/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGPostAllPostsCollectView.h"
#import "FGPostFollwingPostsView.h"
#define KEY_HandleSection @"HandleSection"
@interface FGPostViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong)FGPostAllPostsCollectView *view_allPosts;
@property(nonatomic,strong)FGPostFollwingPostsView *view_following;
@end
