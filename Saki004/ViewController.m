//
//  ViewController.m
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "ViewController.h"
#import "RDVDayCell.h"
#import "SecondViewController.h"


//@interface ViewController ()

//@end

@implementation ViewController


//カレンダーライブラリを追加する
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Calendar";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[self.navigationController navigationBar] setTranslucent:NO];
    
    //カレンダーを読み込んで表示
    [[self calendarView] registerDayCellClass:[RDVDayCell class]];
    
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", nil)
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:[self calendarView]
                                                                   action:@selector(showCurrentMonth)];
    [self.navigationItem setRightBarButtonItem:todayButton];



    //口座残高と前回引き出し日のラベルを表示させる
    UILabel *balanceLabal = [[UILabel alloc]init];
    
    balanceLabal.frame = CGRectMake(20, self.view.bounds.size.height -90, 200, 20);
    
    balanceLabal.text = @"口座残高";
    
    [[self calendarView] addSubview:balanceLabal];
    
    UILabel *lastwithdrawalLabel = [[UILabel alloc] init];
    lastwithdrawalLabel.frame = CGRectMake(20, self.view.bounds.size.height -60, 200, 20);
    
    lastwithdrawalLabel.text = @"前回引き出し日";
    
    [[self calendarView] addSubview:lastwithdrawalLabel];
    
}


//カレンダーから画面遷移する
//選んだ日付を*dateに入れる
-(void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    NSLog(@"%@",date);
    
    SecondViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MM/dd"];
    
    svc.selectedDate = [df stringFromDate:date];
    
    
    [self presentViewController:svc animated:YES completion:nil];
    
    
    
    }
    

- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
             atIndex:(NSInteger)index {
    RDVDayCell *exampleDayCell = (RDVDayCell *)dayCell;
    if (index % 5 == 0) {
        [[exampleDayCell notificationView] setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openSecondScene:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Second Scene" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open!", nil];
    [alertView show];
}

//-(void) modalViewWillClose{
//    NSLog(@"close");
//    [self dismissModalViewControllerAnimated:YES];
//}




@end
