//
//  SecondViewController.m
//  Saki003
//
//  Created by 丸山　咲 on 2014/09/10.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "FourtthViewController.h"
#import "Withdrawalmemo.h"

//@implementation openview
//@synthesize delegate;
//
//- (void)dealloc
//{
//    [super dealloc];
//}
//
//
//@end

@interface SecondViewController ()
{
    //バナー広告
    ADBannerView *_adView;
    
    //テキストフィールドを乗せるView
    UIView *_textView;
    //引き出し額を入力するテキストフィールド
    UITextField *_withdrawalTextField;
    
    //Doneボタンをメンバ変数にする
    UIButton *_doneButton;
    
    //引き出し額と手数料額のメンバ変数
    NSString *_withdrawalPrice;
    NSString *_commisionprice;
    

    BOOL _viewFlag;
    BOOL _isVisible;
    BOOL _withdrawalFlag;

    
    //TableView
    NSArray *_withdrawalArray;
    
    
}


@end

@implementation SecondViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    //取り出した引き出し額と手数料のメンバ変数を%@に指定する
    _withdrawalArray =@[[NSString stringWithFormat:@"引き出し額 %@",_withdrawalPrice],[NSString stringWithFormat:@"手数料 %@",_commisionprice]];
    
    self.withdrawalTableView.delegate = self;
    self.withdrawalTableView.dataSource = self;
    
    //入力した内容を初期化する
    [self.withdrawalTableView reloadData];
}


//画面が表示された時
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //今日の日付をラベルに表示
    self.todayLabel.text = self.selectedDate;
    
    
    //TableView
    _withdrawalArray =@[@"引き出し額",@"手数料"];
    self.withdrawalTableView.delegate = self;
    self.withdrawalTableView.dataSource = self;
    
    
    //modalViewを作成
    _textView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 50)];
    //色の配合の仕方を調整
    _textView.backgroundColor = [UIColor colorWithRed:0.192157 green:0.760784 blue:0.952941 alpha:0.2];
    //まだ隠れている状態＝NOとする
    _viewFlag = NO;
    [self.view addSubview:_textView];
    

    
    //テキストフィールドを_textViewの上に作成
    _withdrawalTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-100, 40)];
    _withdrawalTextField.backgroundColor = [UIColor grayColor];
    _withdrawalTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_textView addSubview:_withdrawalTextField];
    [self.view addSubview:_textView];
    
    
    //Doneボタンを作成
    _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, 0, 100, 40)];
    [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_doneButton addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:_doneButton];
    

    //バナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, 0, _adView.frame.size.width, _adView.frame.size.height)];
    _adView.delegate = self;
    //アドビューをつくる
    [self.view addSubview:_adView];
    //透明度を0にする
    _adView.alpha =0.0;
    //フラグがNOの時にこの処理をする
    _isVisible = NO;
    
    
    //コアデータ
    self.managedObjectContext = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    


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
    return @"引き出し額入力";
    
}


//行数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _withdrawalArray.count;
    
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
    cell.textLabel.text = _withdrawalArray[indexPath.row];
    
    
    return cell;
    
}

//Viewを下げる自作メソッド
-(void)downObjects
{
    //ボタンとViewが表示されてボタンが押された場合は全体が下がる処理
    _textView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 250);
    
    //キーボードを下げる
    [_withdrawalTextField resignFirstResponder];
    
    _viewFlag = NO;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"おしたよー");
    
    //テキストフィールドに残った文字を空にする
    _withdrawalTextField.text = @"";
    
    //modalViewをにゅっとだすよ
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    //キーボードを下げる
    [self downObjects];
    
    _textView.frame = CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 250);
    
    _viewFlag = YES;
    
    
    
    [UIView commitAnimations];
    
    //キーボードを最初から表示する
    [_withdrawalTextField becomeFirstResponder];
    

    
    if (indexPath.row ==0) {
        
        _withdrawalFlag = YES;
    }
    else
    {
        _withdrawalFlag = NO;
    }


}

//FetchedResultsControllerのデータセット
-(NSFetchedResultsController *) fechedResultsController{
        
        //データが入っているとき = そのデータをそのまま返す
        if (_fechedResultController) {
            return _fechedResultController;
            
        }
        
        //nilのとき
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Place" inManagedObjectContext:self.managedObjectContext];
        
        //一行ずつデータを取得する
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        
        //なんのモデルを取り出すのかを指定。FetchRequestはEntityじゃないとだめ。
        [fetchRequest setEntity:entity];
        
        //一度にコアデータの中から何データをとってくるか（コアデータから何件ずつとってくるかをかくだけ）
        [fetchRequest setFetchBatchSize:20];
        
        //そのリストをどんな順序で並べるのか　ascending:並べ方　Yes:昇順、No:降順
        //条件を複数個指定できるため、配列型
        [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO],]];
        
        
        //fechedResultControllerの初期化
        //「cache」同じキャッシュの場合、削除する。cachenemaはなんでも可。
        _fechedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"ViewController"];
        
        
        _fechedResultController.delegate = self;
        return _fechedResultController;
        
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
        banner.frame = CGRectOffset(banner.frame, 0, self.view.bounds.size.height - banner.frame.size.height);
        //banner.frame = CGRectOffset(banner.frame, 0, 300);
        
        
        //透明度を0から1にして、見えるようになった。
        banner.alpha = 1.0;
        
        //beginAnimations に対して、　commitAnimations でここで終わり！って意味
        [UIView commitAnimations];
        
        //表示したので、isVisibleをYESにする
        _isVisible = YES;
    }
    
}

//広告でエラーが発生した場合
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


//キャンセルボタンがTapされたとき
- (IBAction)tapCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Doneボタンが押された時
-(IBAction)tapBtn:(id)sender
{
    //入力した金額をメンバ変数に保存
    if (_withdrawalFlag == YES) {
        _withdrawalPrice = _withdrawalTextField.text;
        
    }
    else{
        _commisionprice = _withdrawalTextField.text;
    }
    
    //キーボードを下げる
    [self downObjects];
    
    //取り出した引き出し額と手数料のメンバ変数を%@に指定する
    _withdrawalArray =@[[NSString stringWithFormat:@"引き出し額 %@",_withdrawalPrice],[NSString stringWithFormat:@"手数料 %@",_commisionprice]];
    
    //入力した内容を初期化する
    [self.withdrawalTableView reloadData];

}
    
//Coredata
//保存ボタンが押された時
-(IBAction)tapSave:(id)sender{
    
    
    
    //大文字のWithdrawalmemoはkey
    //小文字は変数名
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    Withdrawalmemo *withdrawalmemo =[NSEntityDescription insertNewObjectForEntityForName:@"Withdrawalmemo" inManagedObjectContext:context];

    // withdrawalpriceがNSNumberでないといけないので、_withdrawlPriceの文字列を一度Integerにして、NSNumber numberWithIntでNSNumber化
    withdrawalmemo.withdrawalprice = [NSNumber numberWithInt:[_withdrawalPrice integerValue]];
    withdrawalmemo.commissionprice = [NSNumber numberWithInt:[_commisionprice integerValue]];

    //データモデルにセットされたデータをCoreDataに保存
    NSError *error =nil;
    
    //CoreDataにデータを追加している
    if ([context save:&error] == NO) {
            abort();
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

