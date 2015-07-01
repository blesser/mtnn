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

static NSInteger const propertyIndex = 4;
static NSInteger const propertyCount = 10;

@interface MtnnItem ()

@property (nonatomic, strong) NSMutableDictionary *dataMap;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sign1;
@property (nonatomic, copy) NSString *sign2;
@property (nonatomic, copy) NSString *channel;

@end

@implementation MtnnItem

#pragma mark - life cycle
- (instancetype)initWithReader:(DHxlsReader *)reader index:(uint32_t)index row:(uint32_t)row keyArray:(NSArray *)keyArray
{
    if (self = [super init]) {
        DHcell *cell = [reader cellInWorkSheetIndex:index row:row col:1];
        self.name = cell.str;
        
        if ([self.name isEqual:[NSNull null]] || !self.name.length) {
            return nil;
        }
        
        for (unsigned int i= propertyIndex; i<(propertyCount + propertyIndex); i++) {
            DHcell *cell = [reader cellInWorkSheetIndex:index row:row col:i+1];
            if (i-propertyIndex >= keyArray.count) {
                break;
            }

            NSString *key = keyArray[i-propertyIndex];
            if (cell.val && ![cell.val isEqual:[NSNull null]]) {
                [self.dataMap setObject:cell.val forKey:key];
            } else{
                [self.dataMap setObject:@0 forKey:key];
            }
        }
        

        DHcell *signCell = [reader cellInWorkSheetIndex:index row:row col:(propertyIndex + propertyCount + 1)];
        if (signCell.str && signCell.str.length && ![signCell.str isEqual:[NSNull null]]) {
            _sign1 = signCell.str;
        }
        signCell = [reader cellInWorkSheetIndex:index row:row col:(propertyIndex + propertyCount + 2)];
        if (signCell.str && ![signCell.str isEqual:[NSNull null]]) {
            _sign2 = signCell.str;
        }
        
        DHcell *channelCell = [reader cellInWorkSheetIndex:index row:row col:(propertyIndex + propertyCount + 3)];
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
