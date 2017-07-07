//
//  FGBadgeCollectionViewCell.h
//  CSP
//
//  Created by JasonLu on 16/10/11.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FGBadgeCollectionViewCellDelegate <NSObject>

- (void)didSelectedCell;

@end

@interface FGBadgeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn_cellDetail;
- (void)setupBadgeWithInfo:(NSDictionary *)info;
@end
