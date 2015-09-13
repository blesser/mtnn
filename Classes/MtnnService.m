//
//  MtnnService.m
//  mtnn
//
//  Created by 延晋 张 on 15/9/13.
//
//

#import "MtnnService.h"

@implementation MtnnService

+ (NSDictionary *)scoreDictionaryWithTitle:(NSString *)title
{
    if ([title isEqualToString:@"头发"]) {
        return @{@"SS": @(1250),
                 @"S": @(1050),
                 @"A": @(825),
                 @"B": @(650),
                 @"C": @(550)};
    } else if ([title isEqualToString:@"连衣裙"]) {
        return @{@"SS": @(5100),
                 @"S": @(4000),
                 @"A": @(3400),
                 @"B": @(2750),
                 @"C": @(2200)};
    } else if ([title isEqualToString:@"外套"]) {
        return @{@"SS": @(505),
                 @"S": @(410),
                 @"A": @(330),
                 @"B": @(255),
                 @"C": @(200)};
    } else if ([title isEqualToString:@"上衣"] || [title isEqualToString:@"下装"]) {
        return @{@"SS": @(2725),
                 @"S": @(1950),
                 @"A": @(1600),
                 @"B": @(1325),
                 @"C": @(1000)};
    } else if ([title isEqualToString:@"袜子"]) {
        return @{@"SS": @(860),
                 @"S": @(610),
                 @"A": @(495),
                 @"B": @(420),
                 @"C": @(285)};
    } else if ([title isEqualToString:@"鞋"]) {
        return @{@"SS": @(1100),
                 @"S": @(860),
                 @"A": @(695),
                 @"B": @(555),
                 @"C": @(415)};
    } else if ([title isEqualToString:@"饰品"]) {
        return @{@"SS": @(485),
                 @"S": @(410),
                 @"A": @(330),
                 @"B": @(250),
                 @"C": @(200)};
    } else if ([title isEqualToString:@"妆容"]) {
        return @{@"SS": @(265),
                 @"S": @(190),
                 @"A": @(130),
                 @"B": @(120),
                 @"C": @(100)};
    }
    
    return @{};
}


@end
