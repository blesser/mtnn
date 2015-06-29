//
//  MtnnContentCell.h
//  mtnn
//
//  Created by 张 延晋 on 15/6/22.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MtnnContentCellType)
{
    MtnnContentCellNoneType = -1,
    MtnnContentCellNormalType = 0,
    MtnnContentCellHeaderType,
    MtnnContentCellMaxType
};

@interface MtnnContentCell : UITableViewCell

- (void)setCellType:(MtnnContentCellType)cellType;

- (void)setCellWithName:(NSString *)name currentValue:(NSUInteger)currentValue allValue:(NSUInteger)allValue;

@end
