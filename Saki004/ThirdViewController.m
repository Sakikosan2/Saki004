//
//  ThirdViewController.m
//  Saki003
//
//  Created by 丸山　咲 on 2014/09/10.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "ThirdViewController.h"
#import "changeCViewController.h"
#import "AppDelegate.h"



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
    
    //API取得の自作メソッドを実行
    [self getRate];
    
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



//再取得ボタンがTapされた時　APIでデータをとってくる
-(IBAction)tapBtn:(id)sender
{
    
    //APIの元のURLの呼び出し
    NSString *orign =@"http://rate-exchange.appspot.com/currency";
    
    //アップデリゲートをインスタンス化(カプセル化)
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    //? プロパティからデータを取り出して指定
    NSString *from_cr_code = app._localCurrency;
    NSString *to_cr_code = app._convertCurrency;
    
    //http://rate-exchange.appspot.com/currency/現地通貨/換算通貨.jsonとなるように生成
    NSString *url = [NSString stringWithFormat:@"%@?from=%@&to=%@",orign,from_cr_code,to_cr_code];
    
    //NSURLRequestを生成
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    //サーバー（API)と通信を行い、JSON形式のデータを取得
    NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //JSONをパース(データの設定)
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
    
    NSString *fromCode = [dictionary valueForKeyPath:@"from"];
    NSString *rate  = [dictionary  valueForKeyPath:@"rate"];
    NSString *toCode = [dictionary valueForKeyPath:@"to"];
    
    
    //APIで取るべきデータがnilの時
    if (fromCode ==nil) {
        fromCode = @"USD";
        rate = 0;
        toCode= @"JPY";
        
        }else{
   //ResultLabelに結果を表示する
    self.resultLabel.text = [NSString stringWithFormat:@"1%@ = %@%@",fromCode,rate,toCode];

    }

    
}

//APIを読み出すためのメソッド
-(void)getRate
{
    //APIの元のURLの呼び出し
    NSString *orign =@"http://rate-exchange.appspot.com/currency";
    NSLog(@"元のURlは%@",orign);
    
    
    //プロパティからデータを取り出して指定
    //? jpyとphpに指定してるから、ずっと0.4ていう値なのかも？？
    NSString *from_cr_code = @"jpy";
    NSString *to_cr_code = @"php";
    
    
    //エラーが起こりそうな処理を@tryで囲む
    //@tryの前に宣言文出す
    NSString *url;
    NSURLRequest *request;
    NSData *json;
    NSDictionary *dictionary;
    NSString *fromCode;
    NSString *rate;
    NSString *toCode;
    
    
    @try {
        //http://rate-exchange.appspot.com/currency/現地通貨/換算通貨.jsonとなるようにURLを生成
        url = [NSString stringWithFormat:@"%@?from=%@&to=%@",orign,from_cr_code,to_cr_code];
        
        //NSURLRequestを生成
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        //サーバー（API)と通信を行い、JSON形式のデータを取得
        json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        //JSONをパース(データの設定)
        dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
        
        fromCode = [dictionary valueForKeyPath:@"from"];
        rate  = [dictionary  valueForKeyPath:@"rate"];
        toCode = [dictionary valueForKeyPath:@"to"];
    }
    //エラーが起きた時どうするか
    @catch (NSException *exception) {
        fromCode = nil;
    }
    
    
    
    //JSONをパースで取れなかった時→前回保存したデータから取り出す
    //APIで取るべきデータがnilの時
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    
    if (fromCode ==nil) {
        
        //UserDefaultsにデータが存在するかチェック
        if ([myDefaults objectForKey:@"rate"]==nil) {
            //UserDefaultsにも入っていない場合は暫定の値をセット
            fromCode = @"usd";
            rate = @"100";
            toCode= @"jpy";
            
        }else{
            fromCode = [myDefaults objectForKey:@"from"];
            rate  = [myDefaults  objectForKey:@"rate"];
            toCode = [myDefaults objectForKey:@"to"];
        }
        
        
    }else{
      //APIで値がとれたのでUserDefaultsに保存
        [myDefaults setObject:rate forKey:@"rate"];
        [myDefaults setObject:fromCode forKey:@"from"];
        [myDefaults setObject:toCode forKey:@"to"];
        
        NSLog(@"rate=%@",[myDefaults objectForKey:@"rate"]);
        
        
        //    NSDictionary *appDefaults = [NSDictionary
        //                                 dictionaryWithObject:@"default value" forKey:@"KEY0"];
        //
        //    [defaults registerDefaults:appDefaults];
        
        //
    
        [myDefaults synchronize];
        
    }
    
    self.resultLabel.text = [NSString stringWithFormat:@"1%@ = %@%@",fromCode,rate,toCode];

}

//- (void)applicationWillTerminate:(UIApplication *)application
//    {
//    // Saves changes in the application's managed object context before the application terminates.
//        [self saveContext];
//    }

//    - (void)saveContext
//    {
//        NSError *error = nil;
//        NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//        if (managedObjectContext != nil) {
//            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//                // Replace this implementation with code to handle the error appropriately.
//                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//                abort();
//            } 
//        }
//    }

    




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
