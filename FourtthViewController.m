//
//  FourtthViewController.m
//  
//
//  Created by 丸山　咲 on 2014/09/16.
//
//

#import "FourtthViewController.h"
#import "ThirdViewController.h"
#import "AppDelegate.h"



@interface FourtthViewController ()
{
    //予算額/開始日
    NSString *_budgetPrice;
    NSString *_startDate;
    //予算額と開始日を入れる配列
    NSArray *_budgetArray;
    //予算額を入力するTextField
    UITextField *_budgetTextField;
    //開始日入力をするDatePicker
    UIDatePicker *_datePicker;
    //予算額決定ボタン/開始日決定ボタン
    UIButton *_doneButton;
    UIButton *_datePickerDoneButton;
    //TextField、DatePickerを乗せるmodalView
    UIView *_textView;
    UIView *_datePickerView;
    //広告
    ADBannerView *_adView;
    
    //YESの時広告を表示
    BOOL _isVisible;
    //YESの時_textView/_datePickerViewを表示
    BOOL _viewFlag;
    //YESの時、入力された予算額の値をメンバ変数に指定する
    BOOL _budgetFlag;


}

@end

@implementation FourtthViewController

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
    //選択した通貨をユーザーデフォルト_currencyDefaultsに書き込む
    NSUserDefaults *_currencyDefaults = [NSUserDefaults standardUserDefaults];
    //アップデリゲートをインスタンス化(カプセル化)
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    //Convertからデータを取り出し、アップデリゲートの_convertCurrencyにセットする
    app._convertCurrency = [_currencyDefaults objectForKey:@"Convert"];
    
    //この書き方でok??
    //デフォルトの換算通貨の設定をJPYにする
    if (app._convertCurrency == nil){
        [_currencyDefaults setObject:@"JPY" forKey:@"Convert"];
        [_currencyDefaults synchronize];
        app._convertCurrency = @"JPY";
    }

 
    ///ユーザーデフォルト_budgetDefaultsから予算額と開始日のデータを読み出す
    //ユーザーデフォルトを取得
    NSUserDefaults *_budgetDefaults = [NSUserDefaults standardUserDefaults];
    
    //値とキーをセットで取り出す
    NSString *budget = [_budgetDefaults stringForKey:@"Budget"];
    NSString *startdate = [_budgetDefaults stringForKey:@"Startdate"];

//    //budget/startdateを配列に入れて、%@に指定する
//    NSString *budgetNew = [NSString stringWithFormat:@"予算額:     %@  (%@)",budget, app._convertCurrency];
//    NSString *startdateNew = [NSString stringWithFormat:@"開始日       %@ ",startdateNew];
//    _budgetArray = @[budgetNew,startdateNew];
//    
////    _budgetArray =@[[NSString stringWithFormat:@"予算額(%@) %@",app._convertCurrency,budget],[NSString stringWithFormat:@"開始日 %@" ,startdate]];
//    
//    self.setBTableView.delegate = self;
//    self.setBTableView.dataSource = self;
//    
//    
////    //入力した内容を初期化する
////    [self.setBTableView reloadData];
//    
    
    
    
    if (!budget && !startdate) {      //予算☓　開始日☓（UserDefaultsにデータがはいってないとき)
        //通貨コードにアスタリスクをセット
        budget = @"予算額: 0";
        startdate = @"開始日: ----- ";
        //budget/startdateを配列に入れて、%@に指定する
//        NSString *budget = [NSString stringWithFormat:@"予算額:     %@  (%@)",budget, app._convertCurrency];
//        NSString *startdate = [NSString stringWithFormat:@"開始日       %@",startdate];
        
    } else if (!startdate){      //予算◯　開始日☓のとき
        //予算はUserdefaultのデータを使用
        budget = [NSString stringWithFormat:@"予算額 :     %@  (%@)",budget, app._convertCurrency];
        //開始日には---------をセット
        startdate = @"開始日: ----- ";
    } else if (!budget) {     //予算☓　開始日◯のとき
        //予算は０をセット
        budget = @"予算額: 0";
        //開始日にはUserdefaultのデータをセット
        startdate = [NSString stringWithFormat:@"開始日       %@",startdate];
    }else{      //予算も開始日もセットされているとき
        //どちらもUserdefaultのデータを表示
        budget = [NSString stringWithFormat:@"予算額 :     %@  (%@)",budget, app._convertCurrency];
        startdate = [NSString stringWithFormat:@"開始日 :       %@",startdate];
    }
    
    
    _budgetArray = @[budget,startdate];
    
    self.setBTableView.delegate = self;
    self.setBTableView.dataSource = self;
    
}



