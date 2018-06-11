//
//  ViewController.m
//  ScorllPictureDmo
//
//  Created by 刘晨阳 on 2018/5/23.
//  Copyright © 2018年 changba-mac. All rights reserved.
//

#import "ViewController.h"
#import "LCYScorllPictureView.h"

@interface ViewController ()<LCYScrollPictureDelegate>
@property (nonatomic, strong) NSMutableArray <UIImage *> *images;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _images = [[NSMutableArray alloc] init];
    for (int i = 1; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"picture-%d",i]];
        [_images addObject:image];
    }
    
    
    LCYScorllPictureView *view = [[LCYScorllPictureView alloc] initWithFrame:CGRectMake(100, 100, 40, 30) duration:2.0 direction:ScrollPictureDirectionBottom enableDragging:YES];
    [self.view addSubview:view];
    
    view.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LCYScrollPictureDelegate
- (NSInteger)numberOfTotalScrollCount
{
    return _images.count;
}

- (UIImage *)imageForScrollInIndex:(NSInteger)index
{
    return _images[index];
}

- (void)scrollAtTheIndex:(NSInteger)index
{
    
}
@end
