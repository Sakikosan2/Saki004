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
    //dismissViewControllerAnimatedで親画面に遷移
    NSLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //
    [self getRate];
 
    
}
//APIを読み出すためのメソッド
-(void)getRate
{
    //APIの元のURLの呼び出し
    NSString *orign =@"http://rate-exchange.appspot.com/currency";
    NSLog(@"元のURlは%@",orign);
    
    
    //プロパティからデータを取り出して指定
    //? jpyとphpに指定してるから、ずっと0.4ていう値なの?
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
        //? 
        fromCode = [dictionary valueForKeyPath:@"from"];
        rate  = [dictionary  valueForKeyPath:@"rate"];
        toCode = [dictionary valueForKeyPath:@"to"];
    }
    //エラーが起きた時どうするか
    @catch (NSException *exception) {
        fromCode = nil;
    }
    
    
    
    //JSONをパースで取れなかった時→前回保存したデータから取り出す
    NSUserDefaults *apiDefaults = [NSUserDefaults standardUserDefaults];
    
    if (fromCode ==nil) {
        
        //UserDefaultsにデータが存在するかチェック
        if ([apiDefaults objectForKey:@"rate"]==nil) {
            //UserDefaultsにも入っていない場合は暫定の値をセット
            fromCode = @"usd";
            rate = @"100";
            toCode =@"jpy";
            
        }else{
            fromCode = [apiDefaults objectForKey:@"from"];
            rate  = [apiDefaults  objectForKey:@"rate"];
            toCode = [apiDefaults objectForKey:@"to"];
            
        }
        
        
    }else{
        //APIで値がとれたのでUserDefaultsに保存
        [apiDefaults setObject:rate forKey:@"rate"];
        [apiDefaults setObject:fromCode forKey:@"from"];
        [apiDefaults setObject:toCode forKey:@"to"];
        
        NSLog(@"ユーザーデフォルトに保存するレートは=%@",[apiDefaults objectForKey:@"rate"]);
        NSLog(@"ユーザーデフォルトに保存する現地通貨は=%@",[apiDefaults objectForKey:@"from"]);
        NSLog(@"ユーザーデフォルトに保存する換算通貨は=%@",[apiDefaults objectForKey:@"to"]);
    
        
        [apiDefaults synchronize];
        
    }
    
}

    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
