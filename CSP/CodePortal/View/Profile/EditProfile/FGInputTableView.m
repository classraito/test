//
//  FGInputTableView.m
//  CSP
//
//  Created by JasonLu on 16/10/31.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGInputTableView.h"

@implementation FGInputTableView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    ;
  }
  
  return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  NSLog(@"scollView==%@", scrollView);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  NSLog(@"begin scrollview...====================");
}
@end
