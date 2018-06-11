//
//  LCYScorllPictureView.h
//  ScorllPictureDmo
//
//  Created by 刘晨阳 on 2018/5/23.
//  Copyright © 2018年 changba-mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ScrollPictureDirection) {
    ScrollPictureDirectionLeft = 1,
    ScrollPictureDirectionRight,
    ScrollPictureDirectionTop,
    ScrollPictureDirectionBottom,
};

@protocol LCYScrollPictureDelegate <NSObject>

@required
- (NSInteger)numberOfTotalScrollCount;
- (UIImage *)imageForScrollInIndex:(NSInteger)index;

@optional
- (void)scrollAtTheIndex:(NSInteger)index;

@end

@interface LCYScorllPictureView : UIView
@property (nonatomic, weak) id<LCYScrollPictureDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame duration:(NSTimeInterval)interval direction:(ScrollPictureDirection)direction enableDragging:(BOOL)isEnabled;

@end
