//
//  UIBarButtonItem+CustomButton.m
//  Pods
//
//  Created by xuguoxing on 14-9-19.
//
//

#import "UIBarButtonItem+CustomButton.h"


#define IOS7_BARITEM_HIGHLIGHTCOLOR [UIColor colorWithRed:0.80 green:0.34 blue:0.40 alpha:1.0]

#define NavButtonFont  [UIFont systemFontOfSize:14]
//灰色 #b4b6b9
#define NavGrayTextColor [UIColor colorWithRed:0xb4 / 255.0f green:0xb6 / 255.0f blue:0xb9 / 255.0f alpha:1.0f]

@interface BarButton : UIButton

@end


@implementation BarButton

- (UIEdgeInsets)alignmentRectInsets
{
    if ([self isLeft]) {
        return UIEdgeInsetsMake(0, 9, 3, 0);
    } else {
        return UIEdgeInsetsMake(0, 0, 3, 9);
    }
}

- (BOOL)isLeft
{
    return self.frame.origin.x < (self.superview.frame.size.width / 2);
}

@end

@implementation UIBarButtonItem (CustomButton)



- (id)initWithButtonTitle:(NSString *)title target:(id)target action:(SEL)action
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [self initWithTitle:title style:UIBarButtonItemStyleBordered target:target action:action];
    }
    
    UIFont *font = NavButtonFont;
    CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = font;
    
    [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavButton"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavButtonPressed"] forState:UIControlStateHighlighted];
    CGFloat add = 15.0f + (4 - (NSInteger) [title length]) * 5;
    button.frame = CGRectMake(0, 0, titleSize.width + add, 29);
    self.customView = button;
    button.enabled = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return self;
}


- (id)initPlatWithButtonTitle:(NSString *)title target:(id)target action:(SEL)action
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [self initWithTitle:title style:UIBarButtonItemStyleBordered target:target action:action];
    }
    
    UIFont *font = NavButtonFont;
    CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/PlatNavButton"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/PlatNavButtonPressed"] forState:UIControlStateHighlighted];
    CGFloat add = 15.0f + (4 - (NSInteger) [title length]) * 5;
    button.frame = CGRectMake(0, 0, titleSize.width + add, 29);
    self.customView = button;
    button.enabled = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (id)initWithButtonImage:(UIImage *)image target:(id)target action:(SEL)action
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [self initWithImage:image style:UIBarButtonItemStyleBordered target:target action:action];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavButton"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavButtonPressed"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 32, 29);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateHighlighted];
    self.customView = button;
    button.enabled = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (id)initWithButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage title:(NSString *)title target:(id)target action:(SEL)action
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIFont *font = [UIFont systemFontOfSize:17];
        CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
        [button setImage:image forState:UIControlStateNormal];
        if (highlightImage) {
            [button setImage:highlightImage forState:UIControlStateHighlighted];
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.titleLabel.font = font;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:IOS7_BARITEM_HIGHLIGHTCOLOR forState:UIControlStateHighlighted];
        CGFloat add = image.size.width + 20;
        button.frame = CGRectMake(0, 0, titleSize.width + add, 29);
    } else {
        UIFont *font = NavButtonFont;
        CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:NavGrayTextColor forState:UIControlStateHighlighted];
        button.titleLabel.font = font;
        [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavButton"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavButtonPressed"] forState:UIControlStateHighlighted];
        CGFloat add = image.size.width + 5 + 15.0f + (4 - (NSInteger) [title length]) * 5;
        button.frame = CGRectMake(0, 0, titleSize.width + add, 29);
    }
    self.customView = button;
    button.enabled = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return self;
}

//投注页的参考按钮
- (id)initWithReferButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        button = [BarButton buttonWithType:UIButtonTypeCustom];
        UIFont *font = [UIFont systemFontOfSize:17];
        CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
        [button setImage:image forState:UIControlStateNormal];
        if (highlightImage) {
            [button setImage:highlightImage forState:UIControlStateHighlighted];
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        button.titleLabel.font = font;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:IOS7_BARITEM_HIGHLIGHTCOLOR forState:UIControlStateHighlighted];
        CGFloat add = image.size.width + 7;
        button.frame = CGRectMake(0, 0, titleSize.width + add, 32);
    } else {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIFont *font = NavButtonFont;
        CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:NavGrayTextColor forState:UIControlStateHighlighted];
        button.titleLabel.font = font;
        [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavButton"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavButtonPressed"] forState:UIControlStateHighlighted];
        CGFloat add = image.size.width + 5 + 15.0f + (4 - (NSInteger) [title length]) * 5;
        button.frame = CGRectMake(0, 0, titleSize.width + add, 29);
    }
    self.customView = button;
    button.enabled = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (BOOL)buttonEnable
{
    UIButton *button = (UIButton *) self.customView;
    return button.enabled;
}

