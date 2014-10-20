//
//  ViewController.h
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVCalendarViewController.h"


@interface ViewController : RDVCalendarViewController


@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastwithdrawalLabel;

@end
