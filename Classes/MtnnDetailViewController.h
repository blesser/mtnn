//
//  MtnnDetailViewController.h
//  mtnn
//
//  Created by 张 延晋 on 15/6/25.
//
//

#import <UIKit/UIKit.h>

@class MtnnItem;
@interface MtnnDetailViewController : UIViewController

- (instancetype)initWithItem:(MtnnItem *)item pageTitle:(NSString *)pageTitle;

@end
