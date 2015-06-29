//
//  MtnnFilterView.m
//  mtnn
//
//  Created by 张 延晋 on 15/6/22.
//
//

#import "MtnnFilterView.h"

@interface MtnnFilterView ()

@property (nonatomic, strong) NSArray *filterOptions;
@property (nonatomic, strong) NSMutableArray *filterResults;

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MtnnFilterView

- (instancetype)initWithFrame:(CGRect)frame filterOptions:(NSArray *)options
{
    if (self = [super initWithFrame:frame]) {
        _filterOptions = [NSArray arrayWithArray:options];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
        
        CGFloat width = (CGRectGetWidth(frame) - 80) / 3;
        CGFloat height = 20.0f;
        CGFloat xMargin = 20.0f;
        CGFloat yMargin = 30.0f;
        CGFloat xOffset = xMargin;
        CGFloat yOffset = 10.0f;

        for (NSString *title in self.filterOptions) {
            UIButton *button = [self buttonWithFrame:CGRectMake(xOffset, yOffset, width, height) title:title];
            [self.buttonArray addObject:button];
            [self.scrollView addSubview:button];

            yOffset = (xOffset + width + xMargin) >= CGRectGetWidth(frame) ? (yOffset + yMargin): yOffset;
            xOffset = (xOffset + width + xMargin) >= CGRectGetWidth(frame) ? xMargin: (xOffset + width + xMargin);
        }
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(frame), CGRectGetWidth(frame), 0.5f)];
        bottomLine.backgroundColor = [UIColor blackColor];
        [self addSubview:bottomLine];
        
    }
    return self;
}


#pragma mark - Actions
- (void)buttonPressed:(UIButton *)button
{
    if (self.maxSelectedCount && self.filterResults.count >= self.maxSelectedCount && !button.selected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hi" message:[NSString stringWithFormat:@"最多选择%d个选项",self.maxSelectedCount] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    button.selected = !button.selected;
    if (button.selected) {
        [self addFilterResults:[button titleForState:UIControlStateNormal]];
    } else {
        [self removeFilterResults:[button titleForState:UIControlStateNormal]];
    }
    
    [self.delegate filterView:self didResultChanged:self.filterResults];
}

#pragma mark - Private Methods

- (void)addFilterResults:(NSString *)title{
    if (![self.filterResults containsObject:title]) {
        [self.filterResults addObject:title];
    }
}

- (void)removeFilterResults:(NSString *)title{
    [self.filterResults removeObject:title];
}

#pragma mark - Public Methods

- (void)selectCoordinateData:(NSArray *)coordinateData
{
    [self.filterResults removeAllObjects];
    [self.filterResults addObjectsFromArray:coordinateData];
    [self.buttonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        if ([coordinateData containsObject:[button titleForState:UIControlStateNormal]]) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }];
}

- (void)clear{
    [self.filterResults removeAllObjects];
    [self.buttonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        button.selected = NO;
    }];
}

- (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateHighlighted|UIControlStateSelected];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted|UIControlStateSelected];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5.0f;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 0.5f;
    button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    return button;
}

#pragma mark - setter & getter

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:self.filterOptions.count];
    }
    return _buttonArray;
}

- (NSMutableArray *)filterResults
{
    if (!_filterResults) {
        _filterResults = [NSMutableArray array];
    }
    
    return _filterResults;
}

@end
