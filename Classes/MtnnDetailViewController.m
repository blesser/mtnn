//
//  MtnnDetailViewController.m
//  mtnn
//
//  Created by 张 延晋 on 15/6/25.
//
//

#import "MtnnDetailViewController.h"
#import "MtnnGotStatusCell.h"
#import "MtnnItem.h"
#import "MtnnDataManager.h"

@interface MtnnDetailViewController () <UITableViewDelegate, UITableViewDataSource, MtnnGotStatusCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, strong) MtnnItem *item;

@end

@implementation MtnnDetailViewController

#pragma mark - life cycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return nil;
}

- (instancetype)initWithItem:(MtnnItem *)item pageTitle:(NSString *)pageTitle
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _pageTitle = pageTitle;
        _item = item;
        self.title = item.name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:0xf9 / 255.0f green:0xf8 / 255.0f blue:0xf0 / 255.0f alpha:1.0f];

    
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)) {
        //头部，底部不拉伸
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
        
        //页面左上角的返回按钮，去掉文字，只保留返回箭头
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithButtonTitle:@"" target:self action:nil];
    }
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mtnnCell";
    MtnnGotStatusCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MtnnGotStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    
    [cell setStatusSwitchValue:self.item.got name:self.item.name];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - MtnnGotStatusCellDelegate

- (void)swith:(UISwitch *)statusSwitch valueChanged:(BOOL)value
{
    self.item.got = value;
    
    [[MtnnDataManager sharedManager] setGotStatus:value key:self.item.name pageTitle:self.pageTitle];
    [[MtnnDataManager sharedManager] reloadData];
}

#pragma mark - setter & getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        //_tableView.bounces = NO;
        _tableView.allowsSelection = NO;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

@end
