//
//  FGAboutViewController.m
//  可展开Cell
//
//  Created by PengLei on 17/1/20.
//  Copyright © 2017年 PengLei. All rights reserved.
//

#import "FGAboutViewController.h"
#import "FGAboutCell.h"
#import "ConstValue.h"
#import "FAQModel.h"

@interface FGAboutViewController ()
{
    BOOL isChinese;
}
@property (nonatomic,strong) NSArray * list_question;
@property (nonatomic,strong) NSMutableArray * list_model;
@property (nonatomic,strong) NSArray * arr_imageIcons;
@end

@implementation FGAboutViewController

static NSString * KFGAboutCell = @"FGAboutCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
  self.view_topPanel.str_title = multiLanguage(@"About Us");
  SAFE_RemoveSupreView(self.view_topPanel.btn_right);
  SAFE_RemoveSupreView(self.view_topPanel.iv_right);
  
  [self hideBottomPanelWithAnimtaion:NO];
  
    [self initDatas];
    
    [self initSubViews];
}

//加载数据
-(void)initDatas
{
    //中引文测试
    isChinese = YES;
    
    
    self.arr_imageIcons = @[@"CSP-LOGO",@"LOGO-60"];
    
    NSString *text1 , *text2;
    if (!isChinese) {
        self.list_question = @[@"About China Sports Promotions",@"About WeBox"];
        
        text1 = @"China Sports Promotions is the largest organizer of white collar boxing training and events in China. Our events engage and educate local communities through our boxing training programs and black tie white collar boxing fight nights. Supported by a reality television show and training application CSP currently expanding its operations all over greater China.\n\nOur events take place in Shanghai, Beijing, and Taipei. Collectively we have raised over RMB 2.6 million in donations for charity organizations in China at our white collar boxing events.\n\nWe focus on creativity, quality and execution allowing our team to cater to corporate launches and private black tie functions alike. We have unrivalled access to some of the best partners in Asia allowing us to produce high impact, well executed events.\n\nIn 2015 we moved into reality television production. The eight episode series called 'White Collar Boxing' aired on Sohu.com in June and received over eight and a half million views. With its season two being produced on Youku in 2016 receiving over 10 million views, we are excited to announce that we will continue to produce more great seasons in different cities all across China in 2017!\n\nWe are also announcing the launch of our free mobile based application WeBox this year. The application provides training access to beginner boxers, fitness boxers and seasoned boxers alike. The mandate of WeBox is to build the largest boxing community in the world.";
        
        text2 = @"Created by White Collar Boxing International, WeBox is the largest boxing community in China. The mobile based application is free to download and provides training access to beginner boxers, fitness boxers and seasoned boxers alike. The application contains easy to use training content, encourages community generation and provides access to boxing training with our specially trained WeBox trainers. The mandate of WeBox is to build the largest boxing community in the world.";
    }
    else{
    
    self.list_question = @[@"关于朝世企业管理咨询（上海）有限公司",@"关于WeBox"];
    text1 = @"朝世企业管理咨询（上海）有限公司是中国最大的白领拳击训练及活动的组织策划公司。我们通过举办白领拳击训练及正装白领拳击晚宴集结本土的拳击爱好者们。而我们的电视真人秀及即将推出的手机训练软件使得我们朝着进军中国其它城市的目标更进一步。\n\n我们的慈善活动已于上海、北京、澳门和台北成功举办。据初步统计，通过我们的白领拳击活动我们已为中国多个慈善机构筹得超过260万善款。\n\n我们对创意、质量和执行的严格把控及重视，以及和一些亚洲最好的合作伙伴的独家合作机会，使得我们成功推动了我们这场高影响力的白领拳击赛事。\n\n在2015年，我们进军了电视真人秀制作领域，8集电视真人秀节目“白领拳击赛”于该年6月在搜狐上映并获得了8百万的收视率。2016年，我们在优酷视频推出了第2季真人秀节目并获得超1千万的收视率。2017年，我们将继续在全国推出更多精彩的拳击真人秀节目！\n\n今年，我们亦会发布一款免费的拳击手机应用WeBox。这款应用为拳击健身群体，拳击新手以及进阶拳击手们提供了量身定制的拳击训练教程。WeBox的主旨是打造全球最大拳击社群";
    
        text2 = @"由中国白领拳击协会研发出品，WeBox是中国最大的拳击社群。这款免费的拳击手机应用为拳击健身群体，拳击新手以及进阶拳击手们提供了量身定制的拳击训练教程。应用包含了实用的训练课程，促进了拳击社群的建设，同时还提供了用户与WeBox认证教练训练的课程体验机会。WeBox的主旨是打造全球最大拳击社群。";
    }
    
    NSArray * detail_pay  = @[text1,text2];
    self.list_model = [[NSMutableArray alloc] init];
    for (int i= 0; i<[self.list_question count]; i++) {
        FAQModel * model = [[FAQModel alloc] init];
        model.str_context = [detail_pay objectAtIndex:i];
        model.isOpen = NO;
        
        FAQFrameModel * frame_model = [[FAQFrameModel alloc] init];
        frame_model.str_title = self.list_question[i];
        frame_model.model = model;
        [self.list_model addObject:frame_model];
    }
    
}

