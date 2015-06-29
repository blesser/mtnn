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

@end

@implementation MtnnGotStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 150, CGRectGetHeight(self.contentView.frame))];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.nameLabel];
        
        self.statusSwitch = [[UISwitch alloc] init];
        [self.statusSwitch addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = self.statusSwitch;
        
    }
    return self;
}

- (void)switched:(UISwitch *)statusSwitch
{
    if ([self.delegate respondsToSelector:@selector(swith:valueChanged:)]) {
        [self.delegate swith:self.statusSwitch valueChanged:statusSwitch.on];
    }
}

- (void)setStatusSwitchValue:(BOOL)swithValue name:(NSString *)name
{
    self.nameLabel.text = name;
    self.statusSwitch.on = swithValue;
}

@end
