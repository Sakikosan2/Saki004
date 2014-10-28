//
//  SecondViewController.m
//  Saki003
//
//  Created by 丸山　咲 on 2014/09/10.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "FourtthViewController.h"
#import "Withdrawalmemo.h"
#import "ViewController.h"

//@implementation openview
//@synthesize delegate;
//
//- (void)dealloc
//{
//    [super dealloc];
//}
//
//
//@end

@interface SecondViewController ()
{
    //バナー広告
    ADBannerView *_adView;
    //テキストフィールドを乗せるView
    UIView *_textView;
    //引き出し額を入力するテキストフィールド
    UITextField *_withdrawalTextField;
    //Doneボタンをメンバ変数にする
    UIButton *_doneButton;
    //引き出し額と手数料額のメンバ変数
    NSString *_withdrawalPrice;
    NSString *_commissionPrice;
    
    //TableView
    NSArray *_withdrawalArray;
    
//    //
//    NSString *selectedDate;
    
    BOOL _viewFlag;
    BOOL _isVisible;
    BOOL _withdrawalFlag;
    
}


@end

@implementation SecondViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{

//    //入力されたデータがない場合は「０」を表示
//    if (_withdrawalPrice ==nil) {
//    
//        _withdrawalArray =@[@"引き出し額:    0",@"手数料:           0"];
//        self.withdrawalTableView.delegate = self;
//        self.withdrawalTableView.dataSource = self;
//        
//    }else{
//        //入力されたデータがあるときは、引き出し額と手数料額を表示
//            //引き出し額が入力された時とで分岐すべき？}
//

    NSString *withdrawalPrice = [NSString stringWithFormat:@"引き出し額: %@",_withdrawalPrice];
    NSString *commissionPrice = [NSString stringWithFormat:@"手数料: %@",_commissionPrice];
    _withdrawalArray =@[withdrawalPrice, commissionPrice];
        
    self.withdrawalTableView.delegate = self;
    self.withdrawalTableView.dataSource = self;
    
    
    //入力した内容を初期化する
    [self.withdrawalTableView reloadData];
    
    //TableViewの余計な行の削除
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    //[self.tableView setTableHeaderView:view];
    [self.withdrawalTableView setTableFooterView:view];

}
        


//画面が表示された時
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //今日の日付をラベルに表示
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd"];

    self.todayLabel.text = [df stringFromDate:self.selectedDate];
    
    
    //TableView
    _withdrawalArray =@[@"引き出し額",@"手数料"];
    self.withdrawalTableView.delegate = self;
    self.withdrawalTableView.dataSource = self;
    
    //TableViewの余計な行の削除
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    //[self.tableView setTableHeaderView:view];
    [self.withdrawalTableView setTableFooterView:view];
    
    
    //modalViewを作成
    _textView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 50)];
    //色の配合の仕方を調整
    _textView.backgroundColor = [UIColor colorWithRed:0.192157 green:0.760784 blue:0.952941 alpha:0.2];
    //まだ隠れている状態＝NOとする
    _viewFlag = NO;
    [self.view addSubview:_textView];
    

    
    //テキストフィールドを_textViewの上に作成
    _withdrawalTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-100, 40)];
    _withdrawalTextField.backgroundColor = [UIColor grayColor];
    _withdrawalTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_textView addSubview:_withdrawalTextField];
    [self.view addSubview:_textView];
    
    
    //Doneボタンを作成
    _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 0, 100, 40)];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:_doneButton];
    

    //バナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, _adView.frame.size.width, _adView.frame.size.height)];
    _adView.delegate = self;
    //アドビューをつくる
    [self.view addSubview:_adView];
    //透明度を0にする
    _adView.alpha =0.0;
    //フラグがNOの時にこの処理をする
    _isVisible = NO;
    
    
    
    // CoreDataのコンテクストをAppDelegateから取得する
    _managedObjectContext = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;


}

//TableView
//セクション数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


//セクションのタイトル文字
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"引き出し額入力";
    
}


//行数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _withdrawalArray.count;
    
}


