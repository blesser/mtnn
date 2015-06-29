//
//  MtnnFilterView.h
//  mtnn
//
//  Created by 张 延晋 on 15/6/22.
//
//

#import <UIKit/UIKit.h>

@class MtnnFilterView;

@protocol MtnnFilterViewDelegate <NSObject>

- (void)filterView:(MtnnFilterView *)filterView didResultChanged:(NSArray *)filterResults;

@end

@interface MtnnFilterView : UIView

@property (nonatomic, weak) id<MtnnFilterViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger maxSelectedCount;

- (instancetype)initWithFrame:(CGRect)frame filterOptions:(NSArray *)options;

- (void)selectCoordinateData:(NSArray *)coordinateData;

- (void)clear;

@end
