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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TableView
    _withdrawalArray =@[@"引き出し額",@"手数料"];
    self.withdrawalTableView.delegate = self;
    self.withdrawalTableView.dataSource = self;
    
    //今日の日付をラベルに表示
    self.todayLabel.text = self.selectedDate;
    
    
    //modalViewを作成
    _textView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 250)];
    
    
    //色の配合の仕方を調整
    _textView.backgroundColor = [UIColor colorWithRed:0.192157 green:0.760784 blue:0.952941 alpha:0.2];
    
    //まだ隠れている状態＝NOとする
    _viewFlag = NO;
    
    [self.view addSubview:_textView];
    

    
    //テキストフィールドを作成
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
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, _adView.frame.size.width, _adView.frame.size.height)];
    
    _adView.delegate = self;
    
    
    //アドビューをつくる
    [self.view addSubview:_adView];
    
    //透明度を0にする
    _adView.alpha =0.0;

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
    
    
    //！金額設定用のViewを設定
    
    //どこに移動するかを指定
    
    //modalViewをにゅっとだすよ
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
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



//コアデータ
//- (void)cancel:(id)sender {
//    if(tapCancel) {
//        // 新規オブジェクトのキャンセルなので、呼び出し元で挿入したオブジェクトを削除します。
//        NSManagedObjectContext *context = editingObject.managedObjectContext;
//        [context deleteObject:editingObject];
//        NSError *error = nil;
//        if (![context save:&error]) {
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//    [self.navigationController dismissModalViewControllerAnimated:YES];
}

//- (void)save:(id)sender {
//    // テキストフィールドの内容をキー"name"にセットして変更を保存します。
//    [editingObject setValue:textField.text forKey:@"name"];
//    if(newObject&&[editingObject.entity.name isEqualToString:@"SecondLevel"]) {
//        // SecondLevelでは新規作成のオブジェクトを上位のRootLevelと関連をさせる必要があります。
//        FirstCoreDataAppDelegate *appDelegate =
//        (FirstCoreDataAppDelegate *)[[UIApplication sharedApplication] delegate];
//        // このビューの呼び出し元はアプリケーションデリゲートで作ったナビゲーションコントローラーで
//        // 現在一番上に表示されています。
//        SecondLevelViewController *controller =
//        (SecondLevelViewController *)[appDelegate.navigationController topViewController];
//        //呼び出し元のRootLevelのsecondLevelsにeditingObjectを追加します。
//        [controller.rootLevel addSecondLevelsObject:editingObject];
//    }
//    NSManagedObjectContext *context = editingObject.managedObjectContext;
//    NSError *error = nil;
//    if (![context save:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    [self.navigationController dismissModalViewControllerAnimated:YES];
//}


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
        banner.frame = CGRectOffset (banner.frame, 0,self.view.bounds.size.height - banner.frame.size.height);
        //banner.frame = CGRectOffset(banner.frame, 0, 300);
        
        
        //透明度を0から1にして、見えるようになった。
        banner.alpha = 1.0;
        
        //beginAnimations に対して、　commitAnimations でここで終わり！って意味
        [UIView commitAnimations];
        
        //表示したので、isVisibleをYESにする
        _isVisible = YES;
    }

}


//-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//    {
//        //<>が付くのはプロトコル→idの詳細を説明
//        //[[self.fechedResultsController sections]objectAtIndex:section]は｛(1+1)×２｝と一緒
//        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fechedResultsController sections]objectAtIndex:section];
//        
//        //コアデータに入ってるデータの数
//        return [sectionInfo numberOfObjects];
//        
//    }
//
//
//-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//    {
//        //定数を宣言
//        static NSString *cellIdentifier = @"cell";
//        
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        
//        if (cell==nil){
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            
//        }
//        
//        //コアデータの中身をTableViewに表示する
//        cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
////        
////        //placeというコアデータの0番目のデータをとってきて返す
////        Place *place = [self.fechedResultsController objectAtIndexPath:indexPath];
////        
////        //メッセージ構文の中身を返す
////        cell.textLabel.text = [place.name description];
////        
//        return cell;
//        
//        
//    }
//    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//????
//- (void) push{
//    NSLog(@"push!");
//    [delegate dismissViewWillClose];
//    
//}



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
//保存ボタンが押された時
//- (IBAction)tapSave:(id)sender {
//    
//    //入力した金額をユーザーデフォルトに保存する
//    NSUserDefaults *_hikidashigakuDefaults = [NSUserDefaults standardUserDefaults];
//    if (_hikidashiFlag == YES) {
//        
//        NSString *_hikidashi = _hikidashiTextField.text;
//        [_hikidashigakuDefaults setObject:_hikidashi forKey:@"hikidashi"];
//    }
//    else{
//        NSString *_tesuryou = _tesuryouTextField.text;
//        //？　_tesuryouがnil
//        [_hikidashigakuDefaults setObject:_tesuryou forKey:@"tesuryou"];
//        
//        
//    }
//    
//    [_hikidashigakuDefaults synchronize];
//    
//    
//    NSLog(@"hikidashi=%@",[_hikidashigakuDefaults objectForKey:@"hikidashi"]);
//    NSLog(@"tesuryou=%@",[_hikidashigakuDefaults objectForKey:@"tesuryou"]);
//    
//    
//    
//    //ハコからデータをとりだす
//    NSString *hikidashi = [_hikidashigakuDefaults stringForKey:@"hikidashi"];
//    NSString *tesuryou = [_hikidashigakuDefaults stringForKey:@"tesuryou"];
//    
//    
//    //取り出したデータを%@に指定する
//    NSArray *_kingakuArray = @[[NSString stringWithFormat:@"引き出し額 %@",hikidashi],[NSString stringWithFormat:@"手数料学 %@",tesuryou]];
//    
//    
//    
//    //入力した内容を初期化する
//    //    [self.hikidashiTextField reloadData];
//    
//
//    
//    int d= 0;
//    
//    
//    NSString *hikidashiString=@"";
//    
//
//   self.hikidashiTextField.text=hikidashiString;
//    
//    //取り出したデータを%@に指定する
////    _budgetArray =@[[NSString stringWithFormat:@"予算額(%@) %@",app._convertCurrency,budget],[NSString stringWithFormat:@"給与額(%@) %@",app._convertCurrency,income],[NSString stringWithFormat:@"給料日 %@",Kyuryoubi],[NSString stringWithFormat:@"開始日 %@",Kaishibi],[NSString stringWithFormat:@"終了日 %@",Syuryoubi]];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//    
//    
//    }




@end

