//
//  CarWithNameListViewController.m
//  YiPei
//
//  Created by daichuanning on 13-11-30.
//  Copyright (c) 2013年 lee. All rights reserved.
//

#import "CarWithNameListViewController.h"
#import "UINavigationView.h"
#import "fenLeiFunc.h"
#import "FenLeiCell.h"
#import  "FenLeiCell2.h"
#import "FenLeiListViewController.h"

#import "CarSortWithNameListViewController.h"
@interface CarWithNameListViewController ()
@property(nonatomic,strong) IBOutlet UINavigationView * headNav;

@property(nonatomic,strong) fenLeiFunc *feiLFunction;
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;
@end

@implementation CarWithNameListViewController


@synthesize headNav = _headNav;

@synthesize isOpen = _isOpen;
@synthesize selectIndex = _selectIndex;
@synthesize listTableView=_listTableView;


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
    // Do any additional setup after loading the view from its nib.
    
    _feiLFunction = [[fenLeiFunc alloc] init];
    _feiLFunction.delegateGoodsCateByPid = self;
    [_feiLFunction getGoodsCateByPid:@"0"];
     [self initLeftBarButtonItem];
    [self initRightBarButtonItem];
    
}

-(void)initLeftBarButtonItem{
    
    [_headNav initWithLeftBarItemWithTitle:@"" withFrame:CGRectMake(10, 7, 50, 30)  withAction:@selector(leftBarItemClick) withButtonImage:[UIImage imageNamed:@"topbtn_back.png"] withHighlighted:[UIImage imageNamed:@"topbtn_back_press.png"] withTarget:self];
    
    
}
-(void)leftBarItemClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) didGoodsCategoryByPidDataSuccess : (id)data
{
    NSLog(@"didGoodsCategoryByPidDataSuccess!");
    self.isOpen = NO;
    
    NSArray *cbData = (NSArray *)data;
//    _reloadArray = [[NSMutableArray alloc] init];
    NSMutableDictionary * dic ;
    NSMutableArray  * arry;
    
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    for (int i=0; i<cbData.count; i++) {
        
        arry = [[NSMutableArray alloc] init];
        dic = [[NSMutableDictionary alloc] init];
        [dic setValue:arry forKey:[[NSString alloc] initWithFormat:@"%d",i]];
        [dic setValue:[[cbData objectAtIndex:i] objectForKey:@"cat_name"] forKey:@"name"];
        [dic setValue:[[cbData objectAtIndex:i] objectForKey:@"cat_id"] forKey:@"cat_id"];
        [dic setValue:[[cbData objectAtIndex:i] objectForKey:@"category_img"] forKey:@"category_img"];
        
        [tempArray addObject:dic];
        
    }
    
    
    listArray = [[NSMutableArray alloc]initWithArray:tempArray];
    
   
    
    [_listTableView reloadData];
    _listTableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
}


-(void)initRightBarButtonItem{
    
    [_headNav initWithRightBarItemWithTitle:@"" withFrame:CGRectMake(280,7, 30, 30)  withAction:@selector(rightBarItemClick) withButtonImage:[UIImage imageNamed:@"topbtn_cart.png"] withHighlighted:nil withTarget:self];
    
    
}
-(void)rightBarItemClick{
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isOpen) {
        if (self.selectIndex.section == indexPath.section) {
            if(indexPath.row==0){
                return 64;
            }
            return 45;;
        }
    }
    
    return 64;
}




//返回有多少个TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [listArray count];//
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return [fenLeiDataArray count];
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            NSString * rowStr = [NSString stringWithFormat:@"%i",section];
            NSMutableDictionary * dic = [listArray objectAtIndex:section];
            NSMutableArray * array = [dic objectForKey:rowStr];
            return [array count]+1;;
        }
    }
    return 1;
    //    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        static NSString *CellIdentifier = @"FenLeiCell2";
        FenLeiCell2 *cell = (FenLeiCell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
            UIImageView * backIamge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteColor.png"]];
            cell.backgroundView = backIamge;
            
        }
        NSString * str = [NSString stringWithFormat:@"%i",indexPath.section];
        NSMutableDictionary * dic = [listArray objectAtIndex:indexPath.section];
        //         [cell cellBackgroundColor ];
        
        NSArray *list = [dic objectForKey:str];
        
        NSLog(@"%d",indexPath.row-1);
        //
        NSDictionary* category = (NSDictionary*)[list objectAtIndex:indexPath.row-1];
        cell.titleLabel.text = [category objectForKey:@"cat_name"];
        cell.titleLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1.0];
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"FenLeiCell";
        FenLeiCell *cell = (FenLeiCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        //        cell.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        if (indexPath.row==0) {
            cell.frame = CGRectMake(0, 0, 0, 0);
        }
        
        //        NSString * str = [NSString stringWithFormat:@"%i",indexPath.row+1];//应为第零个不显示
        
        NSMutableDictionary * dic = [listArray objectAtIndex:indexPath.section];
        
        
        //        NSMutableArray * array = [[_fenLeiDataArray objectAtIndex:indexPath.section] objectForKey:str];
        //        NSLog(@"array=%@",array);
        
        NSString *name = [dic objectForKey:@"name"];
        cell.titleLabel.text = name;
        cell.titleLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1.0];
        UIImage * image;
        NSString *imageurl = [dic objectForKey:@"category_img"];
        if (![imageurl isEqualToString:@""]) {
            image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageurl]]];
        }
        else
        {
            image =[UIImage imageNamed:@"bg_brand_hot.png"];
        }
        
        [cell showImage:image];
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
    }
}


#pragma mark - Table view delegate
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO   nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES  nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO  nextDo:YES];
            }
        }
        
    }else
    {
        //        dd
        //        NSDictionary *dic = [_fenLeiDataArray objectAtIndex:indexPath.section];
        //        NSArray *list = [dic objectForKey:@"name"];
        //        NSString *item = [list objectAtIndex:indexPath.row-1];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:item message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
        //        [alert show];
//        GuolvViewController * viewC = [[GuolvViewController alloc] init];
//        
       CarSortWithNameListViewController * listView = [[CarSortWithNameListViewController alloc] init];
        [self.navigationController pushViewController:listView animated:YES];
//        self.selectIndex = nil;
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert  nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    FenLeiCell *cell = (FenLeiCell *)[_listTableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [_listTableView beginUpdates];
    
    int section = self.selectIndex.section;
    NSString * str = [NSString stringWithFormat:@"%i",self.selectIndex.section ];
    NSMutableDictionary * dic =[listArray objectAtIndex:self.selectIndex.section];
    
    NSArray * array = [dic objectForKey:str];
    if (array.count == 0) {
        array = [_feiLFunction getGoodsSubCateByPId:[dic objectForKey:@"cat_id"]];
        [dic setValue:array forKey:str];
    }
    int contentCount = [array count];
    
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert)
    {   [_listTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [_listTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    
	
	[_listTableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [_listTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES   nextDo:NO ];
    }
    if (self.isOpen) [_listTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end