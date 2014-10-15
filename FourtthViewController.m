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
    UIView *_textView;
    UIView *_datePickerView;
    UIView *_dateView;
    
    BOOL _viewFlag;


    //ボタンの状態が変わった時に、その時の状態を知る目印
    //Viewを表示してる時はYES、非表示のときはNO
    
    UITextField *_budgetTextField;
    
    //Doneボタンをメンバ変数にする
    UIButton *_doneButton;
    UIButton *_datePickerDoneButton;
    //→ViewDidLoadのローカル変数を書き換える。データ型を削除して、置き換える
    UIDatePicker *_datePicker;
    
    NSArray *_budgetArray;
    
    //広告
    ADBannerView *_adView;
    
    BOOL _isVisible;

    //予算をユーザーデフォルトに保存
    BOOL _budgetFlag;
    
    //Alertを一回しか出さない
    BOOL _alertFlag;
    
    
    
    
    //予算額と開始日をメンバ変数に設定
    NSString *_budgetPrice;
    NSString *_startdate;
    
    
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

//通貨設定が済んでいるかどうかのalertView
-(void)viewWillAppear:(BOOL)animated
{
    //選択した通貨をユーザーデフォルトに保存
    NSUserDefaults *_currencyDefaults = [NSUserDefaults standardUserDefaults];
    
    _alertFlag = [_currencyDefaults boolForKey:@"isShownCurrencySelectAlert"];
    
    //アップデリゲートをインスタンス化(カプセル化)
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    
    if(!_alertFlag)
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通貨設定は済んでいますか？" message:@"通貨設定画面で設定できます" delegate:self cancelButtonTitle:@"いいえ、これからです" otherButtonTitles:@"はい、済んでいます", nil];
        
        [alert show];
        _alertFlag = YES;
        
        
    }
//    }else{
//        //_alertFlag がYESの時
//        _alertFlag = [_currencyDefaults boolForKey:@"isShownCurrencySelectAlert"];
//        //選択した通貨をユーザーデフォルトに保存
//        [_currencyDefaults setBool:_alertFlag forKey:@"isShownCurrencySelectAlert"];
//        
//        
//        
//    
//    }
    //Convertからデータを取り出し、左辺にセットする
    app._convertCurrency = [_currencyDefaults objectForKey:@"Convert"];
    
    //デフォルトの通過設定をJPYにする
    if (app._convertCurrency == nil){
        
        [_currencyDefaults setObject:@"JPY" forKey:@"Convert"];
    
        [_currencyDefaults synchronize];
    
        app._convertCurrency = @"JPY";
    }

    //ユーザーデフォルトで入力したデータを取り出す
    //ローカル変数。別々のmethodに同じ変数をセットしてもエラーにならない
    NSUserDefaults *_budgetDefaults = [NSUserDefaults standardUserDefaults];
    
    //ハコからデータをとりだす
    NSString *budget = [_budgetDefaults stringForKey:@"Budget"];
    NSString *startdate = [_budgetDefaults stringForKey:@"Startdate"];
    
    //取り出したデータを%@に指定する
    _budgetArray =@[[NSString stringWithFormat:@"予算額(%@) %@",app._convertCurrency,budget],[NSString stringWithFormat:@"開始日 %@",startdate]];
    
    
    
    self.setBTableView.delegate = self;
    self.setBTableView.dataSource = self;
    
//    //入力した内容を初期化する
//    [self.setBTableView reloadData];
    
    


    
    
}

//alertViewが選択された時の処理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //「いいえ」が選択されたとき
            NSLog(@"いいえ");

            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
            
            break;
        }
        case 1:
        {
     
            break;
        }
    }
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
//広告
    //バナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -_adView.frame.size.height, _adView.frame.size.width, _adView.frame.size.height)];
    
    _adView.delegate = self;
    
    
    //アドビューをつくるよ！このビューの一部に部品を追加する
    [self.view addSubview:_adView];
    
    
    //透明度を0にする
    _adView.alpha =0.0;
    
    
    //NOでなくてはいけない。
    _isVisible = NO;
    
    
    
    //modalViewを作成
    _textView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 50)];
    //色の配合の仕方を調整
    _textView.backgroundColor = [UIColor colorWithRed:0.192157 green:0.760784 blue:0.952941 alpha:0.2];
    //まだ隠れている状態＝NOとする
    _viewFlag = NO;
    [self.view addSubview:_textView];
    
    //テキストフィールドを作成
    _budgetTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-100, 40)];
    _budgetTextField.backgroundColor = [UIColor grayColor];
    _budgetTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_budgetTextField addTarget:self action:@selector(tapReturn) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textView addSubview:_budgetTextField];
    [self.view addSubview:_textView];
    
    
    //Doneボタンを作成
    _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 0, 100, 40)];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:_doneButton];

    // DatePicker表示用のmodalViewを作成
    _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 50)];
    //色の配合の仕方を調整
    _datePickerView.backgroundColor = [UIColor colorWithRed:0.192157 green:0.760784 blue:0.952941 alpha:0.2];
    //まだ隠れている状態＝NOとする
    _viewFlag = NO;
    [self.view addSubview:_datePickerView];
 
    // DatePickerをセット
    _datePicker = [UIDatePicker new];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    // デフォルトの日付を設定
    NSDate *today = [NSDate date];
    [_datePicker setDate:today];
    [_datePicker becomeFirstResponder];
    [_datePickerView addSubview:_datePicker];

    // DatePickerビューにDoneボタンを追加
    _datePickerDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 0, 100, 40)];
    [_datePickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_datePickerDoneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_datePickerDoneButton addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerView addSubview:_datePickerDoneButton];
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

    if (indexPath.row == 0) {
        [self closeDatePickerView];
        
        NSLog(@"おしたよー");

        _budgetFlag = YES;
        _viewFlag = YES;

        //modalViewをにゅっとだすよ
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        _textView.frame = CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 50);
        [UIView commitAnimations];
        
        //キーボードを最初から表示する
        [_budgetTextField becomeFirstResponder];
    } else {
        [self closeTextView];
        
        _budgetFlag = NO;
        _viewFlag = YES;

        //modalViewをにゅっとだす
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        _datePickerView.frame = CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 250);
        [UIView commitAnimations];
    }


    //ロング型の変数の中身を表示する文字列がld
    NSLog(@"%ld",(long)indexPath.section);

    
}
    

