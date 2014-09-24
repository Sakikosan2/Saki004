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
    
    _currencyArray =@[@"現地通貨設定",@"手数料通貨設定",@"換算通貨設定"];
    
    
    
    self.setTableView.delegate = self;
    self.setTableView.dataSource = self;
    
    //API
    [self getRate];
    
    
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
    
    cell.textLabel.text = _currencyArray[indexPath.row];
    
    
    return cell;
    
}


//セルが選択するときに何を実行するか

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //画面オブジェクトのインスタンス化(カプセル化)
    changeCViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"changeCViewController"];
    
    
    
    
    
    //行番号を保存
    dvc.selectnum = indexPath.row;
    
    
    //modalで画面遷移
    [self presentViewController:dvc animated:YES completion:nil];
    
    
    
//    //ナビゲーションコントローラーの機能で画面遷移
//    [[self navigationController] pushViewController:dvc animated:YES];
//    
}



//API
-(IBAction)tapBtn:(id)sender
{
    
    //APIの呼び出し
    NSString *orign =@"http://rate-exchange.appspot.com/currency";
    
    //アップデリゲートをインスタンス化(カプセル化)
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    
    //プロパティからデータを取り出して指定
    NSString *from_cr_code = app._genchiCurrency;
    
    NSString *to_cr_code = app._convertCurrency;
    
    
    
    //?以降の文字列を完成させる
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
    
    
   //ResultLabelに結果を表示する
    self.resultLabel.text = [NSString stringWithFormat:@"1%@のレート換算は、%@%@",fromCode,rate,toCode];

    

    
}


-(void)getRate
{
    //APIの呼び出し
    NSString *orign =@"http://rate-exchange.appspot.com/currency";
    
    
    //プロパティからデータを取り出して指定
    NSString *from_cr_code = @"jpy";
    
    NSString *to_cr_code = @"php";
    
    
    
   
 
    //?以降の文字列を完成させる
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
    
    
    //ResultLabelに結果を表示する
    self.resultLabel.text = [NSString stringWithFormat:@"1%@のレート換算は、%@%@",fromCode,rate,toCode];
    


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



@end
