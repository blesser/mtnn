//
//  MtnnPageSheetStore.m
//  mtnn
//
//  Created by 张 延晋 on 15/6/14.
//
//

#import "MtnnPageSheetStore.h"
#import "MtnnItem.h"
#import "MtnnDataManager.h"
#import "DHxlsReader.h"

static NSInteger firstItemRow = 2;

@interface MtnnPageSheetStore ()

@property (nonatomic, assign) NSUInteger pageSheetIndex;

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *itemNotGotArray;
@property (nonatomic, strong) NSMutableArray *itemGotArray;

@property (nonatomic, copy) NSString *title;

@end

@implementation MtnnPageSheetStore

- (instancetype)initWithReader:(DHxlsReader *)reader pageSheetIndex:(NSUInteger)sheetIndex keyArray:(NSArray *)keyArray
{
    if (self = [super init]) {
        self.title = [reader sheetNameAtIndex:sheetIndex];
        
        unsigned int rowCount = [reader numberOfRowsInSheet:sheetIndex];
        NSMutableArray *array = [NSMutableArray array];
        for (unsigned int i = firstItemRow; i<(rowCount-firstItemRow); i++) {
            MtnnItem *item = [[MtnnItem alloc] initWithReader:reader index:sheetIndex row:i+1 keyArray:keyArray];
            if (!item) {
                break;
            }

            [array addObject:item];
        }
        
        [self.itemArray addObjectsFromArray:array];
        
    }
    
    return self;
}

- (NSArray *)orderItemWithSelectedStatus:(NSArray *)selectedStatus
{
    NSMutableArray *itemGotArray = [NSMutableArray arrayWithArray:self.itemGotArray];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.itemNotGotArray];
    if (selectedStatus) {
        [itemGotArray sortUsingComparator:[self sortDescreaseBlockWithSelectStatus:selectedStatus]];
        [array sortUsingComparator:[self sortDescreaseBlockWithSelectStatus:selectedStatus]];
        
    }

    [itemGotArray addObjectsFromArray:array];
    return [NSArray arrayWithArray:itemGotArray];
}

- (void)changeItem:(NSString *)name gotStatus:(BOOL)gotStatus
{
    if (gotStatus) {
        NSArray *itemArray = [NSArray arrayWithArray:self.itemNotGotArray];
        for (MtnnItem *item in itemArray) {
            if ([item.name isEqualToString:name]) {
                [self.itemNotGotArray removeObject:item];
                [self.itemGotArray addObject:item];
                break;
            }
        }
    } else {
        NSArray *itemGotArray = [NSArray arrayWithArray:self.itemGotArray];
        for (MtnnItem *item in itemGotArray) {
            if ([item.name isEqualToString:name]) {
                [self.itemGotArray removeObject:item];
                [self.itemNotGotArray addObject:item];
                break;
            }
        }
    }
}

- (void)reloadWithGotDic:(NSDictionary *)itemGotDic
{
    for (MtnnItem *item in self.itemArray) {
        if (itemGotDic[item.name]) {
            item.got = [itemGotDic[item.name] boolValue];
        }
        
        if (item.got) {
            [self.itemGotArray addObject:item];
        } else {
            [self.itemNotGotArray addObject:item];
        }
    }
}

- (NSComparisonResult(^)(id obj1, id obj2))sortDescreaseBlockWithSelectStatus:(NSArray *)selectStatus
{
    return ^NSComparisonResult(id obj1, id obj2) {
        MtnnItem *item1 = (MtnnItem *) obj1;
        MtnnItem *item2 = (MtnnItem *) obj2;
        if ([item1 currentValueWithSelectStatus:selectStatus] > [item2 currentValueWithSelectStatus:selectStatus]) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    };
}

#pragma mark - setter & getter

- (NSMutableArray *)itemArray
{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    
    return _itemArray;
}

- (NSMutableArray *)itemGotArray
{
    if (!_itemGotArray) {
        _itemGotArray = [NSMutableArray array];
    }
    return _itemGotArray;
}

- (NSMutableArray *)itemNotGotArray
{
    if (!_itemNotGotArray) {
        _itemNotGotArray = [NSMutableArray array];
    }
    return _itemNotGotArray;
}

@end
