//
//  DataPickerDataSource.h
//  NeteaseLottery
//
//  Created by Zhao Maojia on 5/23/14.
//  Copyright (c) 2014 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataPickerView;

@protocol DataPickerDataSource <NSObject>

@optional
- (NSInteger)numberOfComponentsInPickerView:(DataPickerView *)pickerView;

- (NSInteger)pickerView:(DataPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end
