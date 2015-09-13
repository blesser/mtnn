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
@property (nonatomic, strong) UILabel *subTypeLabel;

@end
@implementation MtnnContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 130, CGRectGetHeight(self.contentView.frame))];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:self.nameLabel];
        
        self.currentValue =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), 0.0f, 60.0f, CGRectGetHeight(self.contentView.frame))];
        self.currentValue.backgroundColor = [UIColor clearColor];
        self.currentValue.textColor = [UIColor redColor];
        self.currentValue.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:self.currentValue];
        
        self.allValue =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.currentValue.frame), 0.0f, 60.0f, CGRectGetHeight(self.contentView.frame))];
        self.allValue.backgroundColor = [UIColor clearColor];
        self.allValue.textColor = [UIColor blueColor];
        self.allValue.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:self.allValue];
        
        self.subTypeLabel =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.allValue.frame), 0.0f, 60.0f, CGRectGetHeight(self.contentView.frame))];
        self.subTypeLabel.backgroundColor = [UIColor clearColor];
        self.subTypeLabel.textColor = [UIColor blackColor];
        self.subTypeLabel.font = [UIFont systemFontOfSize:13.0f];
        self.subTypeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.subTypeLabel];

    }
    return self;
}

- (void)setCellType:(MtnnContentCellType)cellType
{
    if (cellType == MtnnContentCellHeaderType) {
        self.nameLabel.text = @"名称";
        self.currentValue.text = @"当前值";
        self.currentValue.textColor = [UIColor blackColor];
        self.allValue.text = @"所有值";
        self.subTypeLabel.text = @"子类";
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

- (void)setCellWithName:(NSString *)name currentValue:(CGFloat)currentValue allValue:(CGFloat)allValue got:(BOOL)got subType:(NSString *)subType
{
    self.nameLabel.text = name;
    self.currentValue.text = [NSString stringWithFormat:@"%.0f",currentValue];
    self.allValue.text = [NSString stringWithFormat:@"%.0f",allValue];
    self.subTypeLabel.text = subType;
    if (got) {
        self.currentValue.textColor = [UIColor colorWithRed:0x47 / 255.0f green:0x9e / 255.0f blue:0x12 / 255.0f alpha:1.00f];
    } else {
        self.currentValue.textColor = [UIColor redColor];
    }
}

@end
