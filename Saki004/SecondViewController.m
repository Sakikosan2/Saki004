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
    BOOL _viewFlag;
    UITextField *hikidashiTextField;
    UITextField *tesuryouTextField;
    
    
    
    
    BOOL _isVisible;
    
    //引き出し額をユーザーデフォルトに保存
    BOOL _hikidashiFlag;
    //手数料額をユーザーデフォルトに保存
    BOOL _tesuryouFlag;
    
    NSArray *_kingakuArray;
    
    
    
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    
    //バナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -_adView.frame.size.height, _adView.frame.size.width, _adView.frame.size.height)];
    
    _adView.delegate = self;
    
    
    //アドビューをつくる
    [self.view addSubview:_adView];
    
    //透明度を0にする
    _adView.alpha =0.0;

    _isVisible = NO;
    
    //コアデータ
    self.managedObjectContext = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    
    self.hikidashiTextField.delegate = self;
//    self.hikidashiTextField.dataSource = self;
    

    

}

//コアデータ
- (void)cancel:(id)sender {
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
        banner.frame = CGRectOffset (banner.frame, 0, 20);
        
        //透明度を0から1にして、見えるようになった。
        banner.alpha = 1.0;
        
        //beginAnimations に対して、　commitAnimations でここで終わり！って意味
        [UIView commitAnimations];
        
        //表示したので、isVisibleをYESにする
        _isVisible = YES;
        
    }
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        //<>が付くのはプロトコル→idの詳細を説明
        //[[self.fechedResultsController sections]objectAtIndex:section]は｛(1+1)×２｝と一緒
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fechedResultsController sections]objectAtIndex:section];
        
        //コアデータに入ってるデータの数
        return [sectionInfo numberOfObjects];
        
    }


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        //定数を宣言
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        
        //コアデータの中身をTableViewに表示する
        cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
//        
//        //placeというコアデータの0番目のデータをとってきて返す
//        Place *place = [self.fechedResultsController objectAtIndexPath:indexPath];
//        
//        //メッセージ構文の中身を返す
//        cell.textLabel.text = [place.name description];
//        
        return cell;
        
        
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


//保存ボタンが押された時
- (IBAction)tapSave:(id)sender {
    
    //  10/7  入力した値をテキストフィールドに表示する
//    NSLog(@"引き出し額は[%@]");
    
    int d= 0;
    
    
    NSString *hikidashiString=@"";
    

   self.hikidashiTextField.text=hikidashiString;
    
    //取り出したデータを%@に指定する
//    _budgetArray =@[[NSString stringWithFormat:@"予算額(%@) %@",app._convertCurrency,budget],[NSString stringWithFormat:@"給与額(%@) %@",app._convertCurrency,income],[NSString stringWithFormat:@"給料日 %@",Kyuryoubi],[NSString stringWithFormat:@"開始日 %@",Kaishibi],[NSString stringWithFormat:@"終了日 %@",Syuryoubi]];
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
    
    }

//決定ボタンが押された時
- (IBAction)tapDecideAmount:(id)sender {
    
    NSLog(@"引き出し額確定");
    
    //キーボードを閉じる
    [self.hikidashiTextField resignFirstResponder];
    [self.tesuryouTextField  resignFirstResponder];

    //入力した金額をユーザーデフォルトに保存する
    NSUserDefaults *_hikidashigakuDefaults = [NSUserDefaults standardUserDefaults];
    if (_hikidashiFlag == YES) {
        
        NSString *_hikidashi = _hikidashiTextField.text;
        [_hikidashigakuDefaults setObject:_hikidashi forKey:@"hikidashi"];
    }
    else{
        NSString *_tesuryou = _tesuryouTextField.text;
        //？　_tesuryouがnil
        [_hikidashigakuDefaults setObject:_tesuryou forKey:@"tesuryou"];
        
        
    }
    
    [_hikidashigakuDefaults synchronize];
    
    
    NSLog(@"hikidashi=%@",[_hikidashigakuDefaults objectForKey:@"hikidashi"]);
    NSLog(@"tesuryou=%@",[_hikidashigakuDefaults objectForKey:@"tesuryou"]);
    
    
    
    //ハコからデータをとりだす
    NSString *hikidashi = [_hikidashigakuDefaults stringForKey:@"hikidashi"];
    NSString *tesuryou = [_hikidashigakuDefaults stringForKey:@"tesuryou"];
    
    
    //取り出したデータを%@に指定する
     NSArray *_kingakuArray = @[[NSString stringWithFormat:@"引き出し額 %@",hikidashi],[NSString stringWithFormat:@"手数料学 %@",tesuryou]];
    
    
    
    //入力した内容を初期化する
//    [self.hikidashiTextField reloadData];
    
    
    

    
    
}




//!!!!!modalViewが出ない
//引き出し額の入力
- (IBAction)insertHikidashi:(id)sender {
    
    [self.hikidashiTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    [self.hikidashiTextField addSubview:_hikidashiTextField];

    
    
    //modalViewをにゅっとだすよ
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
            
    //   [self downObjects];
            
    _textView.frame = CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 250);
            
    _viewFlag = YES;
    
    [self.view addSubview:_textView];


    
    [UIView commitAnimations];
    
    
}


- (IBAction)insertTesuryou:(id)sender {
     self.tesuryouTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    //modalViewをにゅっとだすよ
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    //   [self downObjects];
    
    _textView.frame = CGRectMake(0, self.view.bounds.size.height-250, self.view.bounds.size.width, 250);
    
    _viewFlag = YES;
    
    [UIView commitAnimations];
    [_tesuryouTextField addSubview:_tesuryouTextField];
    
    [self.view addSubview:_textView];
}
@end

