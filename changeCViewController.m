//
//  changeCViewController.m
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "changeCViewController.h"
#import "ThirdViewController.h"





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
    
    
    //※メインストーリーボードで、delegateとDataSourceを関連付ける
    
    //Plistからデータを取り出す。 ※Dictionary型の部分全体を取り出す
    NSDictionary *currencyData = _currencyList[indexPath.row];
    
    //plistのnameのデータを取り出す
    NSString *currencyName = [currencyData objectForKey:@"name"];
    NSString *currencyCode = [currencyData objectForKey:@"code"];
    
    
    
    //表示する文字列を作成
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",currencyName,currencyCode];
    
    

    
    return cell;
    
    
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //selectnamと同じやり方で選ばれたコードをプロパティに渡す
    _currencyList = @[@"コロンビア",@"カフェベロナ",@"ケニア",@"スマトラ",@"ハウスブレンド",];
    
    //self.を省略
    //クリックしたときに画面遷移したあとのLabelに配列の中身を投影する
    self.resultLabel.text = _currencyList[_selectnum];
    
    
    
    
    
//    switch (self.selectnum) {
//        case 0:
//            //コロンビア
//            self.description.text =@"ナッツのような風味とバランスのよさが特徴\nなめらかでほどよいコク、さわやかな酸味と上質なナッツのようまで残る、バランスのとれたコーヒー。秘峰アンデス山脈の高地で栽培されたコーヒーです。\nコロンビアは、クルミやピーカンナッツなどナッツ類を使用したフードととても相性のいいコーヒーです。ほどよいコクとなめらかさがあり、フードの生地感も中程度のものをおすすめします。";
//            
//            //imagepictureを利用して、コーヒーの写真を貼る
//            self.coffeepicture.image=[UIImage imageNamed:@"columbia.jpg"];
//            
//            
//            break;
//            
//            
//        case 1:
//            //カフェベロナ
//            self.description.text = @"ローストの深みや甘みが特徴のブレンド\nダークココアのような口あたり、ロースト感のある深みや甘みと、しっかりとしたコクの奥行きのある豊かなブレンド。イタリアン ローストによる深みが加わっています。\nカフェ ベロナは、チョコレートととても相性のいいコーヒーです。カラメルシュガーとも合います。しっかりとしたコクやイタリアン ローストの甘い風味がありますので、フードの生地感もしっかりとしたものをおすすめします。";
//            self.coffeepicture.image=[UIImage imageNamed:@"Velona.jpg"];
//            
//            break;
//            
//            
//        case 2:
//            //ケニア
//            self.description.text = @"爽やかな柑橘系の風味とジューシーな酸味\nグレープフルーツ、ブラックカラントや新鮮なブラックベリーなどの風味とジューシーな酸味やしっかりとしたコクが複雑に幾重にも重なった、大らかさが特徴です。\nケニアは、グレープフルーツやオレンジ、カシスやレーズン、ベリー類と相性のいいコーヒーです。しっかりとしたコクがありますので、フードの生地感も中程度からややしっかりとしたものをおすすめします。明るい酸味がありますので、酸味のあるフードともよく合います。";
//            
//            self.coffeepicture.image=[UIImage imageNamed:@"Kenya.jpg"];
//            
//            break;
//            
//            
//            
//        case 3:
//            //スマトラ
//            self.description.text = @"濃厚なコクと、心安らぐ大地を思わせる味わい\n重厚で深みのあるしっかりとしたコク、かすかなハーブやスパイスの香りと長く続く大地を思わせる風味が特徴です。忘れがたい印象を残してくれるコーヒーです。nスマトラは、シナモン、オートミール、メープル、バター、トフィー、チーズと相性のいいコーヒーです。どっしりと重厚なコクがありますので、フードの生地感もしっかりとしたものをおすすめします。きのこを使用したフードともよく合います。";
//            
//            self.coffeepicture.image=[UIImage imageNamed:@"Sumatora.jpg"];
//            
//            break;
//            
//            
//        case 4:
//            //ハウスブレンド
//            self.description.text = @"スターバックス創業時からお届けしているブレンド\nナッツとカカオのニュアンスにローストによるかすかな甘み、そこに酸味とコクが見事なほどに調和した風味が特徴です。創業当初よりお届けしてきたおもてなしの心あふれるブレンドです。\nハウス ブレンドは、ナッツの入ったクッキーやペストリー、りんごやブルーベリーのスコーンやマフィン、パンケーキなどとよく合いますよ。ほどよいコクのコーヒーなので、フードの生地感も中程度のものをおすすめします。";
//            self.coffeepicture.image=[UIImage imageNamed:@"House.jpg"];
//            
//            
//        default:
//            break;
    
            
            
//    }
    
    
    
    
    NSLog(@"dismiss");
    //dismissViewControllerAnimatedで子の画面を消してる
    [self dismissViewControllerAnimated:YES completion:nil];
    

}


//-(void)tableView:(UITableView *)tableView didselectRowAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    NSLog(@"dismiss");
//    //dismissViewControllerAnimatedで子の画面を消してる
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    
//    
////    ThirdViewController *thirdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdViewController"];
////    
////    [[self navigationController] pushViewController:thirdViewController animated:YES];
////    
////    
////    //押された行の行番号を返す
////    NSLog(@"セグエを使って画面遷移しました！行=%d",self.currencyTableView.indexPathForSelectedRow.row);
////
//////-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//
//
//
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
