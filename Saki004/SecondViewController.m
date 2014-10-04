//
//  SecondViewController.m
//  Saki003
//
//  Created by 丸山　咲 on 2014/09/10.
//  Copyright (c) 2014年 Saki Maruyama. All rights reserved.
//

#import "SecondViewController.h"


@interface SecondViewController ()
{
    //バナー広告
    ADBannerView *_adView;
    
    //テキストフィールドを乗せるView
    UIView *_textView;
    BOOL _viewFlag;
    UITextField *_hikidashiTextField;
    UITextField *_tesuryouTextField;
    
    
    
    
    BOOL _isVisible;
    
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
    
    //②水色のビューを作成
    _textView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 250)];
    
    
    //色の配合の仕方を調整
    _textView.backgroundColor = [UIColor colorWithRed:0.192157 green:0.760784 blue:0.952941 alpha:1.0];
    
    //まだ隠れている状態＝NOとする
    _viewFlag = NO;
    
    [_textView addSubview:_textView];
    
    
    
    
    //テキストフィールドを作成
    _hikidashiTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    
    _hikidashiTextField.backgroundColor = [UIColor colorWithRed:0.78 green:0.27 blue:0.99 alpha:0.6];
    
    [_hikidashiTextField addTarget:self action:@selector(tapReturn) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    [_textView addSubview:_hikidashiTextField];
    
    
    
    
    //バナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -_adView.frame.size.height, _adView.frame.size.width, _adView.frame.size.height)];
    
    _adView.delegate = self;
    
    
    //アドビューをつくるよ！このビューの一部に部品を追加する
    [self.view addSubview:_adView];
    
    
    //透明度を0にする
    _adView.alpha =0.0;
    
    
    //NOでなくてはいけない。
    _isVisible = NO;
    
    
    
    
//    //コアデータ
//    self.managedObjectContext = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//    
    

    

}

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
        
        //
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
        
        //nilじゃなくて、データが入っていたら、そのデータをそのまま返す。
        if (_fechedResultController) {
            return _fechedResultController;
            
        }
        
        //nil　のとき
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
        
//        NSError *error = nil;
//        
//        if ([NSFetchedResultsController performFetch:&error]==NO)
//        {
//            
//            abort();
//            
//        }
//        
        return _fechedResultController;
        //コロンのあとはかならず引き数
        
        
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


- (IBAction)tapCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)tapSave:(id)sender {
}





//引き出し額と手数料の入力
- (IBAction)insertHikidashi:(id)sender {
     self.hikidashiTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.hikidashiTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
     [_textView addSubview:_hikidashiTextField];
}


- (IBAction)insertTesuryou:(id)sender {
     self.tesuryouTextField.keyboardType = UIKeyboardTypeNumberPad;
}
@end

