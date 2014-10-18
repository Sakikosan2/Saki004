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
    //Plistからデータを取り出す。 ※Dictionary型の部分全体を取り出す
    NSDictionary *currencyData = _currencyList[indexPath.row];

    //plistのnameのデータを取り出す
    NSString *currencyName = [currencyData objectForKey:@"Name"];
    NSString *currencyCode = [currencyData objectForKey:@"Code"];
    
    //表示する文字列を作成
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",currencyName,currencyCode];
    
    return cell;
    
    
}


//TableViewのセルが選択された時に何をするか
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //アップデリゲートをインスタンス化(カプセル化)
    AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    //プロパティリストの中身のデータをNSDictionaryにいれる
    NSDictionary *_currencyInfo = _currencyList[indexPath.row];
    //APIの呼び出し
    NSString *orign =@"http://rate-exchange.appspot.com/currency";
    //プロパティからデータを取り出して指定
    NSString *from_cr_code = app._localCurrency;
    NSString *to_cr_code = app._convertCurrency;
    NSLog(@"%@", from_cr_code);
    NSLog(@"%@", to_cr_code);
    // ?以降の文字列を完成させる
    NSString *url = [NSString stringWithFormat:@"%@?from=%@&to=%@",orign,from_cr_code,to_cr_code];
    NSLog(@"%@", url);
    //NSURLRequestを生成
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //サーバー（API)と通信を行い、JSON形式のデータを取得
    NSData *json = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //JSONをパース(データの設定)
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", json);
    NSLog(@"%@", dictionary);
    //?
    NSString *_localCurrency = [dictionary valueForKeyPath:@"Localcurrency"];
    NSString *_convertCurrency = [dictionary valueForKeyPath:@"Convertcurrency"];
    NSString *_rate  = [dictionary  valueForKeyPath:@"Rate"];
//    NSString *fromCode = [dictionary valueForKeyPath:@"From"];
//    NSString *rate  = [dictionary  valueForKeyPath:@"Rate"];
//    NSString *toCode = [dictionary valueForKeyPath:@"To"];

    //APIで取るべきデータがnilの時
        if (_localCurrency ==nil) {
            _localCurrency = @"USD";
            _rate = @"100";
            _convertCurrency= @"JPY";
                
        }else{
            // レートを元に換算通貨における金額を計算
            CGFloat priceOfConvertCurrency = 1 / [_rate floatValue];
                
            //ResultLabelに結果を表示する
            self.resultLabel.text = [NSString stringWithFormat:@"1%@ = %f%@",_localCurrency, priceOfConvertCurrency, _convertCurrency];
                
        }
    

    
    
    //dismissViewControllerAnimatedで親画面に遷移
    NSLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];

    
    
    if (self.isSettingLocalCurrency) {
        // 現地通貨設定の場合の処理
        
        if ([__currencyDefault objectForKey:@"Loculcurrency"]==nil) {
            //UserDefaultに換算通貨が設定されていないとき暫定の値をセット
            _localCurrency = @"USD";
            _rate = @"100";
            _convertCurrency= @"JPY";
            //現地通貨設定
            NSLog(@"%@",[_currencyInfo objectForKey:@"Code"]);
            if (app._localCurrency == nil){
                app._localCurrency = [NSString new];
            }
            app._localCurrency = [_currencyInfo objectForKey:@"Localcurrency"];
            NSLog(@"Localcurrency");
        
        
            
            //? UserDefaultに現地通貨、換算通貨を保存する
            NSUserDefaults *_currencyDefaults = [NSUserDefaults standardUserDefaults];
            //現地通貨をUserDefaultに保存
            [_currencyDefaults setObject:self.currencyTableView.indexPathForSelectedRow forKey:@"Loculcurrency"];
            
            NSLog(@"Loculcurrency = %@",[_currencyDefaults objectForKey:@"Loculcurrency"]);
        
            
        }else{
            

            //現地通貨設定
            NSLog(@"%@",[_currencyInfo objectForKey:@"Code"]);
            if (app._localCurrency == nil){
                app._localCurrency = [NSString new];
            }
            app._localCurrency = [_currencyInfo objectForKey:@"Localcurrency"];
            NSLog(@"Localcurrency");
            
            
            //UserDefaultに現地通貨を保存する
            NSUserDefaults *_currencyDefaults = [NSUserDefaults standardUserDefaults];
            //現地通貨と換算通貨をUserDefaultに保存
            [_currencyDefaults setObject:self.currencyTableView.indexPathForSelectedRow forKey:@"Loculcurrency"];
            NSLog(@"Loculcurrency = %@",[_currencyDefaults objectForKey:@"Loculcurrency"]);
            
            
            
        }
        
        
        
    }else{
        // 換算通貨設定の場合の処理
        if ([__currencyDefault objectForKey:@"from"]==nil) {
            //UserDefaultに換算通貨が設定されていないときは暫定の値をセット
            _localCurrency = @"USD";
            _rate = @"100";
            _convertCurrency= @"JPY";
            
            //換算通貨設定
            NSLog(@"%@",[_currencyInfo objectForKey:@"Code"]);
            if (app._convertCurrency == nil){
                app._convertCurrency = [NSString new];
            }
            app._convertCurrency = [_currencyInfo objectForKey:@"Convertcurrency"];
            NSLog(@"Convertcurrency");
            
            
            //UserDefaultに換算通貨を保存する
            NSUserDefaults *_currencyDefaults = [NSUserDefaults standardUserDefaults];
            [_currencyDefaults setObject:self.currencyTableView.indexPathForSelectedRow forKey:@"Convertcurrency"];
            NSLog(@"Convertcurrency = %@",[_currencyDefaults objectForKey:@"Convertcurrency"]);

            
        }else{
            
            
            //換算通貨設定
            NSLog(@"%@",[_currencyInfo objectForKey:@"Code"]);
            if (app._convertCurrency == nil){
                app._localCurrency = [NSString new];
            }
            app._convertCurrency = [_currencyInfo objectForKey:@"Convertcurrency"];
            NSLog(@"Convertcurrency");
            
            //UserDefaultに換算通貨を保存する
            NSUserDefaults *_currencyDefaults = [NSUserDefaults standardUserDefaults];
            [_currencyDefaults setObject:self.currencyTableView.indexPathForSelectedRow forKey:@"Convertcurrency"];
            NSLog(@"Convertcurrency = %@",[_currencyDefaults objectForKey:@"Convertcurrency"]);

        }
    }
        

    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
