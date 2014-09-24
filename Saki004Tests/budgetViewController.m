//
//  budgetViewController.m
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/16.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "budgetViewController.h"
//#import "AppDelegate.h"

@interface budgetViewController ()

@end

@implementation budgetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//ユーザーデフォルト
- (IBAction)tapYosangaku:(id)sender {
    
    
    //UserDefaultを宣言する
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    
    [myDefaults
     setObject:self.yosangaku.text forKey:@"Yosangaku"];
    
    
    //データを保存
    [myDefaults synchronize];
    //returnをおした時に保存されるから、押さなかったら保存されない
    
}

- (IBAction)tapKyuyogaku:(id)sender {
    
    //UserDefaultを宣言する
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    
    [myDefaults
     setObject:self.kyuyogaku.text forKey:@"Kyuyogaku"];
    
    
    //データを保存
    [myDefaults synchronize];
    //returnをおした時に保存されるから、押さなかったら保存されない
    
}

- (IBAction)tapKyuryoubi:(id)sender {
    
    
    //UserDefaultを宣言する
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    
    [myDefaults
     setObject:self.kyuryoubi.text forKey:@"Kyuryoubi"];
    
    
    //データを保存
    [myDefaults synchronize];
    //returnをおした時に保存されるから、押さなかったら保存されない
    
}
@end
