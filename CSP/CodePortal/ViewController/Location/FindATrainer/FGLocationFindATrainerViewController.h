//
//  FGLocationFindATrainerViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGLocationFindATrainerFillLocationView.h"
#import "FGLocationFindATrainerMapView.h"
#import "FGLocationFindAMultiClassFillLocationView.h"

@interface FGLocationFindATrainerViewController : FGBaseViewController<UIGestureRecognizerDelegate>
{
    
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil trainingID:(NSString *)_str_trainingID dateStr:(NSString *)_str_date timeStr:(NSString *)_str_timeStr;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil trainingID:(NSString *)_str_trainingID dateStr:(NSString *)_str_date timeStr:(NSString *)_str_timeStr isMultiClass:(BOOL)_isMultiClass;
@property(nonatomic,strong)FGLocationFindATrainerMapView *view_mapView;
@property(nonatomic,strong)FGLocationFindATrainerFillLocationView *view_fillLocation;
@property(nonatomic,strong)FGLocationFindAMultiClassFillLocationView *view_multiClassFillLocation;
-(void)hideFillLocation;
-(void)showFillLocation;
-(void)showMultiClassFillLocation;
-(void)go2RequestSended;
@end
