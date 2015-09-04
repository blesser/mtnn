//
//  ViewController.m
//  mtnnxls
//
//  Created by alex on 6/14/15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "DataPickerView.h"
#import "DHxlsReader.h"

#import "MtnnDataManager.h"
#import "MtnnItem.h"
#import "MtnnFilterView.h"
#import "MtnnContentCell.h"
#import "MtnnDetailViewController.h"
#import "UIBarButtonItem+CustomButton.h"

extern int xls_debug;

@interface ViewController () <DataPickerDelegate, UITableViewDelegate, UITableViewDataSource, MtnnFilterViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MtnnFilterView *filterView;

@end

@implementation ViewController

#pragma mark - View lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"头发";
        
        _titleArray = [MtnnDataManager sharedManager].titleArray;
        self.title = [_titleArray firstObject];
        [MtnnDataManager sharedManager].title = self.title;
        [[MtnnDataManager sharedManager] reloadData];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0xf9 / 255.0f green:0xf8 / 255.0f blue:0xf0 / 255.0f alpha:1.0f];

    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)) {
        //头部，底部不拉伸
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
        
        //页面左上角的返回按钮，去掉文字，只保留返回箭头
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithButtonTitle:@"" target:self action:nil];
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithButtonTitle:@"位置" target:self action:@selector(itemButtonPressed:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithButtonTitle:@"套装" target:self action:@selector(coordinateButtonPressed:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //[self.view addSubview:self.filterView];
    [self.tableView setTableHeaderView:self.filterView];
    [self.view addSubview:self.tableView];
    
    self.filterView.maxSelectedCount = 5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (void)itemButtonPressed:(id)sender
{
    DataPickerView *periodView = [[DataPickerView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    periodView.dataList = self.titleArray;
    periodView.delegate = self;
    periodView.selectedIndex = [self.titleArray indexOfObject:self.title];
    [periodView showInView:self.navigationController.view title:nil tail:nil];
}

- (void)coordinateButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    NSArray *coordinateTitleArray = [[MtnnDataManager sharedManager].coordinatesDic allKeys];
    for (NSString *title in coordinateTitleArray) {
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet addButtonWithTitle:@"清空"];

    [actionSheet showInView:self.view.window];
//    [self.filterView clear];
//    [[MtnnDataManager sharedManager] reset];
//    [[MtnnDataManager sharedManager] reloadData];
//    [self.tableView reloadData];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    NSArray *coordinateArray = [MtnnDataManager sharedManager].coordinatesDic[title];
    if (coordinateArray) {
        NSArray *coordinateArrayWithValue = [MtnnItem valueDicArrayWithArray:coordinateArray];
        [[MtnnDataManager sharedManager].selectedStatus removeAllObjects];
        [[MtnnDataManager sharedManager].selectedStatus addObjectsFromArray:coordinateArrayWithValue];
        [self.filterView selectCoordinateData:coordinateArrayWithValue];
    } else {
        [self.filterView clear];
        [[MtnnDataManager sharedManager] reset];
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [[MtnnDataManager sharedManager] reloadData];
    [self.tableView reloadData];
}

#pragma mark - DataPickerDelegate

//单行picker
- (void)dpView:(DataPickerView *)dpView didSelectedWithData:(NSString *)chose
{
    self.title = chose;
    //[self.filterView clear];
    [MtnnDataManager sharedManager].title = self.title;
    [[MtnnDataManager sharedManager] reloadData];
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

- (void)dpView:(DataPickerView *)dpView didCancelViewWithData:(NSString *)chose
{
    
}

#pragma mark - MtnnFilterViewDelegate

- (void)filterView:(MtnnFilterView *)filterView didResultChanged:(NSArray *)filterResults
{
    [[MtnnDataManager sharedManager].selectedStatus removeAllObjects];
    [[MtnnDataManager sharedManager].selectedStatus addObjectsFromArray:filterResults];
    [[MtnnDataManager sharedManager] reloadData];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return;
    if (indexPath.row) {
        MtnnItem *item = [MtnnDataManager sharedManager].currentItemArray[indexPath.row-1];
        MtnnDetailViewController *detailVc = [[MtnnDetailViewController alloc] initWithItem:item pageTitle:self.title];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{

    return [[MtnnDataManager sharedManager].currentItemArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mtnnCell";
    MtnnContentCell *cell =  [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MtnnContentCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }

    if (indexPath.row == 0) {
        [cell setCellType:MtnnContentCellHeaderType];
    } else{
        [cell setCellType:MtnnContentCellNormalType];
        MtnnItem *item = [MtnnDataManager sharedManager].currentItemArray[indexPath.row-1];
        [cell setCellWithName:item.name currentValue:[item currentValueWithSelectStatus:[MtnnDataManager sharedManager].selectedStatus] allValue:[item allValueWithSelectStatus:[MtnnDataManager sharedManager].selectedStatus] got:item.got];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor colorWithRed:0xe3 / 255.0f green:0xe3 / 255.0f blue:0xe3 / 255.0f alpha:1.0f];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:0xf3 / 255.0f green:0xf3 / 255.0f blue:0xf3 / 255.0f alpha:1.0f];
    }
}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.filterView resignActiveTextField];
}

#pragma mark - setter & getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        //_tableView.bounces = NO;
        //_tableView.allowsSelection = NO;
    }
    
    return _tableView;
}

- (MtnnFilterView *)filterView
{
    if (!_filterView) {
        _filterView = [[MtnnFilterView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 155.0f) filterOptions:[MtnnDataManager sharedManager].constFlagArray];
        _filterView.delegate = self;
    }
    
    return _filterView;
}

@end
