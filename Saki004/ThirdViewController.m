//
//  ThirdViewController.m
//  Saki003
//
//  Created by 丸山　咲 on 2014/09/10.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "ThirdViewController.h"
#import "changeCViewController.h"




//TableViewに表示させる
@interface ThirdViewController ()
{
    NSArray *_currencyArray;
    
    //広告
    ADBannerView *_adView;
    BOOL _isVisible;
    
}


@end

@implementation ThirdViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //現地通貨設定、換算通貨設定を配列に入れる
    _currencyArray =@[@"現地通貨設定",@"換算通貨設定"];
    self.setTableView.delegate = self;
    self.setTableView.dataSource = self;
    
    
    ///広告
    //タブバーのサイズを調べる
    CGFloat tabBarHeight = self.tabBarController.tabBar.bounds.size.height;
    CGFloat addViewHeight =_adView.frame.size.height;
    NSLog(@"%f", tabBarHeight);
    NSLog(@"%f", addViewHeight);
    //バナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 460, _adView.frame.size.width, _adView.frame.size.height)];
    _adView.delegate = self;
    [self.view addSubview:_adView];
    _adView.alpha =0.0;
    _isVisible = NO;
    
}

///TableViewの設定
//セクション数r
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


//セクションのタイトル文字
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"通貨設定";
}


//行数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currencyArray.count;
}


//TableViewのセル(Cell)に内容を表示する
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    static NSString *CellIdentifer = @"cell";
    //セルの再利用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    //セルの初期化とスタイルの決定
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"行番号=%d",indexPath.row];
    cell.textLabel.text = _currencyArray[indexPath.row];
    return cell;
    
}


//セルが選択されたときに何を実行するか
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //画面オブジェクトのインスタンス化(カプセル化)
    changeCViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"changeCViewController"];
    //行番号をcvcのselectnumに保存
    cvc.selectnum = indexPath.row;
    if (indexPath.row == 0) {
        //TableViewの一行目が選択された時　= isSettingLocalCurrencyフラグはYES
        cvc.isSettingLocalCurrency = YES;
        //modalで画面遷移
        [self presentViewController:cvc animated:YES completion:nil];
        
    } else if (indexPath.row == 1) {
        //TableViewの二行目が選択された時　= isSettingLocalCurrencyフラグはNO
        cvc.isSettingLocalCurrency = NO;
        //modalで画面遷移
        [self presentViewController:cvc animated:YES completion:nil];
    }
    

    
}



//再取得ボタンがTapされた時　APIデータを再取得して、ラベル(resultLabel)に表示
-(IBAction)tapBtn:(id)sender
{
    
    //? パラメータをUserDefaultからとってくる
    // データを格納するユーザデフォルトを取得
    NSUserDefaults *currencyDefaults = [NSUserDefaults standardUserDefaults];
    //
    NSMutableDictionary *currencySettings = [NSMutableDictionary new];
    NSDictionary *currencyDictionary = [currencyDefaults objectForKey:@"currencyDefaults"];
    currencySettings = currencyDictionary.mutableCopy;
    NSString *rate =[NSString new];
    rate = [currencySettings objectForKey:@"rate"];
    NSLog(@"%@",rate);
    
//    self.resultLabel.text = currencySettings;
    

}

//APIを呼び出すためのメソッド
-(NSMutableDictionary *)getRate:(NSString *)localCurrencyCode convertCurrencyCode:(NSString *)convertCurrencyCode
{
    // 必要なパラメータの初期化
    NSString *rate = [NSString new];
    NSString *url;
    NSURLRequest *request;
    NSData *json;
    NSDictionary *dictionary;
    
    
    // APIにアクセスしてレートの情報を取得する
    //APIの元のURLの呼び出し
    NSString *origin =@"http://rate-exchange.appspot.com/currency";
    
    //エラーが起こりそうな処理を@tryで囲む
    
    @try {
        //http://rate-exchange.appspot.com/currency/現地通貨/換算通貨.jsonとなるようにURLを生成
        url = [NSString stringWithFormat:@"%@?from=%@&to=%@",origin ,localCurrencyCode, convertCurrencyCode];
        
        //NSURLRequestを生成
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        //サーバー（API)と通信を行い、JSON形式のデータを取得
        json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        //JSONをパース(データの設定)
        dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        
        // レートの情報を格納(APIから欲しかったのはレートだけ)
        rate = [dictionary  valueForKeyPath:@"rate"];
    }
    //エラーが起きた時どうするか
    @catch (NSException *exception) {
        rate = nil;
    }
    
    // 取得したレートを含めてユーザデフォルトにデータを保存
    NSMutableDictionary *currencySettings = [NSMutableDictionary new];
    [currencySettings setObject:localCurrencyCode forKey:@"localCurrencyCode"];
    [currencySettings setObject:convertCurrencyCode forKey:@"convertCurrencyCode"];
    [currencySettings setObject:rate forKey:@"rate"];
    
    return currencySettings;
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
    // Dispose of any resources that can be recreated.
}



- (IBAction)tapCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapSave:(id)sender {
}
@end
