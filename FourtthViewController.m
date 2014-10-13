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
    UIView *_skyView;
    UIView *_dateView;
    
    BOOL _viewFlag;


    //ボタンの状態が変わった時に、その時の状態を知る目印
    //Viewを表示してる時はYES、非表示のときはNO
    
    UITextField *_budgetTextField;
    
    //Doneボタンをメンバ変数にする
    UIButton *_doneButton;
    //→ViewDidLoadのローカル変数を書き換える。データ型を削除して、置き換える
    UIDatePicker *incomeDatePicker;
    
    
    


    NSArray *_budgetArray;
    
    //広告
    ADBannerView *_adView;
    
    BOOL _isVisible;

    //予算をユーザーデフォルトに保存
    BOOL _budgetFlag;
    
    //Alertを一回しか出さない
    BOOL _alertFlag;
    
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
    NSString *budget = [_budgetDefaults stringForKey:@"budget"];
    NSString *income = [_budgetDefaults stringForKey:@"income"];
    NSString *Kyuryoubi = [_budgetDefaults stringForKey:@"Kyuryoubi"];
    NSString *Kaishibi = [_budgetDefaults stringForKey:@"Kaishibi"];
    
    //取り出したデータを%@に指定する
    _budgetArray =@[[NSString stringWithFormat:@"予算額(%@) %@",app._convertCurrency,budget],[NSString stringWithFormat:@"給与額(%@) %@",app._convertCurrency,income],[NSString stringWithFormat:@"給料日 %@",Kyuryoubi],[NSString stringWithFormat:@"開始日 %@",Kaishibi]];
    
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
//            ThirdViewController *thd = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdViewController"];
//            [self presentViewController:thd animated:YES completion:nil];
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
            
            break;
        }
        case 1:
        {
//            //「はい」が選択されたとき
//            NSLog(@"はい");
//        
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
    _skyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 250)];
    
    //色の配合の仕方を調整
    _skyView.backgroundColor = [UIColor colorWithRed:0.192157 green:0.760784 blue:0.952941 alpha:0.2];
    
    //まだ隠れている状態＝NOとする
    _viewFlag = NO;
    
    [self.view addSubview:_skyView];
    
    //テキストフィールドを作成
    _budgetTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-100, 40)];
    
    _budgetTextField.backgroundColor = [UIColor grayColor];
    _budgetTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [_budgetTextField addTarget:self action:@selector(tapReturn) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [_skyView addSubview:_budgetTextField];
    
    [self.view addSubview:_skyView];
    
    
    //Doneボタンを作成
    _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 0, 100, 40)];
    
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    [_doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    

    [_doneButton addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_skyView addSubview:_doneButton];


    
}




//TableView
//セクション数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


//セクションのタイトル文字
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"予算設定";
        
    }
    if (section == 1) {
        return @"日付設定";
        
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
    if (section == 1) {
        return 3;
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
        
    }else{
        
        cell.textLabel.text = _budgetArray[indexPath.row+1];
        
    }
    
    
    return cell;
    
}

//セルが選択されたとき何を実行するか

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //！金額設定用のViewを設定
    int section = indexPath.section;
    
    if (section ==0) {
        //どこに移動するかを指定
        
        //modalViewをにゅっとだすよ
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        [self downObjects];
        
        _skyView.frame = CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 250);
        
        _viewFlag = YES;
        
        [UIView commitAnimations];
        
        //キーボードを最初から表示する
        [_budgetTextField becomeFirstResponder];
        
        
        if (indexPath.row == 0) {
            _budgetFlag = YES;
        }
        else{
            _budgetFlag = NO;
            
        }
    }
    
    else
    
    {
        
        //modalViewをにゅっとだす
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        
        [self downObjects];
        
        _skyView.frame = CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 250);
        
        _viewFlag = YES;
        
        //DatePickerをセット
        
        // DatePickerをつくる
        UIDatePicker *datePicker = [UIDatePicker new];
        incomeDatePicker = datePicker;
        [incomeDatePicker setDatePickerMode:UIDatePickerModeDate];
        
        // デフォルトの日付を設定
        NSDate *today = [NSDate date];
        [incomeDatePicker setDate:today];
        [incomeDatePicker becomeFirstResponder];

        // DatePickerをskyviewにセット
        [_skyView addSubview:incomeDatePicker];
        // skyviewをself.view(画面)にセット
        [self.view addSubview:_skyView];
        
        [UIView commitAnimations];
        
        [self downObjects];
        
    }
    
    //ロング型の変数の中身を表示する文字列がld
    NSLog(@"%ld",(long)indexPath.section);
    
}


