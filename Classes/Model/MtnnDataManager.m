//
//  MtnnDataManager.m
//  mtnn
//
//  Created by 张 延晋 on 15/6/14.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "MtnnDataManager.h"
#import "MtnnPageSheetStore.h"
#import "MtnnItem.h"
#import "DHxlsReader.h"

static NSInteger firstPageIndex = 1;

static NSInteger maxPageCount = 9;

@interface MtnnDataManager ()

@property (nonatomic, strong) NSMutableArray *pageSheetArray;

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSArray *constFlagArray;

@property (nonatomic, strong) NSArray *currentItemArray;

@property (nonatomic, strong) NSDictionary *coordinatesDic;

@property (nonatomic, strong) NSMutableDictionary *itemGotListDic;

@end

@implementation MtnnDataManager

+ (instancetype)sharedManager
{
    static MtnnDataManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - init & dealloc
- (instancetype)init
{
    if (self = [super init]) {
        
        _constFlagArray = @[@"华丽", @"简约", @"优雅", @"活泼",  @"成熟",  @"可爱",  @"性感",  @"清纯",  @"清凉", @"保暖"];
        
        _selectedStatus = [NSMutableArray arrayWithArray:self.constFlagArray];
        
        NSDictionary *itemGotDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"ItemGotList"];
        if (itemGotDic && itemGotDic.count) {
            [self.itemGotListDic setValuesForKeysWithDictionary:itemGotDic];
        }
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MtnnCoordinates" ofType:@"plist"];
        _coordinatesDic = [NSDictionary dictionaryWithContentsOfFile:filePath];

        [self readFile];
        
        _title = [self.titleArray firstObject];

        [self reloadData];
        
        [self lodeGotListWith:[NSDictionary dictionaryWithDictionary:self.itemGotListDic]];
    }
    return self;
}

- (void)dealloc
{
}

- (void)readFile
{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Document.xls"];
    
    DHxlsReader *reader = [DHxlsReader xlsReaderWithPath:path];
    
    [self createDataWithReader:reader];
    
}

- (void)createDataWithReader:(DHxlsReader *)reader
{
    for (unsigned int i = firstPageIndex; i<firstPageIndex+maxPageCount; i++) {
        MtnnPageSheetStore *dataStore = [[MtnnPageSheetStore alloc] initWithReader:reader pageSheetIndex:i keyArray:self.constFlagArray];
        [self.pageSheetArray addObject:dataStore];
        
        [self.titleArray addObject:dataStore.title];
    }
}

- (void)lodeGotListWith:(NSDictionary *)itemGotList
{
    for (MtnnPageSheetStore *pageStore in self.pageSheetArray) {
        [pageStore reloadWithGotDic:itemGotList];
    }
}

#pragma mark - Public Methods

- (NSUInteger)itemCountForTitle:(NSString *)title
{
    NSUInteger index = [self.titleArray indexOfObject:title];
    if (index == NSNotFound) {
        return 0;
    } else{
        MtnnPageSheetStore *dataStore = self.pageSheetArray[index];
        return dataStore.itemArray.count;
    }
}

- (MtnnItem *)itemForTitle:(NSString *)title row:(NSUInteger)row
{
    NSUInteger index = [self.titleArray indexOfObject:title];
    if (index == NSNotFound) {
        return 0;
    } else{
        MtnnPageSheetStore *dataStore = self.pageSheetArray[index];
        return dataStore.itemArray[row];
    }
}

- (void)reset
{
    _selectedStatus = [NSMutableArray arrayWithArray:self.constFlagArray];
}

- (void)reloadData
{
    NSUInteger index = [self.titleArray indexOfObject:self.title];
//    NSLog(@"________________________");
//
//    for (NSString *str in self.selectedStatus) {
//        NSLog(@"reloadData str is %@",str);
//    }
    if (index != NSNotFound) {
        MtnnPageSheetStore *dataStore = self.pageSheetArray[index];
        self.currentItemArray = [dataStore orderItemWithSelectedStatus:self.selectedStatus];
    }
}

- (void)setGotStatus:(BOOL)status key:(NSString *)name pageTitle:(NSString *)pageTitle
{
    if (name) {
        [_itemGotListDic setObject:@(status) forKey:name];
        NSUInteger index = [self.titleArray indexOfObject:pageTitle];
        if (index != NSNotFound) {
            MtnnPageSheetStore *dataStore = self.pageSheetArray[index];
            [dataStore changeItem:name gotStatus:status];
        }
    }
}

- (void)saveGotList
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:self.itemGotListDic] forKey:@"ItemGotList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - setter & getter

- (NSMutableArray *)pageSheetArray
{
    if (!_pageSheetArray) {
        _pageSheetArray = [NSMutableArray array];
    }
    
    return _pageSheetArray;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    
    return _titleArray;
}

- (NSMutableDictionary *)itemGotListDic
{
    if (!_itemGotListDic) {
        _itemGotListDic = [NSMutableDictionary dictionary];
    }
    return _itemGotListDic;
}

@end
