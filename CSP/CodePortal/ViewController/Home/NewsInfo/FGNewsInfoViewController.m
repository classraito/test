//
//  FGNewsInfoViewController.m
//  CSP
//
//  Created by JasonLu on 16/11/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGNewsInfoViewController.h"
#import "FGNewsInfoView.h"

@interface FGNewsInfoViewController () {
}

#pragma mark - 属性
@property (nonatomic, strong) FGNewsInfoView *view_newsInfo;
@property (nonatomic, copy) NSString *str_link;
@property (nonatomic, copy) NSString *str_title;

@end

@implementation FGNewsInfoViewController
@synthesize view_newsInfo;
@synthesize str_link;
@synthesize str_title;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withInfo:(id)_obj withTtitle:(NSString *)_title
{
  if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
    if (_obj != nil && [_obj isKindOfClass:[NSString class]]) {
      self.str_link = [NSString stringWithFormat:@"%@", _obj];
      self.str_title = _title;
    }
  }
  return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withInfo:(id)_obj
{
  return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil withInfo:_obj withTtitle:@""];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  [self hideBottomPanelWithAnimtaion:NO];
  [self internalInitalViewController];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self setWhiteBGStyle];
  
  if (self.view_newsInfo) {
    [self.view_newsInfo setupNewsInfoWithLink:self.str_link];
  }
}

- (void)manullyFixSize {
  [super manullyFixSize];
}

- (void)dealloc {
  [self.view_newsInfo clearTimer];
  self.view_newsInfo   = nil;
  self.str_link = nil;
  self.str_title = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

- (void)internalInitalViewController {
  self.view_topPanel.str_title = [self.str_title isEmptyStr] ? multiLanguage(@"NEWS") : self.str_title;
  view_newsInfo = (FGNewsInfoView *)[[[NSBundle mainBundle] loadNibNamed:@"FGNewsInfoView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_newsInfo];
  CGRect frame             = self.view_topPanel.frame;
  view_newsInfo.frame = CGRectMake(0, frame.size.height, view_newsInfo.frame.size.width, view_newsInfo.frame.size.height);
  [self.view addSubview:view_newsInfo];
}

//- (void)setupNewsInfoViewWithLink:(NSString *)_link {
//  if (_link == nil)
//    return;
//  self.str_link = _link;
//}


@end
