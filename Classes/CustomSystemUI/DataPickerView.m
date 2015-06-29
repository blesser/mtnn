//
//  DataPickerView.m
//  Lottery
//
//  Created by wangbo on 10-10-26.
//  Copyright 2010 netease. All rights reserved.
//

#import "DataPickerView.h"
#import "UIBarButtonItem+CustomButton.h"

@interface DataPickerView () <UIGestureRecognizerDelegate>
{
    CGFloat _pickerY;
}
@end


@implementation DataPickerView

@synthesize dataList;
@synthesize selectedIndex;

- (void)dealloc
{
    picker.delegate = nil;
    picker.dataSource = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        selectedIndex = 0;
        [self addCancelTapGesture];
    }
    return self;
}

- (UIView *)createPickerViewWithTitle:(NSString *)title
{
    UIView *pickerAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 256)];

    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44.0f)];

    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithButtonTitle:@"取消"
                                                                        target:self action:@selector(cancelButtonPressed:)];
    UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithButtonTitle:@"确定"
                                                                    target:self action:@selector(okButtonPressed:)];

    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.leftBarButtonItem = cancelItem;

    navItem.rightBarButtonItem = okItem;

    [navBar setItems:[NSArray arrayWithObjects:navItem, nil]];

    if (title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 320 - 100, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        [navBar addSubview:titleLabel];
    }

    [pickerAreaView addSubview:navBar];

    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40.0f, 320, 216.0f)];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;

    picker.backgroundColor = [UIColor whiteColor];

    [pickerAreaView addSubview:picker];
    return pickerAreaView;
}

- (UIView *)createTitleView:(CGRect)frame title:(NSString *)title
{
    frame.origin.x = 0;
    frame.origin.y = 0;
    UIView *titleView = [[UIView alloc] initWithFrame:frame];
    UIView *backgrounView = [[UIView alloc] initWithFrame:frame];
    backgrounView.backgroundColor = [UIColor colorWithRed:31 / 255.0 green:31 / 255.0 blue:31 / 255.0f alpha:1];
    backgrounView.alpha = 0.5f;
    [titleView addSubview:backgrounView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 44, 320, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.text = title;
    [titleView addSubview:titleLabel];
    return titleView;
}

- (void)showInView:(UIView *)superView title:(NSString *)titleString tail:(UIView *)tailView
{
    UIView *pView = [self createPickerViewWithTitle:titleString];
    _pickerY = 0.0f;
    if (tailView == nil) {
        _pickerY = superView.frame.size.height - 256;
    } else {
        _pickerY = superView.frame.size.height - 256 - tailView.frame.size.height;
        CGRect frame = CGRectMake(0, superView.frame.size.height - tailView.frame.size.height, tailView.frame.size.width, tailView.frame.size.height);
        tailView.frame = frame;
        [self addSubview:tailView];
    }
    pView.frame = CGRectMake(0, _pickerY, 320, 256);
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.2f;
    [self addSubview:pView];

    [pView.layer addAnimation:animation forKey:@"myanimationkey"];


    [superView addSubview:self];
    [superView bringSubviewToFront:self];


    //[self.layer addAnimation:animation forKey:@"myanimationkey"];
    if (!self.multipleDataList || !_dataSource) {
        [picker selectRow:selectedIndex inComponent:0 animated:YES];
    }
}

- (void)cancelButtonPressed:(id)sender
{
    NSUInteger row = [picker selectedRowInComponent:0];
    if (self.multipleDataList && _dataSource) {
        NSMutableArray *array = [NSMutableArray array];
        NSInteger componentCount = self.multipleDataList.count;
        for (int i = 0; i < componentCount; i++) {
            row = [picker selectedRowInComponent:i];
            NSString *dataString = self.multipleDataList[i][row];
            [array addObject:dataString];
        }

        if (_delegate && [_delegate respondsToSelector:@selector(dpView:didCancelViewWithDataArray:)]) {
            [_delegate dpView:self didCancelViewWithDataArray:[array copy]];
        }
    }
    else {
        NSString *selectData = [dataList objectAtIndex:row];
        if ([self.delegate respondsToSelector:@selector(dpView:didCancelViewWithData:)]) {
            [self.delegate dpView:self didCancelViewWithData:selectData];
        }
    }

    [self removeFromSuperview];
}

- (void)okButtonPressed:(id)sender
{
    NSUInteger row = [picker selectedRowInComponent:0];
    if (self.multipleDataList && _dataSource) {
        NSMutableArray *array = [NSMutableArray array];
        NSInteger componentCount = self.multipleDataList.count;
        for (int i = 0; i < componentCount; i++) {
            row = [picker selectedRowInComponent:i];
            NSString *dataString = self.multipleDataList[i][row];
            [array addObject:dataString];
        }

        if (_delegate && [_delegate respondsToSelector:@selector(dpView:didSelectedWithDataArray:)]) {
            [_delegate dpView:self didSelectedWithDataArray:[array copy]];
        }
    }
    else {
        NSString *selectData = [dataList objectAtIndex:row];
        [self.delegate dpView:self didSelectedWithData:selectData];
    }
    [self removeFromSuperview];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        return [_dataSource numberOfComponentsInPickerView:self];
    }

    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_dataSource && [_dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        return [_dataSource pickerView:self numberOfRowsInComponent:component];
    }

    return [dataList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.multipleDataList && _dataSource) {
        return self.multipleDataList[component][row];
    }

    return [dataList objectAtIndex:row];
}


- (void)selectRowsForEveryComponent:(NSArray *)rowsArray
{
    if (self.multipleDataList && _dataSource) {
        NSUInteger count = rowsArray.count;
        for (int i = 0; i < count; i++) {
            [picker selectRow:[rowsArray[i] intValue] inComponent:i animated:NO];
        }
    }
}

#pragma mark - 取消手势

- (void)addCancelTapGesture
{
    SEL handle = @selector(handleTapGesture:);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:handle];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self];

    CGRect upperFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _pickerY);

    if (CGRectContainsPoint(upperFrame, point)) {
        [self cancelButtonPressed:nil];
    }
}

#pragma mark - GestureDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return !([touch.view isKindOfClass:[UIControl class]]);
}
@end
