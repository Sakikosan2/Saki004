//
//  FourtthViewController.m
//  
//
//  Created by 丸山　咲 on 2014/09/16.
//
//

#import "FourtthViewController.h"



@interface FourtthViewController ()
{
    UIView *_skyView;
    BOOL _viewFlag;
    //if文のときは、BOOL型
    //ボタンの状態が変わった時に、その時の状態を知る目印
    //Viewを表示してる時はYES、非表示のときはNO
    
    UITextField *_budgetTextField;
    
    //ボタンをメンバ変数にする
    UIButton *_decideButton;
    //→ViewDidLoadのローカル変数を書き換える。データ型を削除して、置き換える
    
    


    NSArray *_budgetArray;
    
    //広告
    ADBannerView *_adView;
    
    BOOL _isVisible;

    
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


//TableViewに予算設定画面を設定する
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ユーザーデフォルトで入力したデータを取り出す
    
    
    //ローカル変数。別々のmethodに同じ変数をセットしてもエラーにならない
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    //ハコからデータをとりだす
    NSString *Kyuryoubi = [myDefaults stringForKey:@"Kyuryoubi"];
    
    //取り出したデータを%@に指定する
    
    
    _budgetArray =@[@"予算入力",@"給与額入力",[NSString stringWithFormat:@"給料日%@",Kyuryoubi]];
    
    
    
    self.setBTableView.delegate = self;
    self.setBTableView.dataSource = self;
    
    
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
        return 1;
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
        
        cell.textLabel.text = _budgetArray[indexPath.row+2];
        
    }
    
    return cell;
    
}

//セルが選択されたとき何を実行するか

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    画面遷移
    //①コードを使ってボタンオブジェクトを配置する
    //宣言と代入を一文で行っている
    //ボタン自体の高さが20あるので、568-20の高さにする。CGRectMakeのときはこの順番で座標書く
    _decideButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 460, 40, 20)];
    
    [_decideButton setTitle:@"Tap" forState:UIControlStateNormal];
    
    [_decideButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    //ボタンを押した時に、「tapBtn」のメソッドを実行する
    [_decideButton addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //これを忘れるとViewに表示されない
    [self.view addSubview:_decideButton];
    
    
    //②水色のビューを作成
    _skyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 250)];
    
    
    //色の配合の仕方を調整
    _skyView.backgroundColor = [UIColor colorWithRed:0.192157 green:0.760784 blue:0.952941 alpha:0.2];
    
    //まだ隠れている状態＝NOとする
    _viewFlag = NO;
    
    [self.view addSubview:_skyView];
    
    
    
    
    //テキストフィールドを作成
    //_myTextFieldはスカイビューの上に載せているので、(0.0)の位置は、全体のViewの真ん中らへんになる。
    _budgetTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    
    _budgetTextField.backgroundColor = [UIColor colorWithRed:0.78 green:0.27 blue:0.99 alpha:0.2];

    
    //キーボードを閉じるためのアクション。ストーリーボードでアクションつけたときと同じ
    [_budgetTextField addTarget:self action:@selector(tapReturn) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    //ポイント！水色のViewの上に載せている！！
    [_skyView addSubview:_budgetTextField];
    

    
//    //セクションを宣言
//    int section = indexPath.section;
//    
//    if (section ==0) {
//        //どこに移動するかを指定
//        budgetViewController *dvd =[self.storyboard instantiateViewControllerWithIdentifier:@"budgetViewController"];
//        
//        //ナビゲーションコントローラーの機能で画面遷移
//        [[self navigationController] pushViewController:dvd animated:YES];
//        
//    }
//    else{
//        dateViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"dateViewController"];
//        
//        [[self navigationController] pushViewController:dvc animated:YES];
//
//    }
    
   
    NSLog(@"%ld",(long)indexPath.section);
    
    
    
    
}

//キーボードのリターンキーが押された時に呼び出されるメソッド
-(void)tapReturn
{
    NSLog(@"tapReturn");
    
    //    //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
    //    _myButton.frame = CGRectMake(280, 400, 40, 20);
    //    _skyView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
    //
    //    _viewFlag = NO;
    
    [self downObjects];
    
}

//ボタンとビューが下がる自作メソッドをつくる！
-(void)downObjects
{
    //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
    _decideButton.frame = CGRectMake(280, 400, 40, 20);
    _skyView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
    
    _viewFlag = NO;
    
    
}

//ボタンとビューが上がる自作メソッドをつくる！
-(void)upObjects
{
    //非表示で押されたら上がる処理
    _decideButton.frame = CGRectMake(280, 150, 40, 10);
    
    //引数でmyButtonを渡しているので、myButtonを使える。このmyButtonはローカル変数のmyButtonではない
    
    //水色のViewを上げる
    //その前に、メンバ変数でskyViewを宣言する
    _skyView.frame =CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width,250);
    _viewFlag = YES;
    
    
}






//ボタンTapされた時に呼び出されるメソッド
-(void)tapBtn:(UIButton *)myButton
{
    NSLog(@"Tap!!!");
    
    //ボタンが上がるアニメーション
    [UIView beginAnimations:nil context:nil];
    //0.3秒の長さのアニメーション
    [UIView setAnimationDuration:0.3];
    
    if (_viewFlag) {
        //        //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
        //        myButton.frame = CGRectMake(280, 400, 40, 20);
        //        _skyView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
        //
        //        _viewFlag = NO;
        //
        
        [self downObjects];
        
    }else{
        //        //非表示で押されたら上がる処理
        //        myButton.frame = CGRectMake(280, 150, 40, 10);
        //
        //        //引数でmyButtonを渡しているので、myButtonを使える。このmyButtonはローカル変数のmyButtonではない
        //
        //        //水色のViewを上げる
        //        //その前に、メンバ変数でskyViewを宣言する
        //        _skyView.frame =CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width,250);
        //        _viewFlag = YES;
        
        [self upObjects];
        
    }
    
    
    //アニメーションの最後にはこれが必要！
    [UIView commitAnimations];
    
    
    
}



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


//バナー表示でエラーが発生した場合
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


@end
