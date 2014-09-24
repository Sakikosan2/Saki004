//
//  dateViewController.m
//  
//
//  Created by 丸山　咲 on 2014/09/16.
//
//

#import "dateViewController.h"
#import "FourtthViewController.h"


@interface dateViewController ()
{
    NSString *_Kyuroubi;
    
}

@end

@implementation dateViewController

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


//決定ボタンを押すと元画面に遷移

- (IBAction)tapBtn:(id)sender {


    FourtthViewController *fourthViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FourthViewController"];
    
     [[self navigationController] pushViewController:fourthViewController animated:YES];
    
    
    //UserDefaultを宣言する
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    
    [myDefaults setObject:_Kyuroubi forKey:@"Kyuryoubi"];
 
    
    //データを保存
    [myDefaults synchronize];
    
    
    
    
}

//DatePickerで選んだ日付を出力
-(IBAction)changeDatetime:(id)sender {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy/MM/dd"];
    
    _Kyuroubi = [df stringFromDate:_datePicker.date];
    
    NSLog(@"%@",_Kyuroubi);
    
    
}

@end
