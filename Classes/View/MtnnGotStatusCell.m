//
//  MtnnGotStatusCell.m
//  mtnn
//
//  Created by 张 延晋 on 15/6/25.
//
//

#import "MtnnGotStatusCell.h"

@interface MtnnGotStatusCell ()

@property (nonatomic, strong) UISwitch *statusSwitch;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation MtnnGotStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 150, CGRectGetHeight(self.contentView.frame))];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.nameLabel];
        
        self.statusSwitch = [[UISwitch alloc] init];
        [self.statusSwitch addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = self.statusSwitch;
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame) - 50.0f, 0.0f, 50.0f, CGRectGetHeight(self.contentView.frame))];
        descLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        descLabel.backgroundColor = [UIColor clearColor];
        descLabel.textColor = [UIColor grayColor];
        descLabel.text = @"未获得";
        descLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:descLabel];
        self.descLabel = descLabel;
    }
    return self;
}

- (void)switched:(UISwitch *)statusSwitch
{
    [self reloadStatus];
    
    if ([self.delegate respondsToSelector:@selector(swith:valueChanged:)]) {
        [self.delegate swith:self.statusSwitch valueChanged:statusSwitch.on];
    }
}

- (void)setStatusSwitchValue:(BOOL)swithValue name:(NSString *)name
{
    self.nameLabel.text = name;
    self.statusSwitch.on = swithValue;
    
    [self reloadStatus];
}

- (void)reloadStatus
{
    if (self.statusSwitch.on) {
        self.descLabel.text = @"已获得";
        self.descLabel.textColor = [UIColor redColor];
    } else {
        self.descLabel.text = @"未获得";
        self.descLabel.textColor = [UIColor grayColor];
    }
}

@end
