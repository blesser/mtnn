//
//  UIBarButtonItem+CustomButton.h
//  Pods
//
//  Created by xuguoxing on 14-9-19.
//
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomButton)

- (id)initWithButtonTitle:(NSString *)title target:(id)target action:(SEL)action;

- (id)initPlatWithButtonTitle:(NSString *)title target:(id)target action:(SEL)action;

- (id)initWithButtonImage:(UIImage *)image target:(id)target action:(SEL)action;

- (id)initWithButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage title:(NSString *)title target:(id)target action:(SEL)action;

- (id)initWithReferButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage title:(NSString *)title target:(id)target action:(SEL)action;

- (id)initWithViewController:(UIViewController *)controller;

- (id)initPlatWithViewController:(UIViewController *)controller;

- (void)popController:(id)sender;

- (BOOL)buttonEnable;

- (void)setButtonEnable:(BOOL)value;

//世界杯导航按钮 特殊处理
- (id)initWithButtonImageForWorldCup:(UIImage *)image highlightImage:(UIImage *)highlightImage title:(NSString *)title target:(id)target action:(SEL)action;
@end
