//
//  ViewController.m
//  SearchGitHubUser
//
//  Created by 李翔 on 2017/5/2.
//  Copyright © 2017年 lx. All rights reserved.
//

#import "ViewController.h"
#import "UserCell.h"
#import "UserModel.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableDictionary *dataSourceLan;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.userTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.dataSourceLan = [NSMutableDictionary dictionary];
    self.dataSource = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)searchUser:(id)sender {
    
    if (self.searchText.text.length <= 0) {
        [MBProgressHUD showError:@"请输入用户名"];
        return;
    }
    
    [self.view endEditing:YES];
    [self.dataSourceLan removeAllObjects];
    [MBProgressHUD showMessage:@"Loading..." toView:self.view];
    [[NetAPIManager sharedManager] request_queryUserWithTarget:self userName:self.searchText.text andBlock:^(id responseData, NSError *error) {
        self.dataSource = [UserModel mj_objectArrayWithKeyValuesArray:responseData[@"items"]];
        if (self.dataSource.count > 0) {
            [self getUserRespos];
        }
    }];
}

-(void)getUserRespos{
    
    // 创建串行队列
    // 串行队列的特点：队列中的任务必须按顺序执行。
    __block NSInteger  flag = 0;
    dispatch_queue_t queue = dispatch_queue_create("repos", DISPATCH_QUEUE_SERIAL);
    
    for (UserModel *user in self.dataSource) {
        // 将任务添加到队列中
        dispatch_async(queue, ^{
            [[NetAPIManager sharedManager]  request_queryUserReposWithTarget:self userName:user.login andBlock:^(id responseData, NSError *error) {
                NSMutableArray *languageArr = [NSMutableArray array];
                NSArray *respArr = responseData;
                if (respArr.count > 0) {
                    for (NSDictionary *dic in responseData) {
                        if (![dic[@"language"] isEqual:[NSNull null]]) {
                            [languageArr addObject:dic[@"language"]];
                        }
                    }
                    NSString *login = [responseData firstObject][@"owner"][@"login"];
                    NSString *languageStr =  [self getLanguageMax:languageArr];
                    [self.dataSourceLan setValue:languageStr forKey:login];
                }
    
                NSLog(@"~~~~~%@",languageArr);
                flag ++;
                if (flag == self.dataSource.count) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.userTableView reloadData];
                }
            }];
        });
    }
}

-(NSString*)getLanguageMax:(NSMutableArray*)languageArr{
    
    //统计数组相同元素的个数
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSSet *set = [NSSet setWithArray:languageArr];
    for (NSString *setstring in set) {
        
        //需要去掉的元素数组
        NSMutableArray *filteredArray = [[NSMutableArray alloc]initWithObjects:setstring, nil];
        
        NSMutableArray *dataArray = languageArr;
        
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",filteredArray];
        //过滤数组
        NSArray * reslutFilteredArray = [dataArray filteredArrayUsingPredicate:filterPredicate];
        NSLog(@"Reslut Filtered Array = %@",reslutFilteredArray);
        int number = (int)(dataArray.count-reslutFilteredArray.count);
        NSLog(@"number :%d",number);
        [dic setObject:[NSNumber numberWithInteger:number] forKey:setstring];
    }
    NSLog(@"dic :%@",dic);
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *array = [[dic allValues] sortedArrayUsingComparator:cmptr];
    NSInteger max = [[array lastObject] integerValue];
    
    
    for (NSString *key in [dic allKeys]) {
        if ([dic[key] integerValue] == max) {
            return key;
        }
    }
    return @"暂无";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    if (cell == nil) {
        cell = [[UserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCell"];
    }
    
    UserModel *user = self.dataSource[indexPath.row];
    [cell setModel:user language:self.dataSourceLan[user.login]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
