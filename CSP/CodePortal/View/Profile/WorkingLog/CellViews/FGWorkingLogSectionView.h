//
//  FGWorkingLogSectionView.h
//  CSP
//
//  Created by JasonLu on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingTableSectionView.h"
@protocol FGWorkingLogSectionViewDelegate <NSObject>
-(void)didSelectedSection:(TraingHomePage_SectionType )_currentSectionType;
@end

@interface FGWorkingLogSectionView : FGTrainingTableSectionView
@property(nonatomic,weak)id<FGWorkingLogSectionViewDelegate> delegate_workinglog;
@end
