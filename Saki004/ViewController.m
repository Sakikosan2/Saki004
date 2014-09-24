//
//  ViewController.m
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "ViewController.h"
#import "RDVDayCell.h"


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
    
    [[self calendarView] registerDayCellClass:[RDVDayCell class]];
    
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", nil)
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:[self calendarView]
                                                                   action:@selector(showCurrentMonth)];
    [self.navigationItem setRightBarButtonItem:todayButton];

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

@end
