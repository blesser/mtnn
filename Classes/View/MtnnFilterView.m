//
//  MtnnFilterView.m
//  mtnn
//
//  Created by 张 延晋 on 15/6/22.
//
//

#import "MtnnFilterView.h"
#import "MtnnItem.h"
#import "MtnnDefines.h"

@interface MtnnFilterView () <UITextFieldDelegate>

@property (nonatomic, strong) NSArray *filterOptions;
@property (nonatomic, strong) NSMutableArray *filterResults;

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *textFieldArray;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *activeField;
@property (nonatomic, strong) NSMutableDictionary *valueMap;

@end

@implementation MtnnFilterView

- (instancetype)initWithFrame:(CGRect)frame filterOptions:(NSArray *)options
{
    if (self = [super initWithFrame:frame]) {
        _filterOptions = [NSArray arrayWithArray:options];
        
        _valueMap = [@{} mutableCopy];

        [_filterOptions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_valueMap setObject:@"1.0f" forKey:obj];
        }];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
        
        //|10-80-20-40-10|
        CGFloat width = 80.0f;
        CGFloat changeButtonWitdh = 40.0f;

        CGFloat height = 20.0f;
        CGFloat xMargin = 10.0f;
        CGFloat xGap = 20.0f;
        CGFloat yMargin = 30.0f;
        CGFloat xOffset = xMargin;
        CGFloat yOffset = 10.0f;

        for (NSString *title in self.filterOptions) {
            UIButton *button = [self buttonWithFrame:CGRectMake(xOffset, yOffset, width, height) title:title];
            xOffset += (width + xGap);
            UITextField *textfield = [self textFieldWithFrame:CGRectMake(xOffset, yOffset, changeButtonWitdh, height) title:@"1.0"];
            [self.buttonArray addObject:button];
            [self.textFieldArray addObject:textfield];
            [self.scrollView addSubview:button];
            [self.scrollView addSubview:textfield];

            yOffset = (xOffset + changeButtonWitdh + 2 * xMargin) >= CGRectGetWidth(frame) ? (yOffset + yMargin): yOffset;
            xOffset = (xOffset + changeButtonWitdh + 2 * xMargin) >= CGRectGetWidth(frame) ? xMargin: (xOffset + changeButtonWitdh + xMargin);
        }
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(frame), CGRectGetWidth(frame), 0.5f)];
        bottomLine.backgroundColor = [UIColor blackColor];
        [self addSubview:bottomLine];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}


#pragma mark - Actions
- (void)buttonPressed:(UIButton *)button
{
    [self resignActiveTextField];
    
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

- (void)resignKeyBoard:(id)sender
{
    [self resignActiveTextField];
}

#pragma mark - Private Methods

- (void)addFilterResults:(NSString *)title
{
    if (![self.filterResults containsObject:title]) {
        [self.filterResults addObject:[MtnnItem valueDicWithTitle:title value:[self.valueMap[title] floatValue]]];
    }
}

- (BOOL)removeFilterResults:(NSString *)title
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.filterResults];
    for (NSDictionary *dic in array) {
        if ([title isEqualToString:dic[flagPropertyKey]]) {
            [self.filterResults removeObject:dic];
            return YES;
        }
    }
    
    return NO;
}

- (void)refreshFilterTitle:(NSString *)title
{
    if ([self removeFilterResults:title]) {
        [self addFilterResults:title];
    }
}

#pragma mark - Public Methods

- (void)selectCoordinateData:(NSArray *)coordinateData
{
    [self resignActiveTextField];
    
    [self.filterResults removeAllObjects];
    [self.filterResults addObjectsFromArray:coordinateData];
    
    NSArray *titleArray = [MtnnItem titleArrayWithValueDicArray:coordinateData];
    [self.buttonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        if ([titleArray containsObject:[button titleForState:UIControlStateNormal]]) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
    }];
    
    [self.textFieldArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UITextField *textField = obj;
        textField.text = @"1.0";
    }];
    
    [self.valueMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        obj = @"1.0";
    }];
}

- (void)clear{
    [self.filterResults removeAllObjects];
    [self.buttonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = obj;
        button.selected = NO;
    }];
    
    [self.textFieldArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UITextField *textField = obj;
        textField.text = @"1.0";
    }];
    
    [self.valueMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        obj = @"1.0";
    }];
}

- (void)resignActiveTextField
{
    [self.activeField resignFirstResponder];
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

- (UITextField *)textFieldWithFrame:(CGRect)frame title:(NSString *)value
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.text = value;
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:12.0f];
    return textField;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField       // return NO to disallow editing.
{
    self.activeField = textField;
        
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    [textField selectAll:nil];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *tryString = [NSMutableString stringWithString:textField.text];
    [tryString replaceCharactersInRange:range withString:string];

    if (tryString.length == 0) {
        return YES;
    }
    
    if (tryString.length > 3) {
        return NO;
    }
    
    if (tryString.floatValue > 5.0f) {
        return NO;
    }
    
    if (tryString.length >= 3  && tryString.floatValue < 0.1f) {
        return NO;
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        textField.text = @"1.0";
    }
    
    NSString *title = self.filterOptions[[self.textFieldArray indexOfObject:textField]];
    [self.valueMap setObject:textField.text forKey:title];
    
    [self refreshFilterTitle:title];
    
    [self.delegate filterView:self didResultChanged:self.filterResults];
}

#pragma mark - setter & getter

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:self.filterOptions.count];
    }
    return _buttonArray;
}

- (NSMutableArray *)textFieldArray
{
    if (!_textFieldArray) {
        _textFieldArray = [NSMutableArray arrayWithCapacity:self.buttonArray.count];
    }
    
    return _textFieldArray;
}

- (NSMutableArray *)filterResults
{
    if (!_filterResults) {
        _filterResults = [NSMutableArray array];
    }
    
    return _filterResults;
}

@end
