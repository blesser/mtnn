//
//  MtnnItem.m
//  mtnn
//
//  Created by 张 延晋 on 15/6/14.
//
//

#import "MtnnItem.h"
#import "DHxlsReader.h"
#import "MtnnDataManager.h"

@interface MtnnItem ()

@property (nonatomic, strong) NSMutableDictionary *dataMap;

@property (nonatomic, copy) NSString *name;

@end

@implementation MtnnItem

#pragma mark - life cycle
- (instancetype)initWithReader:(DHxlsReader *)reader index:(uint32_t)index row:(uint32_t)row keyArray:(NSArray *)keyArray
{
    if (self = [super init]) {
        uint32_t colCount = [reader numberOfColsInSheet:index];

        DHcell *cell = [reader cellInWorkSheetIndex:index row:row col:1];
        self.name = cell.str;
        
        if ([self.name isEqual:[NSNull null]] || !self.name.length) {
            return nil;
        }
        
        for (unsigned int i= 1; i<(colCount-1); i++) {
            DHcell *cell = [reader cellInWorkSheetIndex:index row:row col:i+1];
            if (i-1 >= keyArray.count) {
                break;
            }
            
            NSString *key = keyArray[i-1];
            if (cell.val && ![cell.val isEqual:[NSNull null]]) {
                [self.dataMap setObject:cell.val forKey:key];
            } else{
                [self.dataMap setObject:@0 forKey:key];
            }
        }
    }
    return self;
}

- (void)dealloc
{
}

#pragma mark - Public Methods

- (NSUInteger)currentValueWithSelectStatus:(NSArray *)flagStatus{
    __block NSUInteger currentValue = 0;
    __typeof(&*self) __weak weakSelf = self;

    [flagStatus enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (weakSelf.dataMap[obj]) {
            currentValue += [weakSelf.dataMap[obj] unsignedIntegerValue];
        }
    }];
    
    return currentValue;
}

- (NSUInteger)allValue
{
    NSArray *allValues = [self.dataMap allValues];
    NSUInteger value = 0;
    for (NSNumber *obj in allValues) {
        value += [obj unsignedIntegerValue];
    }
    
    return value;
}

#pragma mark - setter & getter

- (NSMutableDictionary *)dataMap{
    if (!_dataMap) {
        _dataMap = [NSMutableDictionary dictionary];
    }
    return _dataMap;
}

@end
