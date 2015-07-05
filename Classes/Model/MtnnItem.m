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

static NSInteger const propertyIndex = 5;
static NSInteger const propertyCount = 10;

@interface MtnnItem ()

@property (nonatomic, strong) NSMutableDictionary *dataMap;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sign1;
@property (nonatomic, copy) NSString *sign2;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *type;

@end

@implementation MtnnItem

#pragma mark - life cycle
- (instancetype)initWithReader:(DHxlsReader *)reader index:(uint32_t)index row:(uint32_t)row keyArray:(NSArray *)keyArray
{
    if (self = [super init]) {
        
        NSDictionary *valueDic = @{@"SS": @(6),
                                   @"S": @(5),
                                   @"A": @(4),
                                   @"B": @(3),
                                   @"C": @(2)};
        
        DHcell *cell = [reader cellInWorkSheetIndex:index row:row col:1];
        self.name = cell.str;
        
        if ([self.name isEqual:[NSNull null]] || !self.name.length) {
            return nil;
        }
        
        NSInteger beginIndex = ([self.name isEqualToString:@"袜子"] || [self.name isEqualToString:@"饰品"]) ? propertyIndex + 1: propertyIndex;
        
        for (unsigned int i= beginIndex; i<(propertyCount + beginIndex); i++) {
            DHcell *cell = [reader cellInWorkSheetIndex:index row:row col:i];
            if (i - beginIndex >= keyArray.count) {
                break;
            }

            NSString *key = keyArray[i-beginIndex];
            if (cell.str && ![cell.val isEqual:[NSNull null]] && cell.str.length) {
                [self.dataMap setObject:valueDic[cell.str] forKey:key];
            } else{
                [self.dataMap setObject:@0 forKey:key];
            }
        }
        

        DHcell *signCell = [reader cellInWorkSheetIndex:index row:row col:(beginIndex + propertyCount)];
        if (signCell.str && signCell.str.length && ![signCell.str isEqual:[NSNull null]]) {
            _sign1 = signCell.str;
        }
        signCell = [reader cellInWorkSheetIndex:index row:row col:(beginIndex + propertyCount + 1)];
        if (signCell.str && ![signCell.str isEqual:[NSNull null]]) {
            _sign2 = signCell.str;
        }
        
        DHcell *channelCell = [reader cellInWorkSheetIndex:index row:row col:(beginIndex + propertyCount + 2)];
        if (channelCell.str && ![channelCell.str isEqual:[NSNull null]]) {
            _channel = channelCell.str;
        }
        //NSLog(@"name is %@,sign1 %@,sign 2 %@,channel %@",self.name,self.sign1, self.sign2, self.channel);

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
