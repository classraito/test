//
//  FGProfileFavoriteViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/12/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingWorkOutListViewController.h"
#import "FGProfileFavoriteListView.h"
@interface FGProfileFavoriteViewController : FGTrainingWorkOutListViewController
{
    
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)_str_title;
@property(nonatomic,strong)FGProfileFavoriteListView *view_faroviteList;
@end
