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
#import "Withdrawalmemo.h"

@interface ViewController ()

@property (nonatomic) Withdrawalmemo *withdrawalmemo;

@end

@implementation ViewController

@synthesize fetchedResultController = _fetchedResultController;

//カレンダーライブラリを追加する
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Calendar";
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    //CoreDataにデータがあるとき、ないときで分岐
    NSArray *withdrawalmemos = [self.fetchedResultController fetchedObjects];
    if ([withdrawalmemos count] > 0) {
        // 最新のwithdrawalmemoのデータを取得
        self.withdrawalmemo = withdrawalmemos[0];

        // Coredataのデータがあるときの残高表示
        // accountresultをNSString型にする
        NSString *strAccountresult = [NSString stringWithFormat:@"口座残高:     %@ (%@)",[self.withdrawalmemo accountresult],[self.withdrawalmemo convertcurrency]];
        self.balanceLabel.text = strAccountresult;

        //withdrawaldateをNSString型にする
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy/MM/dd"];
        NSString * strWithdrawaldate = [df stringFromDate:[self.withdrawalmemo withdrawaldate]];
        self.lastwithdrawalLabel.text = [NSString stringWithFormat:@"前回引き出し日:       %@", strWithdrawaldate];
    } else {
        // アプリ初回起動時など、Coredataのdataがない時の残高表示
        self.balanceLabel.text = @"口座残高:        0";

        //口座残高をラベルに表示
        // アプリ初回起動時など、Coredataのdataがない時の引き出し日表示（デフォルトで今日）
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy/MM/dd"];
        NSString *today = [df stringFromDate:[NSDate new]];
        self.lastwithdrawalLabel.text = [NSString stringWithFormat:@"前回引き出し日:       %@", today];
    }
    return;
    
}

- (void)viewDidLoad
{
        //ボタンアイコンの色を緑にする
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:(46/255.0) green:(204/255.0) blue:(113/255.0) alpha:1]];
    
        //タブのフォントを指定
        UIFont *font = [UIFont systemFontOfSize:10.0f];
    
        //タブのタイトル色指定
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    
    
       //タブのタイトル色指定(選択中)
       [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:(46/255.0) green:(204/255.0) blue:(113/255.0) alpha:1], UITextAttributeTextColor,nil] forState:UIControlStateSelected];

    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[self.navigationController navigationBar] setTranslucent:NO];
    
    
    //カレンダーを読み込んで表示
    [[self calendarView] registerDayCellClass:[RDVDayCell class]];
    
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc]
                                    initWithTitle:NSLocalizedString(@"Today", nil)
                                    style:UIBarButtonItemStylePlain
                                    target:[self calendarView]
                                    action:@selector(showCurrentMonth)];
    
    
    [self.navigationItem setRightBarButtonItem:todayButton];
    
    
    
    // CoreDataのコンテクストをAppDelegateから取得する
    _managedObjectContext = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;

    
    //- (NSFetchedResultsController *)fetchedResultControllerのメソッドを実行
//    NSLog(@"%@", [(Withdrawalmemo *)[self.fetchedResultController fetchedObjects][0] withdrawaldate]);  //fetchedObjectsで配列にする
//    NSLog(@"%@", [(Withdrawalmemo *)[self.fetchedResultController fetchedObjects][0] accountresult]);
 

    //口座残高と前回引き出し日のラベルタイトルを表示
    self.balanceLabelText =[UILabel new];
//    self.balanceLabelText.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    

    //口座残高と前回引き出し日の結果ラベルを表示させる
    self.balanceLabel = [UILabel new];
    self.balanceLabel.frame = CGRectMake(20, self.view.bounds.size.height -90, 300, 20);
    self.balanceLabel.text = @"口座残高";
    [[self calendarView] addSubview:self.balanceLabel];
    
    self.lastwithdrawalLabel = [UILabel new];
    self.lastwithdrawalLabel.frame = CGRectMake(20, self.view.bounds.size.height -60, 300, 20);
    self.lastwithdrawalLabel.text = @"前回引き出し日";
    [[self calendarView] addSubview:self.lastwithdrawalLabel];
    
}



