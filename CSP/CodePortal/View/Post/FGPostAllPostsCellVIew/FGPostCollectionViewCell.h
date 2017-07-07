//
//  FGBadgeCollectionViewCell.h
//  CSP
//
//  Created by JasonLu on 16/10/11.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGPostCollectionViewCell : UICollectionViewCell
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *iv_thumbnail;
@property(nonatomic,weak)IBOutlet UIImageView *iv_play;
- (void)setupBadgeWithInfo:(NSDictionary *)info;
-(void)setupPostThumbnailByUrlPath:(NSMutableDictionary * )_dic_info;
-(void)setupPostImageByUrlPath:(NSString *)_str_url;
@end
