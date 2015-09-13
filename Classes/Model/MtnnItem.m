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
#import "MtnnDefines.h"
#import "MtnnService.h"

static NSInteger const propertyIndex = 5;
static NSInteger const propertyCount = 10;

@interface MtnnItem ()

@property (nonatomic, strong) NSMutableDictionary *dataMap;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subType;
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
        NSString *title = [reader sheetNameAtIndex:index];

        NSDictionary *valueDic = [MtnnService scoreDictionaryWithTitle:title];
        DHcell *cell = [reader cellInWorkSheetIndex:index row:row col:1];
        self.name = cell.str;
        
        if ([self.name isEqual:[NSNull null]] || !self.name.length) {
            return nil;
        }
        
        _subType = @"无";

        NSInteger beginIndex = propertyIndex;
        if ([title isEqualToString:@"袜子"] || [title isEqualToString:@"饰品"]) {
            DHcell *signCell = [reader cellInWorkSheetIndex:index row:row col:(propertyIndex-1)];
            if (signCell.str && signCell.str.length && ![signCell.str isEqual:[NSNull null]]) {
                _subType = signCell.str;
            }
        }
        
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

- (CGFloat)currentValueWithSelectStatus:(NSArray *)flagStatusDics
{
    __block CGFloat currentValue = 0.0f;
    __typeof(&*self) __weak weakSelf = self;

    [flagStatusDics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *flagDic = obj;
        NSString *flagStatus = flagDic[flagPropertyKey];
        CGFloat flagValue = [flagDic[flagValueKey] floatValue];
        if (weakSelf.dataMap[flagStatus]) {
            currentValue += ([weakSelf.dataMap[flagStatus] floatValue] * flagValue);
        }
    }];
    
    return currentValue;
}

- (CGFloat)allValueWithSelectStatus:(NSArray *)flagStatusDics
{
    __block CGFloat currentValue = 0.0f;
    __typeof(&*self) __weak weakSelf = self;
    
    [self.dataMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSNumber *number = obj;
        NSString *title = key;
        __block BOOL found  = NO;

        [flagStatusDics enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *flagDic = obj;
            NSString *flagTitle = flagDic[flagPropertyKey];
            if ([flagTitle isEqualToString:title]) {
                found = YES;
                CGFloat flagValue = [flagDic[flagValueKey] floatValue];
                currentValue += ([weakSelf.dataMap[flagTitle] floatValue] * flagValue);
            }
        }];
        
        if (!found) {
            currentValue += [weakSelf.dataMap[title] floatValue];
        }
        
    }];

    return currentValue;
}

#pragma mark - setter & getter

- (NSMutableDictionary *)dataMap{
    if (!_dataMap) {
        _dataMap = [NSMutableDictionary dictionary];
    }
    return _dataMap;
}

#pragma mark - Class Methods

+ (NSDictionary *)valueDicWithTitle:(NSString *)title value:(CGFloat)value
{
    return @{flagPropertyKey:title,
             flagValueKey:@(value)};
}

+ (NSArray *)valueDicArrayWithArray:(NSArray *)flagArray
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *title in flagArray) {
        [tempArray addObject:[[self class] valueDicWithTitle:title value:1.0f]];
    }
    return [NSArray arrayWithArray:tempArray];
}

+ (NSArray *)titleArrayWithValueDicArray:(NSArray *)valueDic
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in valueDic) {
        [tempArray addObject:dic[flagPropertyKey]];
    }
    return [NSArray arrayWithArray:tempArray];

}

@end
