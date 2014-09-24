//
//  FourtthViewController.m
//  
//
//  Created by 丸山　咲 on 2014/09/16.
//
//

#import "FourtthViewController.h"
#import "dateViewController.h"
#import "budgetViewController.h"


@interface FourtthViewController ()
{
    NSArray *_budgetArray;
    
    //広告
    ADBannerView *_adView;
    
    BOOL _isVisible;

    
}

@end

@implementation FourtthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//TableViewに予算設定画面を設定する
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ユーザーデフォルトで入力したデータを取り出す
    
    
    //ローカル変数。別々のmethodに同じ変数をセットしてもエラーにならない
    NSUserDefaults *myDefaults = [NSUserDefaults standardUserDefaults];
    //ハコからデータをとりだす
    NSString *Kyuryoubi = [myDefaults stringForKey:@"Kyuryoubi"];
    
    //取り出したデータを%@に指定する
    
    
    _budgetArray =@[@"予算入力",@"給与額入力",[NSString stringWithFormat:@"給料日%@",Kyuryoubi]];
    
    
    
    self.setBTableView.delegate = self;
    self.setBTableView.dataSource = self;
    
    
    //広告
    //バナーオブジェクト生成
    _adView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -_adView.frame.size.height, _adView.frame.size.width, _adView.frame.size.height)];
    
    _adView.delegate = self;
    
    
    //アドビューをつくるよ！このビューの一部に部品を追加する
    [self.view addSubview:_adView];
    
    
    //透明度を0にする
    _adView.alpha =0.0;
    
    
    //NOでなくてはいけない。
    _isVisible = NO;
    

    
}


//TableView

//セクション数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


//セクションのタイトル文字
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"予算設定";
        
    }
    if (section == 1) {
        return @"日付設定";
        
    }
    return 0;
    
    
    
}



//行数を返す
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return _budgetArray.count;
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    
    return 0;
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
    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = _budgetArray[indexPath.row];
        
    }else{
        
        cell.textLabel.text = _budgetArray[indexPath.row+2];
        
    }
    
    return cell;
    
}

//セルが選択されたとき何を実行するか

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //セクションを宣言
    int section = indexPath.section;
    
    if (section ==0) {
        //どこに移動するかを指定
        budgetViewController *dvd =[self.storyboard instantiateViewControllerWithIdentifier:@"budgetViewController"];
        
        //ナビゲーションコントローラーの機能で画面遷移
        [[self navigationController] pushViewController:dvd animated:YES];
        
    }
    else{
        dateViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"dateViewController"];
        
        [[self navigationController] pushViewController:dvc animated:YES];

    }
    
   
    NSLog(@"%ld",(long)indexPath.section);
    
    
    
    
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
    
}


@end
