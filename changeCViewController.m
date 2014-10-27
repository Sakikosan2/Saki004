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
    
    [NSArray arrayWithContentsOfFile:path];
    
    self.currencyTableView.delegate=self;
    self.currencyTableView.dataSource=self;

   
    
    
}

//行数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currencyList.count;
    
}



//セルに内容を表示する
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
    // データを格納するユーザデフォルトを取得
    NSUserDefaults *currencyDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *settings = [currencyDefaults objectForKey:@"currencyDefault"];// currencyDefaultのデータを取得
    
    if (self.isSettingLocalCurrency) { // 現地通貨設定をしている時の処理
        // 必要なパラメータの初期値を取得
        NSDictionary *localCurrency = _currencyList[indexPath.row]; // ユーザが今選択した現地通貨情報
        NSString *localCurrencyCode = localCurrency[@"Code"];
        NSString *convertCurrencyCode = [NSString new];

        // ユーザデフォルトから既に設定されているパラメータがあれば取得
        if ([settings objectForKey:@"convertCurrencyCode"]) {  // 換算通貨設定が既になされていれば、それをconvertCurrencyにセット
            convertCurrencyCode = [settings objectForKey:@"convertCurrencyCode"];
        } else {    // 換算通貨設定がされていなかった場合、デフォルト値として"JPY"をセット
            convertCurrencyCode = @"JPY";
        }
        
        // apiでレートを取得
        NSMutableDictionary *currencySettings = [self getRate:localCurrencyCode convertCurrencyCode:convertCurrencyCode];
        if ([currencySettings count]) {
            // ユーザデフォルトに、通貨・レートの情報を"currencyDefault"という名前で保存
            [currencyDefaults setObject:currencySettings forKey:@"currencyDefault"];
            [currencyDefaults synchronize];
            //dismissViewControllerAnimatedで親画面に遷移
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        } else {
            [self showAlert :nil];
            
        }
        
    } else {    // 換算通貨設定をしている時の処理
        // 必要なパラメータの初期値を取得
        NSDictionary *convertCurrency = _currencyList[indexPath.row]; // ユーザが今選択した換算通貨情報
        NSString *convertCurrencyCode = convertCurrency[@"Code"];
        NSString *localCurrencyCode = [NSString new];
        
        // ユーザデフォルトから既に設定されているパラメータがあれば取得
        if ([settings objectForKey:@"localCurrencyCode"]) {  // 現地通貨設定が既になされていれば、それをconvertCurrencyにセット
            localCurrencyCode = [settings objectForKey:@"localCurrencyCode"];
        } else {    // 現地通貨設定がされていなかった場合、デフォルト値として"JPY"をセット
            localCurrencyCode = @"USD";
        }
        
        // apiでレートを取得
        NSMutableDictionary *currencySettings = [self getRate:localCurrencyCode convertCurrencyCode:convertCurrencyCode];
        NSLog(@"%@", currencySettings[@"rate"]);
        if ([currencySettings count]) {
            // ユーザデフォルトに、通貨・レートの情報を"currencyDefault"という名前で保存
            [currencyDefaults setObject:currencySettings forKey:@"currencyDefault"];
            [currencyDefaults synchronize];
            //dismissViewControllerAnimatedで親画面に遷移
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self showAlert :nil];
        }
        

    }

}


//API通信エラーの際に「再試行」のアラートを表示
- (void)showAlert:(NSString*)text
{

        // UIAlertViewを使ってアラートを表示
        UIAlertView *apiAlert = [[UIAlertView alloc] initWithTitle:@"再試行してください"
                                                        message:text
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [apiAlert show];

}


//APIを読み出すためのメソッド
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
        dictionary=[NSDictionary new];
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
    if (rate) {
        [currencySettings setObject:localCurrencyCode forKey:@"localCurrencyCode"];
        [currencySettings setObject:convertCurrencyCode forKey:@"convertCurrencyCode"];
        [currencySettings setObject:rate forKey:@"rate"];
    }

    return currencySettings;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)tapBackButton:(id)sender {
    
    //dismissViewControllerAnimatedで親画面に遷移
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
