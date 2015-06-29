//
//  DataPickerDelegate.h
//  Lottery
//
//  Created by wangbo on 10-10-26.
//  Copyright 2010 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataPickerView;

@protocol DataPickerDelegate <NSObject>

@optional
//单行picker
- (void)dpView:(DataPickerView *)dpView didSelectedWithData:(NSString *)chose;

- (void)dpView:(DataPickerView *)dpView didCancelViewWithData:(NSString *)chose;

//多行picker
- (void)dpView:(DataPickerView *)dpView didSelectedWithDataArray:(NSArray *)chose;

- (void)dpView:(DataPickerView *)dpView didCancelViewWithDataArray:(NSArray *)chose;

@end