- (void)setButtonEnable:(BOOL)value
{
    UIButton *button = (UIButton *) self.customView;
    button.enabled = value;
}

- (id)initWithViewController:(UIViewController *)controller
{
    NSArray *viewControllers = controller.navigationController.viewControllers;
    NSUInteger index = [viewControllers indexOfObject:controller];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    UIViewController *lastController = [viewControllers objectAtIndex:index - 1];
    NSString *title = lastController.title;
    if ((title == nil) || ([title length] == 0)) {
        title = @"返回";
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        title = @"";//ios7及以上不显示左侧返回按钮的文字
        UIFont *font = [UIFont systemFontOfSize:17];
        CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:IOS7_BARITEM_HIGHLIGHTCOLOR forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavChevron"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavChevronGray"] forState:UIControlStateHighlighted];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
        button.titleLabel.font = font;
        button.frame = CGRectMake(0, 0, titleSize.width + 25, 29);
    } else {
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 8, 0, 0);
        button.titleEdgeInsets = inset;
        button.titleLabel.font = font;
        button.titleLabel.textAlignment = NSTextAlignmentRight;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavBackButton"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavBackButtonPressed"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, titleSize.width + 20, 29);
    }
    self.customView = button;
    button.enabled = YES;
    self.target = controller;
    [button addTarget:self action:@selector(popController:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}


- (id)initPlatWithViewController:(UIViewController *)controller
{
    NSArray *viewControllers = controller.navigationController.viewControllers;
    NSUInteger index = [viewControllers indexOfObject:controller];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    UIViewController *lastController = [viewControllers objectAtIndex:index - 1];
    NSString *title = lastController.title;
    if ((title == nil) || ([title length] == 0)) {
        title = @"返回";
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        title = @"";//ios7及以上不显示左侧返回按钮的文字
        UIFont *font = [UIFont systemFontOfSize:17];
        CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:IOS7_BARITEM_HIGHLIGHTCOLOR forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavChevron"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"CustomSystemUI.bundle/NavChevronGray"] forState:UIControlStateHighlighted];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 13, 0, 0)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 11, 0, 0)];
        button.titleLabel.font = font;
        button.frame = CGRectMake(0, 0, titleSize.width + 25, 29);
    } else {
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 8, 0, 0);
        button.titleEdgeInsets = inset;
        button.titleLabel.font = font;
        button.titleLabel.textAlignment = NSTextAlignmentRight;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/PlatNavBackButton"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"CustomSystemUI.bundle/PlatNavBackButtonPressed"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, titleSize.width + 20, 29);
    }
    self.customView = button;
    button.enabled = YES;
    self.target = controller;
    [button addTarget:self action:@selector(popController:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)popController:(id)sender
{
    UIViewController *controller = (UIViewController *) self.target;
    if (!controller) {
        return;
    }
    UINavigationController *navController = (UINavigationController *) controller.navigationController;
    if (!navController) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self.target respondsToSelector:@selector(backButtonPressed:)]) {
        [self.target performSelector:@selector(backButtonPressed:) withObject:sender];
    }
#pragma clang diagnostic pop

    [navController popViewControllerAnimated:YES];
}


//世界杯导航按钮 特殊处理
- (id)initWithButtonImageForWorldCup:(UIImage *)image highlightImage:(UIImage *)highlightImage title:(NSString *)title target:(id)target action:(SEL)action
{
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIFont *font = [UIFont systemFontOfSize:17];
        CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
        [button setImage:image forState:UIControlStateNormal];
        if (highlightImage) {
            [button setImage:highlightImage forState:UIControlStateHighlighted];
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.titleLabel.font = font;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:NavGrayTextColor forState:UIControlStateHighlighted];
        CGFloat add = image.size.width + 20;
        button.frame = CGRectMake(0, 0, titleSize.width + add, 29);
    } else {
        UIFont *font = NavButtonFont;
        CGSize titleSize = [title sizeWithFont:font forWidth:200 lineBreakMode:NSLineBreakByCharWrapping];
        [button setImage:image forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:NavGrayTextColor forState:UIControlStateHighlighted];
        button.titleLabel.font = font;
        CGFloat add = image.size.width + 5 + 15.0f + (4 - (NSInteger) [title length]) * 5;
        button.frame = CGRectMake(0, 0, titleSize.width + add, 29);
    }
    self.customView = button;
    button.enabled = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return self;
}

@end
