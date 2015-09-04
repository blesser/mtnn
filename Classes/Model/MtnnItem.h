//
//  MtnnItem.h
//  mtnn
//
//  Created by 张 延晋 on 15/6/14.
//
//

#import <Foundation/Foundation.h>

@class DHxlsReader;

@interface MtnnItem : NSObject

@property (nonatomic, readonly ,copy) NSString *name;
@property (nonatomic ,assign) BOOL got;
@property (nonatomic, readonly, copy) NSString *sign1;
@property (nonatomic, readonly, copy) NSString *sign2;
@property (nonatomic, readonly, copy) NSString *channel;

- (instancetype)initWithReader:(DHxlsReader *)reader index:(uint32_t)index row:(uint32_t)row keyArray:(NSArray *)keyArray;

- (CGFloat)currentValueWithSelectStatus:(NSArray *)flagStatus;
- (CGFloat)allValueWithSelectStatus:(NSArray *)flagStatusDics;

+ (NSDictionary *)valueDicWithTitle:(NSString *)title value:(CGFloat)value;
+ (NSArray *)valueDicArrayWithArray:(NSArray *)flagArray;
+ (NSArray *)titleArrayWithValueDicArray:(NSArray *)valueDic;

@end
