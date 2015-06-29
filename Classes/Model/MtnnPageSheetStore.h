//
//  MtnnPageSheetStore.h
//  mtnn
//
//  Created by 张 延晋 on 15/6/14.
//
//

#import <Foundation/Foundation.h>

@class DHxlsReader;
@interface MtnnPageSheetStore : NSObject

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly) NSMutableArray *itemArray;

- (instancetype)initWithReader:(DHxlsReader *)reader pageSheetIndex:(NSUInteger)sheetIndex keyArray:(NSArray *)keyArray;

- (NSArray *)orderItemWithSelectedStatus:(NSArray *)selectedStatus;

- (void)changeItem:(NSString *)name gotStatus:(BOOL)gotStatus;

@end