//セルに内容を表示するメソッド
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"cell";
    
    //セルの再利用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    
    //background用のviewを生成
    UIView *selectionColor = [UIView new];
    
    //生成したviewのbackgroundColorに任意の色を設定
    selectionColor.backgroundColor = [UIColor greenColor];
    
    //生成したbackgroundView用のviewを設定する
    cell.selectedBackgroundView = selectionColor;
    
    //セルの初期化とスタイルの決定
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"行番号=%d",indexPath.row];
    cell.textLabel.text = _withdrawalArray[indexPath.row];
    
    

    
    
    return cell;
    
}

//Viewを下げる自作メソッド
-(void)downObjects
{
    //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
    _textView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
    //キーボードを下げる
    [_withdrawalTextField resignFirstResponder];
    _viewFlag = NO;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //テキストフィールドに残った文字を空にする
    _withdrawalTextField.text = @"";
    
    //modalViewをにゅっとだすよ
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    //キーボードを下げる
    [self downObjects];
    _textView.frame = CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 250);
    
    [UIView commitAnimations];
    
    
    //キーボードを最初から表示する
    [_withdrawalTextField becomeFirstResponder];
    

    
    if (indexPath.row ==0) {
        
        _withdrawalFlag = YES;
    }
    else
    {
        _withdrawalFlag = NO;
    }
    _viewFlag = YES;


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
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"withdrawaldate" ascending:NO]]];
        
    //fechedResultControllerの初期化
    //「cache」同じキャッシュの場合、削除する。cachenemaはなんでも可。
    _fetchedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        
    NSError *error = nil;
    if (![_fetchedResultController performFetch:&error]) {  //「＆」データの参照渡し：errorにnilを入れてるよ
            abort();
    }
        
        return _fetchedResultController;
}

    
//NSLog(@"hogehogehoge");
//    
//        //データが入っているとき = そのデータをそのまま返す
//        if (_fetchedResultController) {
//            return _fetchedResultController;
//            
//        }
//        
//        //nilのとき
//        NSEntityDescription *Withdrawalmemo = [NSEntityDescription entityForName:@"Withdrawalmemo" inManagedObjectContext:self.managedObjectContext];
//    
//        //一行ずつデータを取得する
//        NSFetchRequest *fetchRequest = [NSFetchRequest new];
//        
//        //なんのモデルを取り出すのかを指定。FetchRequestはEntityじゃないとだめ。
//        [fetchRequest setEntity:Withdrawalmemo];
//        
//        //一度にコアデータの中から何データをとってくるか（コアデータから何件ずつとってくるかをかくだけ）
//        [fetchRequest setFetchBatchSize:20];
//        
//        //そのリストをどんな順序で並べるのか　ascending:並べ方　Yes:昇順、No:降順
//        //条件を複数個指定できるため、配列型
//        [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"withdrawaldate" ascending:NO],]];
//    
//        //fechedResultControllerの初期化
//        //「cache」同じキャッシュの場合、削除する。cachenemaはなんでも可。
//        _fetchedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"ViewController"];
//        
//        
//        _fetchedResultController.delegate = self;
//        return _fetchedResultController;
//}


//広告
-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{// 広告をビューの一番下に表示する場合
    
    //if文をつくる.isVisibleの中がNOだったときにこの中の処理をする。
    if (!_isVisible) {
        //バナーが表示されるアニメーション。落ちてくる。
        
        //「animateAdBannerOn」という名前のアニメーション
        [UIView beginAnimations:@"animateAdBannerOn" context:nil];
        
        //アニメーションの時間の間隔。大きければ大きいほどゆっくり
        [UIView setAnimationDuration:0.3];
        
        //「-(void) bannerViewDidLoadAd:(ADBannerView *)banner」のbannerと同じ
        //banner.flame=「バナーの形」
        banner.frame = CGRectOffset(banner.frame, 0, self.view.bounds.size.height - banner.frame.size.height);
        //banner.frame = CGRectOffset(banner.frame, 0, 300);
        
        
        //透明度を0から1にして、見えるようになった。
        banner.alpha = 1.0;
        
        //beginAnimations に対して、　commitAnimations でここで終わり！って意味
        [UIView commitAnimations];
        
        //表示したので、isVisibleをYESにする
        _isVisible = YES;
    }
    
}

