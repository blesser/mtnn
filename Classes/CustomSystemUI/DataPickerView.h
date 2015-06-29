//
//  DataPickerView.h
//  Lottery
//
//  Created by wangbo on 10-10-26.
//  Copyright 2010 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPickerDelegate.h"
#import "DataPickerDataSource.h"
#import "DataPickerView.h"

@interface DataPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *picker;

    NSArray *dataList;

    NSUInteger selectedIndex;
}

@property (nonatomic) NSArray *dataList;
@property (nonatomic, strong) NSArray *multipleDataList;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) id <DataPickerDelegate> delegate;
@property (nonatomic, weak) id <DataPickerDataSource> dataSource;

- (UIView *)createTitleView:(CGRect)frame title:(NSString *)title;

- (void)showInView:(UIView *)superView title:(NSString *)titleString tail:(UIView *)tailView;

- (void)cancelButtonPressed:(id)sender;

- (void)okButtonPressed:(id)sender;


- (void)selectRowsForEveryComponent:(NSArray *)rowsArray;

@end



