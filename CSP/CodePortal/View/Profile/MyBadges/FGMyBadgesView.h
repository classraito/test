//
//  FGMyBadgesView.h
//  CSP
//
//  Created by JasonLu on 16/10/10.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGMyBadgesView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>
{
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *cv_myBadgesList;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, copy) NSString *str_id;
- (void)bindDataToUI;
- (void)runRequest_GetUserBadges;
@end