////    画面遷移
//    //①コードを使ってボタンオブジェクトを配置する
//    //宣言と代入を一文で行っている
//    //ボタン自体の高さが20あるので、568-20の高さにする。CGRectMakeのときはこの順番で座標書く
//    _decideButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 0, 100, 40)];
//    
//    [_decideButton setTitle:@"Tap" forState:UIControlStateNormal];
//    
//    [_decideButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    
//    //ボタンを押した時に、「tapBtn」のメソッドを実行する
//    [_decideButton addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    //これを忘れるとViewに表示されない
//    [self.view addSubview:_decideButton];

    
    
    
//    //テキストフィールドを作成
//    //_myTextFieldはスカイビューの上に載せているので、(0.0)の位置は、全体のViewの真ん中らへんになる。
//    _budgetTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
//    
//    _budgetTextField.backgroundColor = [UIColor colorWithRed:0.78 green:0.27 blue:0.99 alpha:0.2];
//
//    
//    //キーボードを閉じるためのアクション。ストーリーボードでアクションつけたときと同じ
//    [_budgetTextField addTarget:self action:@selector(tapReturn) forControlEvents:UIControlEventEditingDidEndOnExit];
//    
//    
//    //ポイント！水色のViewの上に載せている！！
//    [_skyView addSubview:_budgetTextField];
//    



    
    


//キーボードのリターンキーが押された時に呼び出されるメソッド
//-(void)tapReturn
//{
//    NSLog(@"tapReturn");
//    
//    //    //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
//    //    _myButton.frame = CGRectMake(280, 400, 40, 20);
//    //    _skyView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
//    //
//    //    _viewFlag = NO;
//    
//    [self downObjects];
//    
//}


//Viewを下げる自作メソッド
-(void)downObjects
{
    //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
    _skyView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
    
    //キーボードを下げる
    [_budgetTextField resignFirstResponder];

    _viewFlag = NO;
    
    
}





////ボタンとビューが上がる自作メソッドをつくる！
//-(void)upObjects
//{
//    //非表示で押されたら上がる処理
//    _decideButton.frame = CGRectMake(280, 150, 40, 10);
//    
//    //引数でmyButtonを渡しているので、myButtonを使える。このmyButtonはローカル変数のmyButtonではない
//    
//    //水色のViewを上げる
//    //その前に、メンバ変数でskyViewを宣言する
//    _skyView.frame =CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width,250);
//    _viewFlag = YES;
//    
//    
//}
//
//
//
//
//
//



    //アニメーションの最後にはこれが必要！
//    [UIView commitAnimations];
//    
//    
//    
//}


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
    [self downObjects];
    
}


//SaveボタンがTapされた時
- (IBAction)tapSave:(id)sender {
    
    //入力した金額をユーザーデフォルトに保存する
    NSUserDefaults *_budgetDefaults = [NSUserDefaults standardUserDefaults];
    if (_budgetFlag == YES) {
        
        NSString *_budget = _budgetTextField.text;
        [_budgetDefaults setObject:_budget forKey:@"budget"];
    }
    else{
        NSString *_income = _budgetTextField.text;
        [_budgetDefaults setObject:_income forKey:@"income"];
        
    }
    
    [_budgetDefaults synchronize];
    
    NSLog(@"budget=%@",[_budgetDefaults objectForKey:@"budget"]);
    NSLog(@"income=%@",[_budgetDefaults objectForKey:@"income"]);
    
    
    //ハコからデータをとりだす
    NSString *budget = [_budgetDefaults stringForKey:@"budget"];
    NSString *income = [_budgetDefaults stringForKey:@"income"];
    NSString *Kyuryoubi = [_budgetDefaults stringForKey:@"Kyuryoubi"];
    NSString *Kaishibi = [_budgetDefaults stringForKey:@"Kaishibi"];
    
    
    //取り出したデータを%@に指定する
    _budgetArray =@[[NSString stringWithFormat:@"予算額 %@",budget],[NSString stringWithFormat:@"給与額 %@",income],[NSString stringWithFormat:@"給料日 %@",Kyuryoubi],[NSString stringWithFormat:@"開始日 %@",Kaishibi]];
    
    
    //入力した内容を初期化する
    [self.setBTableView reloadData];
    

}

//Cancelボタンが押された時
- (IBAction)tapCancel:(id)sender {
    
    //キーボードを下げる
    [self downObjects];
    
}
@end
                    
                    
