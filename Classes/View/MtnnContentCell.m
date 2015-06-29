//
//  MtnnContentCell.m
//  mtnn
//
//  Created by 张 延晋 on 15/6/22.
//
//

#import "MtnnContentCell.h"

@interface MtnnContentCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *currentValue;
@property (nonatomic, strong) UILabel *allValue;
@end
@implementation MtnnContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 150, CGRectGetHeight(self.contentView.frame))];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.nameLabel];
        
        self.currentValue =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), 0.0f, 100.0f, CGRectGetHeight(self.contentView.frame))];
        self.currentValue.backgroundColor = [UIColor clearColor];
        self.currentValue.textColor = [UIColor redColor];
        self.currentValue.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.currentValue];
        
        self.allValue =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.currentValue.frame), 0.0f, 100.0f, CGRectGetHeight(self.contentView.frame))];
        self.allValue.backgroundColor = [UIColor clearColor];
        self.allValue.textColor = [UIColor blueColor];
        self.allValue.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.allValue];

    }
    return self;
}

- (void)setCellType:(MtnnContentCellType)cellType
{
    if (cellType == MtnnContentCellHeaderType) {
        self.nameLabel.text = @"名称";
        self.currentValue.text = @"当前值";
        self.allValue.text = @"所有值";
    }
}

- (void)setCellWithName:(NSString *)name currentValue:(NSUInteger)currentValue allValue:(NSUInteger)allValue
{
    self.nameLabel.text = name;
    self.currentValue.text = [NSString stringWithFormat:@"%d",currentValue];
    self.allValue.text = [NSString stringWithFormat:@"%d",allValue];
}

@end
