//
//  MtnnDataManager.h
//  mtnn
//
//  Created by 张 延晋 on 15/6/14.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MtnnItem;
@interface MtnnDataManager : NSObject

@property (nonatomic, readonly) NSMutableArray *titleArray;
@property (nonatomic, readonly) NSArray *constFlagArray;
@property (nonatomic, readonly) NSArray *currentItemArray;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *selectedStatus;
@property (nonatomic, readonly) NSDictionary *coordinatesDic;

+ (instancetype)sharedManager;

- (void)reset;

- (void)reloadData;

- (void)setGotStatus:(BOOL)status key:(NSString *)name pageTitle:(NSString *)pageTitle;

- (void)saveGotList;

@end