//広告でエラーが発生した場合
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //エラーが発生したときに広告が表示されていたら、非表示にする
    if (_isVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:nil];
        
        [UIView setAnimationDuration:0.3];
        
        banner.frame = CGRectOffset(banner.frame, 0, -CGRectGetHeight(banner.frame));
        
        banner.alpha = 0.0;

        [UIView commitAnimations];
    }
}


//キャンセルボタンがTapされたとき
- (IBAction)tapCancel:(id)sender {

    
    [self dismissViewControllerAnimated:YES completion:nil];

}

//Doneボタンが押された時
-(IBAction)tapBtn:(id)sender
{
    //入力した金額をメンバ変数に保存
    if (_withdrawalFlag == YES) {
        _withdrawalPrice = _withdrawalTextField.text;
        
    }
    else{
        _commissionPrice = _withdrawalTextField.text;
    }
    
    //キーボードを下げる
    [self downObjects];
    
    //取り出した引き出し額と手数料のメンバ変数を%@に指定する
    _withdrawalArray =@[[NSString stringWithFormat:@"引き出し額 %@",_withdrawalPrice],[NSString stringWithFormat:@"手数料 %@",_commissionPrice]];
    
    //入力した内容を初期化する
    [self.withdrawalTableView reloadData];

}


//保存ボタンが押された時
//予算が変更された時に変更後の予算から再スタートする
//コアーデータのstartdateとUserdefaultのstardateを比較：一緒かどうか
//一緒の場合：accountresult -の計算結果を出す
//違う場合：新しい予算額をUserdefaultからとってきて計算しなおす

