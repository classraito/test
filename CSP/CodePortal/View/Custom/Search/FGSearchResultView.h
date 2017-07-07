//
//  FGSearchResultView.h
//  CSP
//
//  Created by JasonLu on 16/10/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomizableBaseView.h"

@protocol FGSearchResultViewDelegate <NSObject>

- (void)didSelectedWithResult:(NSString *)_str_key;

@end

@interface FGSearchResultView : UIView <UITableViewDelegate,UITableViewDataSource>;
@property (weak, nonatomic) IBOutlet UITableView *tb_serachResult;
@property (nonatomic, strong) NSMutableArray *arr_data;
@property (nonatomic, assign) id<FGSearchResultViewDelegate>delegate;
- (void)bindDataToUI;
- (void)action_loadingData;
@end
