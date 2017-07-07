//
//  FGTrainingMyPlanViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGTrainingSetPlanWeekSectionView.h"
#import "FGTrainingSetPlanMyPlanTopBannerView.h"
#import "FGTrainingMyPlanMorePopupView.h"
@interface FGTrainingMyPlanViewController : FGBaseViewController<FGTrainingSetPlanScheduleCellViewDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,strong)FGTrainingSetPlanWeekSectionView  *view_sectionTitle;
@property(nonatomic,strong)FGTrainingMyPlanMorePopupView *view_morePopup;
@end



@interface FGTrainingMyPlanViewController(Table)<UITableViewDataSource,UITableViewDelegate>
{
    
}
@end