//画面が表示された時
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    ///広告
    //タブバーの高さと調べる
    CGFloat tabBarHeight = self.tabBarController.tabBar.bounds.size.height;
    CGFloat addViewHeight =_adView.frame.size.height;
//    NSLog(@"%f", tabBarHeight);
//    NSLog(@"%f", addViewHeight);
    //バナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 460, _adView.frame.size.width, _adView.frame.size.height)];
    _adView.delegate = self;
    [self.view addSubview:_adView];
    _adView.alpha =0.0;
    //フラグがNOの時にこの処理をする
    _isVisible = NO;
    
    
    //「予算額」を入力するためのテキストフィールドをmodalViewににのっけてにゅっと出す
    //modalViewを作成して
    _textView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 50)];
    //色の配合の仕方を調整
    _textView.backgroundColor = [UIColor colorWithRed:0.890  green:0.890 blue:0.890 alpha:1.0];
    //まだ隠れている状態＝NOの時、
    _viewFlag = NO;
    //このビューコントローラに乗せる
    [self.view addSubview:_textView];
    
    //テキストフィールドを作成
    _budgetTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-100, 40)];
    _budgetTextField.backgroundColor = [UIColor colorWithRed:0.890  green:0.890 blue:0.890 alpha:1.0];
    _budgetTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_budgetTextField addTarget:self action:@selector(tapReturn) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textView addSubview:_budgetTextField];
    [self.view addSubview:_textView];
    
    
    //テキストフィールド用のDoneボタンを作成してビューに追加
    _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 0, 100, 40)];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor colorWithRed: (46/255.0) green:(204/255.0) blue: (113/255.0) alpha:1] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:_doneButton];

    
    
    //「開始日」を入力するためのDatePickerをmodalViewにのせてにゅっとだす
    // DatePicker表示用のmodalViewを作成
    _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 50)];
    _datePickerView.backgroundColor = [UIColor colorWithRed:0.890 green:0.890 blue:0.890 alpha:1.0];
    //まだ隠れている状態＝NOとする
    _viewFlag = NO;
    [self.view addSubview:_datePickerView];
    // DatePickerをセット
    _datePicker = [UIDatePicker new];
    //DatePickerのスタイルを◯月/◯日/〇〇年にする
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    //DatePickerの時間をローカル時間に設定 →　デフォルト値に影響
    _datePicker.timeZone = [NSTimeZone systemTimeZone];
    
    // デフォルトの日付を「今日」に設定
    NSDate *today = [NSDate date];
    [_datePicker setDate:today];
    [_datePicker becomeFirstResponder];
    [_datePickerView addSubview:_datePicker];

    // DatePickerビューに_datePickerDoneButtonボタンを作成して追加
    _datePickerDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 0, 100, 40)];
    [_datePickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_datePickerDoneButton setTitleColor:[UIColor colorWithRed: (46/255.0) green:(204/255.0) blue: (113/255.0) alpha:1] forState:UIControlStateNormal];
    [_datePickerDoneButton addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerView addSubview:_datePickerDoneButton];
    
    
    //TableViewの余計な行の削除
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    //[self.tableView setTableHeaderView:view];
    [self.setBTableView setTableFooterView:view];
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
    if (section == 0) {
        return @"予算・日付設定";
    }
    return 0;

}



//行数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return _budgetArray.count;
    if (section == 0) {
        return 2;
    }
    return 0;
}


//セルに内容を表示するメソッド
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"cell";
    
    //セルの再利用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    //セルの初期化とスタイルの決定
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"行番号=%d",indexPath.row];
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = _budgetArray[indexPath.row];
    }
    

    return cell;
    
}


//セルが選択されたとき何を実行するか
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //テキストフィールドに残った文字を空にする
    _budgetTextField.text = @"";
    
    //TableViewの一行目がTapされた時
    if (indexPath.row == 0) {
        //DatePickerが残ってしまうから、DatePickerViewを閉じる
        [self closeDatePickerView];
        
        //modalView(_textView)をにゅっとだす
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        _textView.frame = CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 50);
        [UIView commitAnimations];
        //キーボードを最初から表示する
        [_budgetTextField becomeFirstResponder];
        
        
        _budgetFlag = YES;
        _viewFlag = YES;

        
    } else {
        //TextViewを閉じる
        [self closeTextView];
        
        _budgetFlag = NO;
        _viewFlag = YES;

        //modalView(_datePickerView)をにゅっとだす
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        _datePickerView.frame = CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 250);
        [UIView commitAnimations];
    }


    //ロング型の変数の中身を表示する文字列がld