//カレンダーのセルがTapされたとき
-(void)calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    //アラート　＋　画面遷移しないように
    //Userdefaultにデータがあるかどうかを確認
    
    //Userdefaultを呼び出す
    NSUserDefaults *_budgetDefaults = [NSUserDefaults standardUserDefaults];

    
    //currencySettings
    //budget / rate　取り出す
    //_budgetdefaultから_budgetPriceを読み出す
    NSString *budget = [_budgetDefaults stringForKey:@"Budget"];
    
    //_currencySettinsの中からrateを取り出す
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *currencySettings = [userDefaults objectForKey:@"currencyDefault"];
    NSString *rate = [currencySettings objectForKey:@"rate"];
    

    
    if (currencySettings == nil) {  //予算もレートもnilの時
        // UIAlertViewを使ってアラートを表示
        UIAlertView *setAlert = [[UIAlertView alloc] initWithTitle:@"通貨・予算を設定してください"
                                                           message:nil
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
        [setAlert show];
        
        
        //通貨設定画面（タブバーコントローラーの２番目のタブに遷移
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];

        
    }else if ( rate == nil){   //rateがないとき
        //アラートを表示
        // UIAlertViewを使ってアラートを表示
        UIAlertView *setAlert = [[UIAlertView alloc] initWithTitle:@"通貨を設定してください"
                                                           message:nil
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
        [setAlert show];

        //通貨設定画面（タブバーコントローラーの２番目のタブに遷移)
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        
        
    }else if( budget == nil){    //budgetがないとき
        // UIAlertViewを使ってアラートを表示
        UIAlertView *setAlert = [[UIAlertView alloc] initWithTitle:@"通貨・予算を設定してください"
                                                           message:nil
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
        [setAlert show];

        
        //予算設定画面（タブバーコントローラーの3番目のタブに遷移)
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
        
    }else{  //4 全部あるとき
        //SecondViewControllerへ画面遷移する
        //画面オブジェクトのインスタンス化(カプセル化)
        SecondViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
        //日付はdata型だからそのままでいい　→保存するときはフルのデータで保存！
        //NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //[df setDateFormat:@"MM/dd"];
        svc.selectedDate = date;
        svc.withdrawalmemo = self.withdrawalmemo;
        [self presentViewController:svc animated:YES completion:nil];
    }
   
}



/*********データがある箇所に青い■をつける************************************************************************/
//カレンダーの日付の印を表示するかどうか :　しない
- (void)calendarView:(RDVCalendarView *)calendarView configureDayCell:(RDVCalendarDayCell *)dayCell
    atIndex:(NSInteger)index {
    RDVDayCell *exampleDayCell = (RDVDayCell *)dayCell;
    
    //すべての日付をNSDateViewでとってくる
    //setHidden=YESにする
    if (index) {
        [[exampleDayCell notificationView] setHidden:YES];
    }

//    if ([(Withdrawalmemo *)[self.fetchedResultController fetchedObjects][0] withdrawaldate]) {
//        [exampleDayCell notificationView setHidden:nil];
//        
//    }
//    
//    dayCell *exampleDayCell = (dayCell *)daycell;
//    
//    if ([[appDelegate.p_Month allKeys]containsObject:[NSString stringWithFormat:@"Day:%ld",(long)index-1]]) {
//        [[exampleDayCell notificationView] setHidden:NO];}
    
}


-(NSString*)setDayStringForKey:(RDVCalendarView *)calendarView didSelectCellAtIndex:(NSInteger)index{
    
    NSInteger year = calendarView.month.year;
    NSInteger month = calendarView.month.month;
    NSInteger day = index+1;
    
    NSInteger modMonth = month % 12;
    NSInteger addYear = month /12;
    
    if (addYear > 0) {
        month = modMonth;
        year = year + addYear;
    }
    
    NSString *strReturn = [NSString stringWithFormat:@"%ld%ld%ld",(long)year,(long)month,(long)day];
    return strReturn;
}

/*********データがある箇所に青い■をつける　ここまで*************************************************************/



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//??
- (IBAction)openSecondScene:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Second Scene" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open!", nil];
    [alertView show];
}

//CoreData
- (NSFetchedResultsController *)fetchedResultController
{
    //コアデータにアクセスするために必要なcontextを取得
    NSManagedObjectContext *context = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    //nilのとき
    NSEntityDescription *Withdrawalmemo = [NSEntityDescription entityForName:@"Withdrawalmemo" inManagedObjectContext:context];
    
    //一行ずつデータを取得する
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    //なんのモデルを取り出すのかを指定。FetchRequestはEntityじゃないとだめ。
    [fetchRequest setEntity:Withdrawalmemo];
    //一度にコアデータの中から何データをとってくるか（コアデータから何件ずつとってくるかをかくだけ）
    [fetchRequest setFetchBatchSize:20];
    //そのリストをどんな順序で並べるのか　ascending:並べ方　Yes:昇順、No:降順
    //条件を複数個指定できるため、配列型
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO]]];
    
//    条件を指定してとってくる
//    NSPredicate *pred
//    = [NSPredicate predicateWithFormat:@"withdrawaldate = %@ or rate = %@ or withdrawalcurrency = %@", @"withdrawalcurrency", @"convertcurrency", @"commissioncurrency"];
//    [fetchRequest setPredicate:pred];

    
    //fechedResultControllerの初期化
    //「cache」同じキャッシュの場合、削除する。cachenemaはなんでも可。
    _fetchedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![_fetchedResultController performFetch:&error]) {  //「＆」データの参照渡し：errorにnilを入れてる
        abort();
    }
    
    return _fetchedResultController;
}




//-(void) modalViewWillClose{
//    NSLog(@"close");
//    [self dismissModalViewControllerAnimated:YES];
//}




@end
