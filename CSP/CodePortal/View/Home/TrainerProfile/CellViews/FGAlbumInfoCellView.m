//
//  FGAlbumInfoCellView.m
//  CSP
//
//  Created by JasonLu on 16/10/21.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGAblumScrollView.h"
#import "FGAlbumInfoCellView.h"
@interface FGAlbumInfoCellView ()
@property (weak, nonatomic) IBOutlet FGAblumScrollView *sv_album;
@end

@implementation FGAlbumInfoCellView

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [commond useDefaultRatioToScaleView:self.sv_album];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
  NSArray *images = _dataInfo[@"images"];
  [self.sv_album setupAblumWithImages:images imgSize:CGSizeMake(50 * ratioW, 50 * ratioH) showNumber:4 inBoundSize:self.sv_album.frame.size padding:10];
}

@end
