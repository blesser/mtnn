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

- (instancetype)initWithReader:(DHxlsReader *)reader index:(uint32_t)index row:(uint32_t)row keyArray:(NSArray *)keyArray;

- (NSUInteger)currentValueWithSelectStatus:(NSArray *)flagStatus;
- (NSUInteger)allValue;

@end