- (void)closeDatePickerView
{
    //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    _datePickerView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
    [UIView commitAnimations];
    
    _viewFlag = NO;
}



//Viewを下げる自作メソッド
-(void)closeTextView
{
    //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
    _textView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
    
    //キーボードを下げる
    [_budgetTextField resignFirstResponder];

    _viewFlag = NO;
}



//広告
-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    //if文をつくる.isVisibleの中がNOだったときにこの中の処理をする。
    
    if (!_isVisible) {
        
        
        //バナーが表示されるアニメーション。落ちてくる。
        
        //「animateAdBannerOn」という名前のアニメーション
        [UIView beginAnimations:@"animateAdBannerOn" context:nil];
        
        //アニメーションの時間の間隔。大きければ大きいほどゆっくり
        [UIView setAnimationDuration:0.3];
        
        //「-(void) bannerViewDidLoadAd:(ADBannerView *)banner」のbannerと同じ
        //banner.flame=「バナーの形」
        banner.frame = CGRectOffset (banner.frame, 0, 20);
        
        //透明度を0から1にして、見えるようになった。
        banner.alpha = 1.0;
        
        //beginAnimations に対して、　commitAnimations でここで終わり！って意味
        [UIView commitAnimations];
        
        //表示したので、isVisibleをYESにする
        _isVisible = YES;
        
    }
}


//広告：バナー表示でエラーが発生した場合
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}



//DoneボタンがTapされた時に何をするか
-(void)tapBtn:(UIButton *)doneButton
{
    NSLog(@"Done");
    
    //viewを下げる
    [self closeTextView];
    [self closeDatePickerView];
    
    //入力されたデータをTableViewに表示する
    //入力されたデータをメンバ変数に保存
    if (_budgetFlag == YES) {
        _budgetPrice = _budgetTextField.text;
        
    }
    else{
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"yyyy/MM/dd"];
        
        _startdate = [df stringFromDate:_datePicker.date];
        
    }
    
   //取り出した予算額と開始日のメンバ変数を%@に指定する
    _budgetArray =@[[NSString stringWithFormat:@"予算額 %@",_budgetPrice],[NSString stringWithFormat:@"開始日 %@",_startdate]];
    
    //入力した内容を初期化する
    [self.setBTableView reloadData];
    

}


//SaveボタンがTapされた時
- (IBAction)tapSave:(id)sender {
    
    //入力した金額をユーザーデフォルトに保存する
    NSUserDefaults *_budgetDefaults = [NSUserDefaults standardUserDefaults];
    
    
    [_budgetDefaults setObject:_budgetPrice forKey:@"Budget"];
    [_budgetDefaults setObject:_startdate forKey:@"Startdate"];
    
    [_budgetDefaults synchronize];
    
    NSLog(@"budget=%@",[_budgetDefaults objectForKey:@"Budget"]);
    NSLog(@"stardate=%@",[_budgetDefaults objectForKey:@"Startdate"]);
 
    
    //ハコからデータをとりだす
    NSString *budget = [_budgetDefaults stringForKey:@"Budget"];
    NSString *startdate = [_budgetDefaults stringForKey:@"Startdate"];
    
    //取り出したデータを%@に指定する
    _budgetArray =@[[NSString stringWithFormat:@"予算額 %@",budget],[NSString stringWithFormat:@"開始日 %@",startdate]];
    
    //入力した内容を初期化する
    [self.setBTableView reloadData];
    

}


//Cancelボタンが押された時
- (IBAction)tapCancel:(id)sender {
    
    //キーボードを下げる
    [self closeDatePickerView];
    [self closeTextView];
}
@end
                    
                    