-(IBAction)tapSave:(id)sender{
    
    //Userdefaultのstartdateの呼び出し
    NSUserDefaults *_budgetDefaults = [NSUserDefaults standardUserDefaults];
    NSString *startdate = [_budgetDefaults stringForKey:@"Startdate"];
    NSLog(@"stardate=%@",[_budgetDefaults objectForKey:@"Startdate"]);
    
    
    //UserDefaultに保存したデータを使って口座残高を計算
    //_budgetdefaultから_budgetPriceを読み出す
    
    //キーを指定して値を読み出す
    NSString *budget = [_budgetDefaults stringForKey:@"Budget"];
    
    //_currencySettinsの中からrateを取り出す
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *currencySettings = [userDefaults objectForKey:@"currencyDefault"];
    NSString *rate = [currencySettings objectForKey:@"rate"];
    
    // withdrawalpriceとcommissionpriceをfloat型に変換
    CGFloat calculateWithdrawalPrice = [_withdrawalPrice floatValue];
    CGFloat calculateCommissionPrice = [_commissionPrice floatValue];
    //rateをfloat型に変換
    CGFloat calculateRate = [rate floatValue];
    //*budgetをfloat型に変換
    CGFloat calculateBudget = [budget floatValue];
    CGFloat accountResult;

    //口座残高 = {(引き出し額×レート)+(手数料額×レート)}
    //NSString *acountResult = [calculateBudget- ((_withdrawalPrice * calculateRate) + (_commissionPrice * calculateRate))];
    //引き出し額×レート
    CGFloat a = calculateWithdrawalPrice * calculateRate;
    NSLog(@"引き出し額×レート= %f",a);
    //手数料×レート
    CGFloat b = calculateCommissionPrice * calculateRate;
    NSLog(@"手数料×レート = %f",b);
    
    //a + b = calculateWholeWithdrawalPrice
    //ceilfで小数点以下を切り上げ/floorfで切り捨て/roundfで四捨五入
    CGFloat calculateWholeWithdrawalPrice = ceilf(a + b);
    NSLog(@"a+b = %f",calculateWholeWithdrawalPrice);

    
    if (self.withdrawalmemo) {
        if(self.withdrawalmemo.startdate == startdate){      //Userdefault=CoreData
            //口座残高 = {(引き出し額×レート)+(手数料額×レート)}
            //CoreDataのaccountresult - 総引き出し額
            CGFloat accountResultCoredata = [self.withdrawalmemo.accountresult floatValue];
            
            // Coredataの残高から今回使った合計金額を引き算して新しい残額を取得
            accountResult = accountResultCoredata - calculateWholeWithdrawalPrice;
        }else{
            //CoredataのstartdateとUserdefaultのstartdateが違うとき
            // =新しく開始日と予算が設定された時
            
            //予算額budge - calculateWholeWithdrawalPrice = calculateResult
            accountResult = calculateBudget - calculateWholeWithdrawalPrice;
            NSLog(@"口座残高は = %f",accountResult);
        }
    } else {
        // そもそもCoredataに一つもデータがない、初回の支出額入力の場合は、Userdefaultの予算額から引き算する
        accountResult = calculateBudget - calculateWholeWithdrawalPrice;
    }

   
    //CoreDataにセットするデータが呼び出せるかを確認
    NSLog(@"acountresult = %f",accountResult);
    NSLog(@"rate = %f",calculateRate);
    NSLog(@"withdrawalprice = %@",_withdrawalPrice);
    NSString *withdrawalcurrency = [currencySettings objectForKey:@"localCurrencyCode"];
    NSLog(@"withdrawalcurrency = %@",withdrawalcurrency);
    NSLog(@"withdrawaldate = %@",self.selectedDate);
    NSLog(@"commissionprice = %@",_commissionPrice);
    NSString *convertcurrency = [currencySettings objectForKey:@"convertCurrencyCode"];
    NSLog(@"convertcurrency = %@",convertcurrency);
    NSLog(@"startdate = %@",startdate);
    
    //データをCoreDataにいれる
    //生成時にEntitiy名を指定して、どのEntity（テーブル）に登録するのかを指定
    Withdrawalmemo *withdrawalmemo =[NSEntityDescription insertNewObjectForEntityForName:@"Withdrawalmemo" inManagedObjectContext:_managedObjectContext];
 
    
    // 作成したNSManagedObjectインスタンス(withdrawalmemo)に値を設定する
    //int型float型はNSNumber型に保存してからでないとNSManagedObjectに保存できない:float型の変数→Number型に変換
    NSNumber *accountResultNew = [NSNumber numberWithFloat:accountResult];  //?変換できてない
    NSNumber *calculateRateNew = [NSNumber numberWithFloat:calculateRate];
    //string型→Number型の時は一度int型に変換してからNumber型にする
    NSNumber *withdrawalPriceNew  = [NSNumber numberWithInt:[_withdrawalPrice intValue]];
    NSNumber *commissionPriceNew  = [NSNumber numberWithInt:[_commissionPrice intValue]];
    //date型→string型　（date型の時はそのまま突っ込んでOK）
    
    //withdrawalmemoにキーを指定して値をセット
    [withdrawalmemo setValue:accountResultNew   forKey:@"accountresult"];       //口座残高
    [withdrawalmemo setValue:calculateRateNew forKey:@"rate"];                  //レート
    [withdrawalmemo setValue:withdrawalPriceNew forKey:@"withdrawalprice"];     //引き出し額
    [withdrawalmemo setValue:commissionPriceNew forKey:@"commissionprice"];     //手数料額
    [withdrawalmemo setValue:convertcurrency forKey:@"convertcurrency"];        //換算通貨
    [withdrawalmemo setValue:withdrawalcurrency forKey:@"commissioncurrency"];  //手数料通貨(引き出し通貨と同じ)
    [withdrawalmemo setValue:self.selectedDate forKey:@"withdrawaldate"];       //引き出し日
    [withdrawalmemo setValue:withdrawalcurrency forKey:@"withdrawalcurrency"];  //引き出し通貨
    [withdrawalmemo setValue:startdate forKey:@"startdate"];                    //予算(記録)開始日

    // 作成したNSManagedObjectをDBに保存
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"error = %@", error);
    } else {
        NSLog(@"Insert Completed.");
    }
    
    //親画面(ViewController)に戻る→ホントはdelegateメソッドでやりたい
    [self dismissViewControllerAnimated:YES completion:nil];
 
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


@end