//    NSLog(@"%ld",(long)indexPath.section);

}
    

//テキストフィールドがのっている_textViewを下げる自作メソッド
-(void)closeTextView
{
    //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
    _textView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
    
    //キーボードを下げる
    [_budgetTextField resignFirstResponder];
    
    _viewFlag = NO;
}

//DatePickerが乗っている_datePickerViewを下げる自作メソッド
- (void)closeDatePickerView
{
    //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _datePickerView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
    [UIView commitAnimations];
    
    _viewFlag = NO;
}


//DoneボタンがTapされた時にTableViewに予算額と開始日を表示する
-(void)tapBtn:(UIButton *)doneButton
{
    //ユーザーデフォルトを取得
    NSUserDefaults *_budgetDefaults = [NSUserDefaults standardUserDefaults];
    NSString *budget = [_budgetDefaults objectForKey:@"Budget"];
    NSString *startdate = [_budgetDefaults objectForKey:@"Startdate"];
    
    //選択した通貨をユーザーデフォルト_currencyDefaultsに書き込む
    NSUserDefaults *_currencyDefaults = [NSUserDefaults standardUserDefaults];
    //アップデリゲートをインスタンス化(カプセル化)
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    

    //Convertからデータを取り出し、アップデリゲートの_convertCurrencyにセットする
    app._convertCurrency = [_currencyDefaults objectForKey:@"Convert"];
    

    
    //viewを下げる
    [self closeTextView];
    [self closeDatePickerView];
    
    
    if (_budgetFlag == YES) {   //「_budgetFlag=YESの時」= setBTableViewの一行目（予算額の行）がTapされた時
        //入力された金額を_budgetPriceに代入
        budget = _budgetTextField.text;
        //予算額：値_budgetPriceと、キーBudgetを指定して_budgetDefaultsに書き込む
        [_budgetDefaults setObject:budget forKey:@"Budget"];
        
        if (!budget && !startdate) {      //予算☓　開始日☓（UserDefaultsにデータがはいってないとき)
            //通貨コードにアスタリスクをセット
            budget = @"予算額: 0";
            startdate = @"開始日: ----- ";
            //budget/startdateを配列に入れて、%@に指定する
            //        NSString *budget = [NSString stringWithFormat:@"予算額:     %@  (%@)",budget, app._convertCurrency];
            //        NSString *startdate = [NSString stringWithFormat:@"開始日       %@",startdate];
            
        } else if (!startdate){      //予算◯　開始日☓のとき
            //予算はUserdefaultのデータを使用
            budget = [NSString stringWithFormat:@"予算額 :     %@  (%@)",budget, app._convertCurrency];
            //開始日には---------をセット
            startdate = @"開始日: ----- ";
        } else if (!budget) {     //予算☓　開始日◯のとき
            //予算は０をセット
            budget = @"予算額: 0";
            //開始日にはUserdefaultのデータをセット
            startdate = [NSString stringWithFormat:@"開始日       %@",startdate];
        }else{      //予算も開始日もセットされているとき
            //どちらもUserdefaultのデータを表示
            budget = [NSString stringWithFormat:@"予算額 :     %@  (%@)",budget, app._convertCurrency];
            startdate = [NSString stringWithFormat:@"開始日 :       %@",startdate];
        }
        
        
        

    }else{      //二行目（開始日の行）がTapされた時
        //DatePickerで入力された日付（date型）をString型に変換し
        //_startdateに代入
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy/MM/dd"];
        startdate = [df stringFromDate:_datePicker.date];
        
        //開始日：値_startDateと、キーStartdateを指定して_budgetDefaultsに書き込む
        [_budgetDefaults setObject:startdate forKey:@"Startdate"];
        
        if (!budget && !startdate) {      //予算☓　開始日☓（UserDefaultsにデータがはいってないとき)
            //通貨コードにアスタリスクをセット
            budget = @"予算額: 0";
            startdate = @"開始日: ----- ";
            //budget/startdateを配列に入れて、%@に指定する
            //        NSString *budget = [NSString stringWithFormat:@"予算額:     %@  (%@)",budget, app._convertCurrency];
            //        NSString *startdate = [NSString stringWithFormat:@"開始日       %@",startdate];
            
        } else if (!startdate){      //予算◯　開始日☓のとき
            //予算はUserdefaultのデータを使用
            budget = [NSString stringWithFormat:@"予算額 :     %@  (%@)",budget, app._convertCurrency];
            //開始日には---------をセット
            startdate = @"開始日: ----- ";
        } else if (!budget) {     //予算☓　開始日◯のとき
            //予算は０をセット
            budget = @"予算額: 0";
            //開始日にはUserdefaultのデータをセット
            startdate = [NSString stringWithFormat:@"開始日       %@",startdate];
        }else{      //予算も開始日もセットされているとき
            //どちらもUserdefaultのデータを表示
            budget = [NSString stringWithFormat:@"予算額 :     %@  (%@)",budget, app._convertCurrency];
            startdate = [NSString stringWithFormat:@"開始日 :       %@",startdate];
        }
    }
    
        
        
    _budgetArray = @[budget,startdate];
        
    self.setBTableView.delegate = self;
    self.setBTableView.dataSource = self;
    //書き込んだデータを即反映
    [_budgetDefaults synchronize];
  
    //入力した内容を初期化して、TableViewを再作成する
    [self.setBTableView reloadData];
}


