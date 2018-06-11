//
//  LCYScorllPictureView.m
//  ScorllPictureDmo
//
//  Created by 刘晨阳 on 2018/5/23.
//  Copyright © 2018年 changba-mac. All rights reserved.
//

#import "LCYScorllPictureView.h"
#import "NSTimer+NSDataTimer.h"
#define OwnWidth_LCY     (self.frame.size.width)
#define OwnHeight_LCY    (self.frame.size.height)

@interface LCYScorllPictureView()<UIScrollViewDelegate>
{
    NSInteger _totalPageCount;
    BOOL _enbleDragging;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) NSTimeInterval intervalDuration;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray <UIImageView *> *imageViews;
@end

@implementation LCYScorllPictureView
- (instancetype)initWithFrame:(CGRect)frame duration:(NSTimeInterval)interval direction:(ScrollPictureDirection)direction enableDragging:(BOOL)isEnabled
{
    if (self = [super initWithFrame:frame]) {
        _intervalDuration = interval;
        _direction = direction;
        _enbleDragging = isEnabled;
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [self initData];
    [self setUpScrollView];
    [self setUpTimer];
}

- (void)initData
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [_imageViews addObject:imageView];
        }
    }
}

- (void)setUpScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, OwnWidth_LCY, OwnHeight_LCY)];
    _scrollView.delegate = self;
    _scrollView.contentSize = (_direction == ScrollPictureDirectionRight || _direction == ScrollPictureDirectionLeft)?CGSizeMake(OwnWidth_LCY * 3, OwnHeight_LCY):CGSizeMake(OwnWidth_LCY , OwnHeight_LCY * 3);
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    _scrollView.scrollEnabled = _enbleDragging;
    [self addSubview:_scrollView];
}

- (void)setUpTimer
{
    if(!_timer){
        _timer = [NSTimer timerWithTimeInterval:_intervalDuration
                                         target:self
                                       selector:@selector(start:)
                                       userInfo:nil
                                        repeats:YES];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer pause];
    }
}

#pragma mark - set
- (void)setDelegate:(id<LCYScrollPictureDelegate>)delegate
{
    _delegate = delegate;
    [self reloadData];
    [_timer restartTimerAfterIntervalue:_intervalDuration];
}

#pragma mark - start scroll
- (void)start:(NSTimer *)timer
{
    CGFloat contentOffsetX = _scrollView.contentOffset.x;
    CGFloat contentOffSetY = _scrollView.contentOffset.y;
    switch (_direction) {
        case ScrollPictureDirectionLeft:
            contentOffsetX += OwnWidth_LCY;
            break;
        case ScrollPictureDirectionRight:
            contentOffsetX -= OwnWidth_LCY;
            break;
        case ScrollPictureDirectionTop:
            contentOffSetY += OwnHeight_LCY;
            break;
        case ScrollPictureDirectionBottom:
            contentOffSetY -= OwnHeight_LCY;
            break;
        default:
            break;
    }
    CGPoint contentOffset = CGPointMake(contentOffsetX, contentOffSetY);
    [_scrollView setContentOffset:contentOffset animated:YES];
}

#pragma mark - reload data
- (void)reloadData
{
    _currentPage = 0;
    _totalPageCount = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfTotalScrollCount)]) {
        _totalPageCount = [self.delegate numberOfTotalScrollCount];
        if (_totalPageCount <= 1) {
            [_timer pause];
        }
    }else{
        
    }
    [self resetScrollView];
}

- (void)resetScrollView
{
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger preIndex = [self getPreIndex:_currentPage];
    NSInteger curIndex = _currentPage;
    NSInteger nextIndex = [self getNextIndex:_currentPage];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageForScrollInIndex:)]) {
        UIImage *preImage = [self.delegate imageForScrollInIndex:preIndex];
        UIImage *curImage = [self.delegate imageForScrollInIndex:curIndex];
        UIImage *nextImage = [self.delegate imageForScrollInIndex:nextIndex];
        
        NSArray *images = @[preImage, curImage, nextImage];
        for (int i = 0; i < images.count; i++) {
            UIImageView *imageView = _imageViews[i];
            switch (_direction) {
                case ScrollPictureDirectionRight:
                case ScrollPictureDirectionLeft:
                    [imageView setFrame:CGRectMake(i * OwnWidth_LCY, 0, OwnWidth_LCY, OwnHeight_LCY)];
                    break;
                case ScrollPictureDirectionTop:
                case ScrollPictureDirectionBottom:
                    [imageView setFrame:CGRectMake(0, i * OwnHeight_LCY, OwnWidth_LCY, OwnHeight_LCY)];
                    break;
                default:
                    break;
            }
            
            [imageView setImage:images[i]];
            [_scrollView addSubview:imageView];
        }
        [_scrollView setContentOffset:(_direction == ScrollPictureDirectionRight || _direction == ScrollPictureDirectionLeft) ? CGPointMake(OwnWidth_LCY, 0) : CGPointMake(0, OwnHeight_LCY)];
    }
}

- (NSInteger)getPreIndex:(NSInteger)currentIndex
{
    if (currentIndex == 0) {
        return _totalPageCount - 1;
    }
    return currentIndex - 1;
}

- (NSInteger)getNextIndex:(NSInteger)currentIndex
{
    if (currentIndex == _totalPageCount - 1) {
        return 0;
    }
    return currentIndex + 1;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer pause];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_timer restartTimerAfterIntervalue:_intervalDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentSize = _scrollView.contentOffset;
    switch (_direction) {
        case ScrollPictureDirectionRight:
        {
            if (contentSize.x <= 0){
                _currentPage = [self getPreIndex:_currentPage];
                [self resetScrollView];
                if (self.delegate && [self.delegate respondsToSelector:@selector(scrollAtTheIndex:)]) {
                    [self.delegate scrollAtTheIndex:_currentPage];
                }
            }
        }
            break;
        case ScrollPictureDirectionBottom:
        {
            if (contentSize.y <= 0){
                _currentPage = [self getPreIndex:_currentPage];
                [self resetScrollView];
                if (self.delegate && [self.delegate respondsToSelector:@selector(scrollAtTheIndex:)]) {
                    [self.delegate scrollAtTheIndex:_currentPage];
                }
            }
        }
            break;
        case ScrollPictureDirectionLeft:
        {
            
            if (contentSize.x >= OwnWidth_LCY * 2) {
                _currentPage = [self getNextIndex:_currentPage];
                [self resetScrollView];
                if (self.delegate && [self.delegate respondsToSelector:@selector(scrollAtTheIndex:)]) {
                    [self.delegate scrollAtTheIndex:_currentPage];
                }
            }
        }
            break;
        case ScrollPictureDirectionTop:
        {
            
            if (contentSize.y >= OwnHeight_LCY * 2) {
                _currentPage = [self getNextIndex:_currentPage];
                [self resetScrollView];
                if (self.delegate && [self.delegate respondsToSelector:@selector(scrollAtTheIndex:)]) {
                    [self.delegate scrollAtTheIndex:_currentPage];
                }
            }
        }
            break;
        default:
            break;
    }
}

@end
