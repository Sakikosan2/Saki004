//
//  changeCViewController.m
//  Saki004
//
//  Created by 丸山　咲 on 2014/09/15.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "changeCViewController.h"




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