////SaveボタンがTapされた時
////入力した金額・日付をユーザーデフォルトに書き込む
//- (IBAction)tapSave:(id)sender {
//    
//    
//    //ユーザーデフォルトを取得
//    NSUserDefaults *_budgetDefaults = [NSUserDefaults standardUserDefaults];
//    //予算額：値_budgetPriceと、キーBudgetを指定して_budgetDefaultsに書き込む
//    [_budgetDefaults setObject:_budgetPrice forKey:@"Budget"];
//    //開始日：値_startDateと、キーStartdateを指定して_budgetDefaultsに書き込む
//    [_budgetDefaults setObject:_startDate forKey:@"Startdate"];
//    //書き込んだデータを即反映
//    [_budgetDefaults synchronize];
//    
//    
//    ///_budgetDefaultsのデータを読み出す
//    NSString *budget = [_budgetDefaults stringForKey:@"Budget"];
//    NSString *startdate = [_budgetDefaults stringForKey:@"Startdate"];
//    
//    //取り出したデータを%@に指定する
//    _budgetArray =@[[NSString stringWithFormat:@"予算額 %@",budget],[NSString stringWithFormat:@"開始日 %@",startdate]];
//     NSLog(@"%@",startdate);
//    
//    //入力した内容を初期化する
//    [self.setBTableView reloadData];
//    
//    
//}


//Cancelボタンが押された時
- (IBAction)tapCancel:(id)sender {
    
    //キーボードを下げる
    [self closeDatePickerView];
    [self closeTextView];
}



////広告
//-(void) bannerViewDidLoadAd:(ADBannerView *)banner
//{
////    [_adView setCenter:CGPointMake(self.view.bounds.size.width/2,self.view.bounds.size.height-_adView.bounds.size.height/2)];
//    //_isVisibleがNOの時（広告が表示されていないとき、この処理を実行）
//    if (!_isVisible) {
//            //「animateAdBannerOn」という名前のアニメーション
//            [UIView beginAnimations:@"animateAdBannerOn" context:nil];
//            //アニメーションの時間の間隔。大きければ大きいほどゆっくり
//            [UIView setAnimationDuration:0.3];
//            //「-(void) bannerViewDidLoadAd:(ADBannerView *)banner」のbannerと同じ
//            //banner.flame=「バナーの形」
//            banner.frame = CGRectOffset (banner.frame, 0, 20);
//            //透明度を0から1にして、見えるようにする
//            banner.alpha = 1.0;
//            [UIView commitAnimations];
//            //表示したので、isVisibleをYESにする
//            _isVisible = YES;
//    }
//}
//
//
////広告：エラーが発生した場合
//-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//    //エラーが発生したときに広告が表示されていたら、非表示にする
//    if (_isVisible) {
//        [UIView beginAnimations:@"animateAdBannerOff" context:nil];
//        [UIView setAnimationDuration:0.3];
//        banner.frame = CGRectOffset(banner.frame, 0, -CGRectGetHeight(banner.frame));
//        banner.alpha = 0.0;
//        [UIView commitAnimations];
//    }
//}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
                    
                    
