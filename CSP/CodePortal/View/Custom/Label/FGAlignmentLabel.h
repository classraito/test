//
//  FGAlignmentLabel.h
//  CSP
//
//  Created by JasonLu on 16/9/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
  VerticalAlignmentTop = 0, // default
  VerticalAlignmentMiddle,
  VerticalAlignmentBottom,
} VerticalAlignment;
@interface FGAlignmentLabel : UILabel {
}
@property (nonatomic, assign) VerticalAlignment verticalAlignment;
@end