//
//  MtnnGotStatusCell.h
//  mtnn
//
//  Created by 张 延晋 on 15/6/25.
//
//

#import <UIKit/UIKit.h>

@protocol MtnnGotStatusCellDelegate <NSObject>

- (void)swith:(UISwitch *)statusSwitch valueChanged:(BOOL)value;

@end
@interface MtnnGotStatusCell : UITableViewCell

@property (nonatomic, weak) id<MtnnGotStatusCellDelegate> delegate;

- (void)setStatusSwitchValue:(BOOL)swithValue name:(NSString *)name;

@end
