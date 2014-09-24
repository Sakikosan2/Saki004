//
//  budgetViewController.h
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/16.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface budgetViewController : UIViewController
- (IBAction)tapYosangaku:(id)sender;
- (IBAction)tapKyuyogaku:(id)sender;
- (IBAction)tapKyuryoubi:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *yosangaku;
@property (weak, nonatomic) IBOutlet UITextField *kyuyogaku;
@property (weak, nonatomic) IBOutlet UITextField *kyuryoubi;


@end