//初始化子View
-(void)initSubViews
{
    _tbv_about.delegate = self;
    _tbv_about.dataSource = self;
    [_tbv_about registerNib:[UINib nibWithNibName:@"FGAboutCell" bundle:nil] forCellReuseIdentifier:KFGAboutCell];
    _tbv_about.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark -------------------- TableView  DataSource & Delegate


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        
        return [self.list_model count];

    }
    else{
        return 1;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        
        FAQFrameModel * frameModel = [self.list_model objectAtIndex:indexPath.row];
        return frameModel.cellH;
    }
    else
    {
        return 60;
    }

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        
        FGAboutCell * cell = [tableView dequeueReusableCellWithIdentifier:KFGAboutCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lb_question.text = [self.list_question objectAtIndex:indexPath.row];
        cell.frame_model = [self.list_model objectAtIndex:indexPath.row];
        cell.str_imageName = self.arr_imageIcons[indexPath.row];
        cell.str_copyright = nil;
    return cell;
    }
    else
    {
        FGAboutCell * cell = [tableView dequeueReusableCellWithIdentifier:KFGAboutCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.lb_question.text = [self.list_question objectAtIndex:indexPath.row];
//        cell.frame_model = [self.list_model objectAtIndex:indexPath.row];
//        cell.str_imageName = self.arr_imageIcons[indexPath.row];
        cell.frame_model = nil;
        if(isChinese){
            cell.str_copyright = @"Copyright ©2008-2017\n朝世企业管理咨询（上海）有限公司";
        }
        else{
            cell.str_copyright = @"Copyright ©2008-2017\nChina Sports Promotions";
        }
         return cell;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FAQFrameModel * frame_model = [self.list_model objectAtIndex:indexPath.row];
        FAQModel * model = frame_model.model;
        model.isOpen = !model.isOpen;
        [frame_model setModel:model];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //    [tableView reloadData];
    }
    else
    {
        return;
    }

}


//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 100;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KMainWidth, 100)];
//    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, KMainWidth -50, 40)];
//    lable.numberOfLines = 0;
//    lable.textAlignment = NSTextAlignmentCenter;
//    lable.font = KFrameSubContentFont;
//    lable.textColor = KFramefotoLatte;
//    if(isChinese){
//       lable.text = @"Copyright ©2008-2017\n朝世企业管理咨询（上海）有限公司";
//    }
//    else{
//        lable.text = @"Copyright ©2008-2017\nChina Sports Promotions";
//    }
//
//    [footView addSubview:lable];
//    return footView;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
