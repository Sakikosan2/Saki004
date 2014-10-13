//
//  changeCViewController.m
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "changeCViewController.h"
#import "ThirdViewController.h"
#import "AppDelegate.h"






@interface changeCViewController ()
{
    NSArray *_currencyList;
    NSString *_currency;
    
}

@end

@implementation changeCViewController

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

    
    //バンドルを取得する
    NSBundle *bundle = [NSBundle mainBundle];
    
    //読み込むプロパティリストのファイルパス(場所)を指定＝パスを取得する
    NSString *path =[bundle pathForResource:@"CurrencyList" ofType:@"plist"];
    
    //プロパティリストの中身のデータをNSDictionaryにいれる
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    _currencyList = [dic objectForKey:@"CurrencyList"];
    NSLog(@"List");
    
    [NSArray arrayWithContentsOfFile:path];
    
    
    self.currencyTableView.delegate=self;
    self.currencyTableView.dataSource=self;
    
//    選択した通貨をユーザーデフォルトに保存
    NSUserDefaults *_currencyDefaults = [NSUserDefaults standardUserDefaults];
    //Memoという名前のハコからデータをとりだす
    //_currencyDefaults = [_currencyDefaults stringForKey:@"Currency"];
    
    
    
}

//行数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currencyList.count;
    
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
    
    
    //※メインストーリーボードで、delegateとDataSourceを関連付ける
    
//Plistからデータを取り出す。 ※Dictionary型の部分全体を取り出す
    NSDictionary *currencyData = _currencyList[indexPath.row];
    
    //plistのnameのデータを取り出す
    NSString *currencyName = [currencyData objectForKey:@"Name"];
    NSString *currencyCode = [currencyData objectForKey:@"Code"];
    
    
    
    //表示する文字列を作成
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",currencyName,currencyCode];
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //クリックして画面遷移したあとのLabelに配列の中身を投影する
    
    //アップデリゲートをインスタンス化(カプセル化)
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    //プロパティリストの中身のデータをNSDictionaryにいれる
    NSDictionary *_currencyInfo = _currencyList[indexPath.row];
    
    
    
    switch (self.selectnum) {
        case 0:
        {
            
            //APIの呼び出し
            NSString *orign =@"http://rate-exchange.appspot.com/currency";
            
            //アップデリゲートをインスタンス化(カプセル化)
            AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
            
            //プロパティからデータを取り出して指定
            NSString *from_cr_code = app._localCurrency;
            NSString *to_cr_code = app._convertCurrency;
            
            //?以降の文字列を完成させる
            NSString *url = [NSString stringWithFormat:@"%@?from=%@&to=%@",orign,from_cr_code,to_cr_code];
            
            //NSURLRequestを生成
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            
            //サーバー（API)と通信を行い、JSON形式のデータを取得
            NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            //JSONをパース(データの設定)
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
            
            NSString *fromCode = [dictionary valueForKeyPath:@"From"];
            NSString *rate  = [dictionary  valueForKeyPath:@"Rate"];
            NSString *toCode = [dictionary valueForKeyPath:@"To"];
            
            
            //APIで取るべきデータがnilの時
            if (fromCode ==nil) {
                fromCode = @"usd";
                rate = 0;
                toCode= @"jpy";
                
            }else{
                //ResultLabelに結果を表示する
                self.resultLabel.text = [NSString stringWithFormat:@"1%@のレート換算は、%@%@",fromCode,rate,toCode];
                
            
        }
            //現地通貨設定
            //今の画面のどれを選んだか=indexPath.row
            NSLog(@"%@",[_currencyInfo objectForKey:@"Code"]);
            
            if (app._localCurrency == nil){
                app._localCurrency = [NSString new];
            }
            app._localCurrency = [_currencyInfo objectForKey:@"Localcurrency"];
            NSLog(@"Localcurrency");

        }
            
            break;
    
        case 1:
        {//手数料通貨設定
            NSLog(@"%@",[_currencyInfo objectForKey:@"Code"]);
            if (app._commitCurrency == nil){
                app._commitCurrency = [NSString new];
            }

            app._commitCurrency = [_currencyInfo objectForKey:@"Commitcurrency"];
            NSLog(@"Commitcurrency");
            
            
            //APIの呼び出し
            NSString *orign =@"http://rate-exchange.appspot.com/currency";
            
            //アップデリゲートをインスタンス化(カプセル化)
            AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
            
            //プロパティからデータを取り出して指定
            NSString *from_cr_code = app._localCurrency;
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
            
            
            //APIで取るべきデータがnilの時
            if (fromCode ==nil) {
                fromCode = @"usd";
                rate = 0;
                toCode= @"jpy";
                
            }else{
                //ResultLabelに結果を表示する
                self.resultLabel.text = [NSString stringWithFormat:@"1%@のレート換算は、%@%@",fromCode,rate,toCode];
                
            }

        }
            break;
            
            
        case 2:
            //換算通貨設定
        {
            
            //APIの呼び出し
            NSString *orign =@"http://rate-exchange.appspot.com/currency";
            
            //アップデリゲートをインスタンス化(カプセル化)
            AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
            
            //プロパティからデータを取り出して指定
            NSString *from_cr_code = app._localCurrency;
            NSString *to_cr_code = app._convertCurrency;
            
            //?以降の文字列を完成させる
            NSString *url = [NSString stringWithFormat:@"%@?from=%@&to=%@",orign,from_cr_code,to_cr_code];
            
            //NSURLRequestを生成
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            
            //サーバー（API)と通信を行い、JSON形式のデータを取得
            NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            //JSONをパース(データの設定)
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
            
            NSString *fromCode = [dictionary valueForKeyPath:@"From"];
            NSString *rate  = [dictionary  valueForKeyPath:@"Rate"];
            NSString *toCode = [dictionary valueForKeyPath:@"To"];
            
            
            //APIで取るべきデータがnilの時
            if (fromCode ==nil) {
                fromCode = @"usd";
                rate = 0;
                toCode= @"jpy";
                
            }else{
                //ResultLabelに結果を表示する
                self.resultLabel.text = [NSString stringWithFormat:@"1%@のレート換算は、%@%@",fromCode,rate,toCode];
                
            }
            
        
            NSLog(@"%@",[_currencyInfo objectForKey:@"Code"]);
            if (app._convertCurrency == nil){
                app._convertCurrency = [NSString new];
            }

            app._convertCurrency = [_currencyInfo objectForKey:@"Convertcurrency"];
            NSLog(@"Convertcurrency");
        }

            
            default:
            
            break;
    }
    
    
    NSLog(@"dismiss");
    //dismissViewControllerAnimatedで子の画面を消してる
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //UserDefaultに保存する
    NSUserDefaults *_currencyDefaults = [NSUserDefaults standardUserDefaults];
    [_currencyDefaults synchronize];
    

}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
